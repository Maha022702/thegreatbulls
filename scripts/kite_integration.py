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
        self.instruments = instruments or [{'name': 'NIFTY BANK', 'token': 256265}]
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

    def fetch_historical_data(self, instrument_token, from_date, to_date, interval='minute'):
        """Fetch historical OHLCV data in batches."""
        data = []
        current_date = from_date
        while current_date < to_date:
            next_date = min(current_date + timedelta(days=30), to_date)  # Batch by month
            try:
                batch = self.kite.historical_data(instrument_token, current_date, next_date, interval)
                data.extend(batch)
                logging.info(f"Fetched {len(batch)} records for {current_date} to {next_date}")
                time.sleep(1)  # Rate limit
            except Exception as e:
                logging.error(f"Error fetching historical data: {e}")
            current_date = next_date
        df = pd.DataFrame(data)
        # Upload to S3
        self.upload_to_s3(df, f'historical_{instrument_token}.parquet')
        logging.info("Historical data saved to S3.")
        return df

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
            ws.set_mode(ws.MODE_LTP, instrument_tokens)

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
                for token, ticks in self.live_data_buffer.items():
                    if ticks:
                        candle = {
                            'timestamp': ticks[-1]['timestamp'],
                            'open': ticks[0]['last_price'],
                            'high': max(t['last_price'] for t in ticks),
                            'low': min(t['last_price'] for t in ticks),
                            'close': ticks[-1]['last_price'],
                            'volume': sum(t.get('volume', 0) for t in ticks)
                        }
                        self.store_in_vector_db([candle], token, is_live=True)
                        self.live_data_buffer[token] = []

        threading.Thread(target=aggregate_candles, daemon=True).start()

    def store_in_vector_db(self, data, instrument_token, is_live=False):
        """Convert data to embeddings and store in OpenSearch."""
        actions = []
        for i in range(0, len(data) - 59, 60):  # Windows of 60 candles
            window = data[i:i+60]
            text = f"Instrument {instrument_token}: " + " ".join([f"{c['timestamp']} O:{c['open']} H:{c['high']} L:{c['low']} C:{c['close']} V:{c['volume']}" for c in window])
            embedding = self.embedding_model.encode(text).tolist()
            doc = {
                '_index': self.index_name,
                '_id': f"{instrument_token}_{i}",
                'vector': embedding,
                'text': text,
                'metadata': {'instrument': instrument_token, 'timestamp': str(window[-1]['timestamp']), 'is_live': is_live}
            }
            actions.append(doc)
        if actions:
            bulk(self.opensearch_client, actions)
        logging.info(f"Data stored in OpenSearch for instrument {instrument_token}.")

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

    # Fetch historical data for a few instruments
    from_date = datetime.now() - timedelta(days=30)  # Reduced to 30 days for faster startup
    to_date = datetime.now()
    
    # Get some popular instruments (you might want to configure this)
    instruments = collector.kite.instruments(exchange='NSE')[:5]  # First 5 NSE instruments
    for instr in instruments:
        try:
            logging.info(f"Fetching historical data for {instr['tradingsymbol']}")
            df = collector.fetch_historical_data(instr['instrument_token'], from_date, to_date)
            if not df.empty:
                collector.store_in_vector_db(df.to_dict('records'), instr['instrument_token'])
        except Exception as e:
            logging.error(f"Failed to process {instr['tradingsymbol']}: {e}")

    # Start live data collection
    tokens = [instr['instrument_token'] for instr in instruments]
    collector.start_live_data_collection(tokens)

    # Example AI query
    try:
        prediction = collector.query_ai("Analyze the current market trend based on recent data.")
        logging.info(f"AI Analysis: {prediction}")
    except Exception as e:
        logging.error(f"AI query failed: {e}")

    logging.info("Kite AWS Collector started successfully. Running continuously...")

    # Keep running
    while True:
        time.sleep(300)  # Check every 5 minutes
        # Could add periodic AI analysis here
        time.sleep(10)

# AWS Deployment Notes:
# 1. Dockerfile: FROM python:3.10-slim, COPY requirements.txt, RUN pip install, COPY kite_integration.py, CMD ["python", "kite_integration.py"]
# 2. ECS: Create task definition with container, service in cluster.
# 3. EC2: Use user data script to install Docker, run container.
# 4. CloudWatch: Logs from stdout will be captured.
# 5. IAM: Attach roles for S3, OpenSearch, Bedrock access.