const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, PutCommand, QueryCommand, BatchWriteCommand } = require('@aws-sdk/lib-dynamodb');

const client = new DynamoDBClient({ region: 'ap-south-1' });
const docClient = DynamoDBDocumentClient.from(client);

const TABLE_NAME = 'thegreatbulls-ticks';
const CANDLES_TABLE = 'thegreatbulls-candles';

// CORS headers
const headers = {
  'Content-Type': 'application/json',
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization'
};

exports.handler = async (event) => {
  console.log('Event:', JSON.stringify(event));
  
  // Handle OPTIONS for CORS
  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 200, headers, body: '' };
  }
  
  const path = event.path || event.rawPath;
  const method = event.httpMethod || event.requestContext?.http?.method;
  
  try {
    // POST /ticks - Store batch of ticks
    if (path === '/ticks' && method === 'POST') {
      const body = JSON.parse(event.body);
      const { ticks } = body; // Array of tick objects
      
      if (!ticks || !Array.isArray(ticks) || ticks.length === 0) {
        return { statusCode: 400, headers, body: JSON.stringify({ error: 'ticks array required' }) };
      }
      
      // Batch write ticks
      const putRequests = ticks.map(tick => ({
        PutRequest: {
          Item: {
            token: tick.token,
            timestamp: tick.timestamp,
            price: tick.price,
            volume: tick.volume || 0,
            open: tick.open || tick.price,
            high: tick.high || tick.price,
            low: tick.low || tick.price,
            close: tick.close || tick.price,
            buyQty: tick.buyQty || 0,
            sellQty: tick.sellQty || 0,
            ttl: Math.floor(Date.now() / 1000) + (7 * 24 * 60 * 60) // 7 days TTL
          }
        }
      }));
      
      // DynamoDB batch write limit is 25 items
      for (let i = 0; i < putRequests.length; i += 25) {
        const batch = putRequests.slice(i, i + 25);
        await docClient.send(new BatchWriteCommand({
          RequestItems: { [TABLE_NAME]: batch }
        }));
      }
      
      return { statusCode: 200, headers, body: JSON.stringify({ success: true, count: ticks.length }) };
    }
    
    // GET /ticks/{token} - Get ticks for a stock
    if (path.startsWith('/ticks/') && method === 'GET') {
      const token = path.split('/')[2];
      const queryParams = event.queryStringParameters || {};
      const hours = parseInt(queryParams.hours) || 4; // Default last 4 hours
      const since = Date.now() - (hours * 60 * 60 * 1000);
      
      const result = await docClient.send(new QueryCommand({
        TableName: TABLE_NAME,
        KeyConditionExpression: '#token = :token AND #ts >= :since',
        ExpressionAttributeNames: { '#token': 'token', '#ts': 'timestamp' },
        ExpressionAttributeValues: { ':token': parseInt(token), ':since': since },
        ScanIndexForward: true // Oldest first
      }));
      
      return { statusCode: 200, headers, body: JSON.stringify({ ticks: result.Items || [] }) };
    }
    
    // POST /candles - Store aggregated candles
    if (path === '/candles' && method === 'POST') {
      const body = JSON.parse(event.body);
      const { candles } = body;
      
      if (!candles || !Array.isArray(candles)) {
        return { statusCode: 400, headers, body: JSON.stringify({ error: 'candles array required' }) };
      }
      
      const putRequests = candles.map(candle => ({
        PutRequest: {
          Item: {
            token_interval: `${candle.token}_${candle.interval}`, // Partition key
            timestamp: candle.timestamp, // Sort key
            open: candle.open,
            high: candle.high,
            low: candle.low,
            close: candle.close,
            volume: candle.volume || 0,
            ttl: Math.floor(Date.now() / 1000) + (30 * 24 * 60 * 60) // 30 days TTL
          }
        }
      }));
      
      for (let i = 0; i < putRequests.length; i += 25) {
        const batch = putRequests.slice(i, i + 25);
        await docClient.send(new BatchWriteCommand({
          RequestItems: { [CANDLES_TABLE]: batch }
        }));
      }
      
      return { statusCode: 200, headers, body: JSON.stringify({ success: true, count: candles.length }) };
    }
    
    // GET /candles/{token} - Get candles for charting
    if (path.startsWith('/candles/') && method === 'GET') {
      const token = path.split('/')[2];
      const queryParams = event.queryStringParameters || {};
      const interval = queryParams.interval || '1m'; // 1m, 5m, 15m, 1h
      const hours = parseInt(queryParams.hours) || 8;
      const since = Date.now() - (hours * 60 * 60 * 1000);
      
      const result = await docClient.send(new QueryCommand({
        TableName: CANDLES_TABLE,
        KeyConditionExpression: '#pk = :pk AND #ts >= :since',
        ExpressionAttributeNames: { '#pk': 'token_interval', '#ts': 'timestamp' },
        ExpressionAttributeValues: { ':pk': `${token}_${interval}`, ':since': since },
        ScanIndexForward: true
      }));
      
      return { statusCode: 200, headers, body: JSON.stringify({ candles: result.Items || [] }) };
    }
    
    // Health check
    if (path === '/health') {
      return { statusCode: 200, headers, body: JSON.stringify({ status: 'ok' }) };
    }
    
    return { statusCode: 404, headers, body: JSON.stringify({ error: 'Not found' }) };
    
  } catch (error) {
    console.error('Error:', error);
    return { statusCode: 500, headers, body: JSON.stringify({ error: error.message }) };
  }
};
