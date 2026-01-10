# OpenSearch Historical Data Integration

## Overview

The Flutter web app now integrates with AWS OpenSearch to display historical stock market data alongside live Kite WebSocket feeds.

## Architecture

```
┌─────────────────────┐       ┌──────────────────────┐       ┌─────────────────────┐
│                     │       │                      │       │                     │
│  Flutter Web App    │──────▶│  API Gateway         │──────▶│  Lambda Function    │
│  (Live Charts Tab)  │       │  (REST API)          │       │  (Node.js)          │
│                     │       │                      │       │                     │
└─────────────────────┘       └──────────────────────┘       └─────────────────────┘
                                                                        │
                                                                        │
                                                                        ▼
┌─────────────────────┐       ┌──────────────────────┐       ┌─────────────────────┐
│                     │       │                      │       │                     │
│  Kite WebSocket     │       │  ECS Fargate         │──────▶│  OpenSearch         │
│  (Live Ticks)       │       │  (Data Collector)    │       │  (Vector Store)     │
│                     │       │                      │       │                     │
└─────────────────────┘       └──────────────────────┘       └─────────────────────┘
```

## Components

### 1. **Data Collection (ECS Fargate)**
- **Location**: `scripts/kite_integration.py`
- **Container**: Running on AWS ECS Fargate
- **Function**: Collects live market data from Kite Connect API
- **Storage**: Stores in OpenSearch with vector embeddings for semantic search
- **Backup**: Uploads to S3 as parquet files

### 2. **API Layer (Lambda + API Gateway)**
- **Lambda**: `aws-lambda/opensearch-query.js`
- **Endpoint**: `https://erkg1luks7.execute-api.us-east-1.amazonaws.com/prod/data`
- **Authentication**: AWS SigV4 (automatic via Lambda execution role)

### 3. **Flutter Integration**
- **File**: `lib/live_market_data_with_history.dart`
- **Features**:
  - Live WebSocket data from Kite
  - Historical data from OpenSearch via REST API
  - Candlestick charts with 1m, 5m, 15m intervals
  - IndexedDB caching for offline support

## API Endpoints

### Get Historical Data
```
GET https://erkg1luks7.execute-api.us-east-1.amazonaws.com/prod/data
    ?action=historical
    &instrument=256265
    &limit=500
```

**Response:**
```json
{
  "status": "success",
  "data": [
    {
      "instrument_token": 256265,
      "timestamp": 1673520000,
      "interval": "5m",
      "open": 18250.50,
      "high": 18275.25,
      "low": 18240.00,
      "close": 18260.75,
      "volume": 123456
    }
  ]
}
```

### Get Recent Data
```
GET https://erkg1luks7.execute-api.us-east-1.amazonaws.com/prod/data
    ?action=recent
    &limit=100
```

### Get Statistics
```
GET https://erkg1luks7.execute-api.us-east-1.amazonaws.com/prod/data
    ?action=stats
```

## Features

### Live Chart Tab

1. **Stock List**: Shows NIFTY indices with live prices
   - NIFTY 50
   - NIFTY BANK
   - NIFTY FIN SERVICE
   - NIFTY MIDCAP SELECT

2. **Historical Data Button**: 📊 Load Historical Data
   - Fetches up to 500 historical candles from OpenSearch
   - Merges with live data seamlessly
   - Shows "Historical Data" badge when loaded

3. **Interval Selector**: Switch between 1m, 5m, 15m candles

4. **Real-time Updates**: Live WebSocket connection with Kite

5. **Persistent Storage**: IndexedDB caching for offline viewing

## Deployment

### Lambda Function
```bash
cd /home/aj/Documents/Projects/thegreatbulls
./deploy-opensearch-api.sh
```

### Flutter App
```bash
flutter run -d web-server --web-port 8080
```

## Configuration

### Environment Variables

**Lambda (set in deployment script)**:
- `OPENSEARCH_ENDPOINT`: OpenSearch domain endpoint
- `AWS_REGION`: Automatically set by Lambda (us-east-1)

**Flutter (hardcoded in widget)**:
- `OPENSEARCH_API`: API Gateway endpoint URL
- `KiteConfig.apiKey`: Kite Connect API key

### IAM Permissions

Lambda execution role needs:
- `es:ESHttpGet`, `es:ESHttpPost` on OpenSearch domain
- `logs:CreateLogGroup`, `logs:CreateLogStream`, `logs:PutLogEvents`

## Data Flow

1. **Collection**: ECS task collects ticks from Kite WebSocket
2. **Storage**: Data stored in OpenSearch with embeddings
3. **Query**: Flutter app requests historical data via API Gateway
4. **Lambda**: Queries OpenSearch and returns formatted data
5. **Display**: Charts merge historical + live data seamlessly

## Monitoring

### ECS Service Status
```bash
aws ecs describe-services \
  --cluster kite-cluster \
  --services kite-collector-service
```

### Lambda Logs
```bash
aws logs tail /aws/lambda/opensearch-query-function --follow
```

### OpenSearch Index
```bash
curl "https://erkg1luks7.execute-api.us-east-1.amazonaws.com/prod/data?action=stats"
```

## Troubleshooting

### No Historical Data Available

**Possible causes:**
1. ECS collector not running
2. No data collected yet (wait a few minutes)
3. OpenSearch index empty

**Solution:**
```bash
# Check ECS service
aws ecs describe-services --cluster kite-cluster --services kite-collector-service

# Check Lambda logs
aws logs tail /aws/lambda/opensearch-query-function --follow

# Check OpenSearch stats
curl "https://erkg1luks7.execute-api.us-east-1.amazonaws.com/prod/data?action=stats"
```

### CORS Errors

**Solution:** API Gateway is configured with CORS enabled for all origins:
- `AllowOrigins: "*"`
- `AllowMethods: "GET,POST,OPTIONS"`
- `AllowHeaders: "*"`

### WebSocket Connection Failed

**Possible causes:**
1. Not logged in (no access token)
2. Invalid Kite API credentials
3. Access token expired

**Solution:**
1. Login via OAuth flow first
2. Check `localStorage.getItem('access_token')`
3. Re-authenticate if token expired

## Future Enhancements

1. **Pattern Recognition**: Use OpenSearch vector search to find similar patterns
2. **AI Predictions**: Display AI-generated predictions from the insights page
3. **More Instruments**: Add support for all NSE stocks
4. **Timeframe Selection**: Add date range picker for historical data
5. **Export**: Download chart data as CSV
6. **Alerts**: Set price alerts based on historical patterns

## Resources

- **OpenSearch API**: https://erkg1luks7.execute-api.us-east-1.amazonaws.com/prod/data
- **ECS Task Definition**: `scripts/task-definition.json`
- **Lambda Function**: `aws-lambda/opensearch-query.js`
- **Flutter Widget**: `lib/live_market_data_with_history.dart`
- **Deployment Script**: `deploy-opensearch-api.sh`
