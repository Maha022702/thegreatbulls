# Comprehensive Zerodha Kite Connect Integration Script with AWS Deployment
# This script handles authentication, historical/live data collection, vector database storage with Amazon OpenSearch,
# and AI-powered stock analysis using Amazon Bedrock via LangChain.

# Dependencies (install via pip):
# pip install kiteconnect sentence-transformers opensearch-py langchain langchain-community langchain-aws boto3 pandas

import os
import time
import logging
import threading
import pandas as pd
from datetime import datetime, timedelta
from kiteconnect import KiteConnect, KiteTicker
from sentence_transformers import SentenceTransformer
from opensearchpy import OpenSearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth
from opensearchpy.helpers import bulk
import boto3
from botocore.exceptions import ClientError
from langchain_community.vectorstores import OpenSearchVectorSearch
from langchain_community.embeddings import SentenceTransformerEmbeddings
from langchain_aws import BedrockLLM
# from langchain.chains import RetrievalQA  # Temporarily commented out

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class KiteAWSCollector:
    def __init__(self, api_key, api_secret, aws_region, opensearch_endpoint, bedrock_model_id, instruments=None):
        self.api_key = api_key
        self.api_secret = api_secret
        self.aws_region = aws_region
        self.opensearch_endpoint = opensearch_endpoint
        self.bedrock_model_id = bedrock_model_id
        self.kite = KiteConnect(api_key=self.api_key)
        self.access_token = None
        # Focus on NIFTY50 for world-class charts
        self.instruments = instruments or [{'name': 'NIFTY 50', 'token': 256265}]
        self.live_data_buffer = {}  # For aggregating live ticks into candles
        self.embedding_model = SentenceTransformer('all-MiniLM-L6-v2')
        self.index_name = 'kite-stock-data'
        self.s3_client = boto3.client('s3', region_name=self.aws_region)
        self.s3_bucket = 'kite-data-backup'  # Assume bucket exists or create it
        self.setup_opensearch()

    def setup_opensearch(self):
        """Setup OpenSearch client with AWS credentials."""
        credentials = boto3.Session().get_credentials()
        awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, self.aws_region, 'es', session_token=credentials.token)
        self.opensearch_client = OpenSearch(
            hosts=[{'host': self.opensearch_endpoint, 'port': 443}],
            http_auth=awsauth,
            use_ssl=True,
            verify_certs=True,
            connection_class=RequestsHttpConnection
        )
        # Create index if not exists
        if not self.opensearch_client.indices.exists(index=self.index_name):
            index_body = {
                "mappings": {
                    "properties": {
                        "vector": {"type": "knn_vector", "dimension": 384},
                        "text": {"type": "text"},
                        "metadata": {"type": "object"}
                    }
                },
                "settings": {
                    "index": {
                        "knn": True
                    }
                }
            }
            self.opensearch_client.indices.create(index=self.index_name, body=index_body)
        logging.info("OpenSearch setup complete.")

    def authenticate(self):
        """Handle full authentication flow."""
        try:
            login_url = self.kite.login_url()
            print(f"Visit this URL to login: {login_url}")
            request_token = input("Enter the request_token from the redirect URL: ").strip()
            data = self.kite.generate_session(request_token, api_secret=self.api_secret)
            self.access_token = data['access_token']
            self.kite.set_access_token(self.access_token)
            logging.info("Authentication successful.")
            # Test with user profile
            profile = self.kite.profile()
            logging.info(f"User Profile: {profile}")
        except Exception as e:
            logging.error(f"Authentication failed: {e}")
            raise

    def fetch_historical_data(self, instrument_token, from_date=None, to_date=None, interval='minute'):
        """Fetch maximum historical OHLCV data for world-class charts."""
        # If no dates provided, fetch maximum available (up to 2 years back)
        if from_date is None:
            # Kite Connect allows up to 2 years of historical data
            from_date = datetime.now() - timedelta(days=730)  # 2 years
        if to_date is None:
            to_date = datetime.now()

        logging.info(f"Fetching historical data for instrument {instrument_token} from {from_date} to {to_date}")

        data = []
        current_date = from_date
        total_batches = 0
        total_records = 0

        while current_date < to_date:
            next_date = min(current_date + timedelta(days=30), to_date)  # Batch by month
            try:
                batch = self.kite.historical_data(instrument_token, current_date, next_date, interval)
                if batch:
                    data.extend(batch)
                    total_batches += 1
                    total_records += len(batch)
                    logging.info(f"Fetched {len(batch)} records for {current_date.strftime('%Y-%m-%d')} to {next_date.strftime('%Y-%m-%d')} (Total: {total_records})")
                else:
                    logging.warning(f"No data for {current_date.strftime('%Y-%m-%d')} to {next_date.strftime('%Y-%m-%d')}")

                time.sleep(0.5)  # Rate limit: 2 requests per second
            except Exception as e:
                logging.error(f"Error fetching historical data for {current_date.strftime('%Y-%m-%d')}: {e}")
                time.sleep(2)  # Wait longer on error

            current_date = next_date

        logging.info(f"Completed fetching {total_records} historical records in {total_batches} batches for instrument {instrument_token}")

        if data:
            df = pd.DataFrame(data)
            # Upload to S3 (optional - skip if pyarrow not available)
            try:
                self.upload_to_s3(df, f'historical_{instrument_token}_{interval}_{from_date.strftime("%Y%m%d")}_{to_date.strftime("%Y%m%d")}.parquet')
                logging.info("Historical data saved to S3.")
            except Exception as e:
                logging.warning(f"Could not save to S3: {e}")

        return data

    def upload_to_s3(self, df, key):
        """Upload DataFrame to S3 as Parquet."""
        try:
            df.to_parquet('/tmp/temp.parquet')
            self.s3_client.upload_file('/tmp/temp.parquet', self.s3_bucket, key)
            logging.info(f"Uploaded {key} to S3.")
        except ClientError as e:
            logging.error(f"S3 upload failed: {e}")

    def start_live_data_collection(self, instrument_tokens):
        """Start websocket for live data using KiteTicker."""
        def on_ticks(ws, ticks):
            for tick in ticks:
                token = tick['instrument_token']
                if token not in self.live_data_buffer:
                    self.live_data_buffer[token] = []
                self.live_data_buffer[token].append(tick)

        def on_connect(ws, response):
            logging.info("WebSocket connected.")
            ws.subscribe(instrument_tokens)
            ws.set_mode(ws.MODE_FULL, instrument_tokens)  # Use FULL mode to get all fields

        def on_close(ws, code, reason):
            logging.info("WebSocket closed.")

        kws = KiteTicker(self.api_key, self.access_token)
        kws.on_ticks = on_ticks
        kws.on_connect = on_connect
        kws.on_close = on_close
        kws.connect(threaded=True)
        logging.info("Live data collection started.")

        # Thread for aggregating ticks into candles
        def aggregate_candles():
            while True:
                time.sleep(60)  # Every minute
                for token, ticks in list(self.live_data_buffer.items()):
                    if ticks and len(ticks) > 0:
                        try:
                            # Use current timestamp if tick doesn't have one
                            current_time = datetime.now()
                            candle = {
                                'timestamp': ticks[-1].get('timestamp', current_time),
                                'open': ticks[0].get('last_price', 0),
                                'high': max((t.get('last_price', 0) for t in ticks), default=0),
                                'low': min((t.get('last_price', 0) for t in ticks if t.get('last_price', 0) > 0), default=0),
                                'close': ticks[-1].get('last_price', 0),
                                'volume': sum(t.get('volume', 0) for t in ticks)
                            }
                            if candle['close'] > 0:  # Only store valid candles
                                self.store_in_vector_db([candle], token, is_live=True)
                        except Exception as e:
                            logging.error(f"Error aggregating candles for token {token}: {e}")
                        finally:
                            self.live_data_buffer[token] = []

        threading.Thread(target=aggregate_candles, daemon=True).start()

    def store_in_vector_db(self, data, instrument_token, is_live=False):
        """Convert data to embeddings and store in OpenSearch."""
        actions = []

        # For live data, store individual candles; for historical, use windows
        window_size = 1 if is_live else 60
        step_size = 1 if is_live else 60

        for i in range(0, len(data), step_size):
            window = data[i:i+window_size] if not is_live else [data[i]]
            if not window:
                continue

            last_candle = window[-1]

            # Handle different data structures for live vs historical data
            if is_live:
                # Live data structure
                timestamp = last_candle.get('timestamp', datetime.now())
                open_price = last_candle.get('open', 0)
                high_price = last_candle.get('high', 0)
                low_price = last_candle.get('low', 0)
                close_price = last_candle.get('close', 0)
                volume = last_candle.get('volume', 0)
            else:
                # Historical data structure from Kite Connect
                timestamp = last_candle.get('date', datetime.now())
                open_price = last_candle.get('open', 0)
                high_price = last_candle.get('high', 0)
                low_price = last_candle.get('low', 0)
                close_price = last_candle.get('close', 0)
                volume = last_candle.get('volume', 0)

            # Generate text for embedding (use consistent timestamp format)
            ts_str = str(timestamp)
            text = f"Instrument {instrument_token}: {ts_str} O:{open_price} H:{high_price} L:{low_price} C:{close_price} V:{volume}"
            embedding = self.embedding_model.encode(text).tolist()

            # Use timestamp in ID for uniqueness
            ts = str(timestamp).replace(' ', '_').replace(':', '-').replace('-', '_')
            doc_id = f"{instrument_token}_{ts}_{i}"

            # Store structured candle data for easy querying
            doc = {
                '_index': self.index_name,
                '_id': doc_id,
                'vector': embedding,
                'text': text,
                'instrument': str(instrument_token),
                'timestamp': str(timestamp),
                'open': float(open_price),
                'high': float(high_price),
                'low': float(low_price),
                'close': float(close_price),
                'volume': int(volume),
                'interval': '1m',  # Current interval
                'is_live': is_live,
                'metadata': {
                    'instrument': str(instrument_token),
                    'timestamp': str(timestamp),
                    'is_live': is_live
                }
            }
            actions.append(doc)

        if actions:
            try:
                success, failed = bulk(self.opensearch_client, actions, raise_on_error=False)
                logging.info(f"Data stored in OpenSearch for instrument {instrument_token}: {success} successful, {len(failed)} failed")
                if failed:
                    logging.error(f"Failed items: {failed[:3]}")  # Log first 3 failures
            except Exception as e:
                logging.error(f"Error storing data in OpenSearch: {e}")
        else:
            logging.warning(f"No data to store for instrument {instrument_token}")

    def setup_ai_integration(self):
        """Setup LangChain for RAG with Bedrock."""
        # Temporarily disabled for basic functionality
        logging.info("AI integration temporarily disabled.")
        pass
        # embeddings = SentenceTransformerEmbeddings(model_name='all-MiniLM-L6-v2')
        # vectorstore = OpenSearchVectorSearch(
        #     opensearch_url=self.opensearch_endpoint,
        #     index_name=self.index_name,
        #     embedding_function=embeddings,
        #     http_auth=self.opensearch_client._http_auth,
        #     use_ssl=True,
        #     verify_certs=True
        # )
        # llm = BedrockLLM(model_id=self.bedrock_model_id, region_name=self.aws_region)
        # self.qa_chain = RetrievalQA.from_chain_type(llm=llm, chain_type='stuff', retriever=vectorstore.as_retriever(search_kwargs={'k': 5}))

    def query_ai(self, query):
        """Query AI for analysis/predictions."""
        # Temporarily disabled
        logging.info(f"AI query disabled: {query}")
        return "AI integration temporarily disabled"

# Main execution
if __name__ == "__main__":
    # Load from env vars
    api_key = os.getenv('KITE_API_KEY')
    api_secret = os.getenv('KITE_API_SECRET')
    access_token = os.getenv('KITE_ACCESS_TOKEN')  # Add access token from env
    aws_region = os.getenv('AWS_REGION', 'us-east-1')
    opensearch_endpoint = os.getenv('OPENSEARCH_ENDPOINT')
    bedrock_model_id = os.getenv('BEDROCK_MODEL_ID', 'anthropic.claude-v2')

    if not all([api_key, api_secret, opensearch_endpoint]):
        raise ValueError("Missing required environment variables.")

    collector = KiteAWSCollector(api_key, api_secret, aws_region, opensearch_endpoint, bedrock_model_id)

    # Authenticate - use existing token if available
    if access_token:
        collector.kite.set_access_token(access_token)
        collector.access_token = access_token
        logging.info(f"Using access token from environment: {access_token[:10]}...")
    else:
        logging.error("No access token provided in environment variables!")
        exit(1)

    # Test connection
    try:
        profile = collector.kite.profile()
        logging.info(f"✅ Connected to Kite API for user: {profile.get('user_name', 'Unknown')} (ID: {profile.get('user_id', 'N/A')})")
        logging.info(f"Email: {profile.get('email', 'N/A')}")
        logging.info(f"Exchanges: {', '.join(profile.get('exchanges', []))}")
    except Exception as e:
        logging.error(f"❌ Failed to connect to Kite API: {e}")
        logging.error(f"API Key: {api_key[:10]}...")
        logging.error(f"Access Token: {access_token[:10] if access_token else 'None'}...")
        exit(1)

    # Setup AI integration first
    collector.setup_ai_integration()
    logging.info("AI integration setup complete.")

    # Fetch maximum historical data for NIFTY50 for world-class charts
    logging.info("🚀 Starting maximum historical data collection for NIFTY50...")

    nifty50_token = 256265  # NIFTY50 instrument token
    nifty50_name = "NIFTY 50"

    try:
        logging.info(f"📊 Fetching maximum historical data for {nifty50_name} (token: {nifty50_token})")

        # Fetch maximum available historical data (2 years)
        historical_data = collector.fetch_historical_data(nifty50_token, interval='minute')

        if historical_data:
            logging.info(f"✅ Fetched {len(historical_data)} historical records for {nifty50_name}")

            # Store in OpenSearch for vector search and retrieval
            collector.store_in_vector_db(historical_data, nifty50_token, is_live=False)
            logging.info(f"✅ Stored historical data in OpenSearch for {nifty50_name}")
        else:
            logging.warning(f"⚠️ No historical data fetched for {nifty50_name}")

    except Exception as e:
        logging.error(f"❌ Failed to fetch historical data for {nifty50_name}: {e}")

    # Start live data collection for NIFTY50 only
    logging.info("📡 Starting live data collection for NIFTY50...")
    collector.start_live_data_collection([nifty50_token])

    logging.info("🎯 NIFTY50 data collection setup complete!")
    logging.info("📈 Historical data available for world-class charts")
    logging.info("🔄 Live data collection running continuously")

    # Start live data collection for NIFTY50 only
    logging.info("📡 Starting live data collection for NIFTY50...")
    collector.start_live_data_collection([nifty50_token])

    logging.info("🎯 NIFTY50 data collection setup complete!")
    logging.info("📈 Historical data available for world-class charts")
    logging.info("🔄 Live data collection running continuously")

    # Keep running
    while True:
        time.sleep(300)  # Check every 5 minutes
        logging.info("🔄 Collector still running - NIFTY50 data collection active")

# AWS Deployment Notes:
# 1. Dockerfile: FROM python:3.10-slim, COPY requirements.txt, RUN pip install, COPY kite_integration.py, CMD ["python", "kite_integration.py"]
# 2. ECS: Create task definition with container, service in cluster.
# 3. EC2: Use user data script to install Docker, run container.
# 4. CloudWatch: Logs from stdout will be captured.
# 5. IAM: Attach roles for S3, OpenSearch, Bedrock access.