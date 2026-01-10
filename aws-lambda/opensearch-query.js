/**
 * AWS Lambda function to query OpenSearch for stock market data
 * Provides historical and vector search capabilities
 */

const AWS = require('aws-sdk');
const { defaultProvider } = require('@aws-sdk/credential-provider-node');
const { Client } = require('@opensearch-project/opensearch');
const { AwsSigv4Signer } = require('@opensearch-project/opensearch/aws');

const OPENSEARCH_ENDPOINT = process.env.OPENSEARCH_ENDPOINT || 'search-kite-stock-data-4phbzwci5cfo6jla7vs7yrjkcu.us-east-1.es.amazonaws.com';
const OPENSEARCH_INDEX = process.env.OPENSEARCH_INDEX || 'kite-stock-data';
const AWS_REGION = process.env.AWS_REGION || 'us-east-1';  // Lambda sets this automatically

// Create OpenSearch client with AWS Sigv4 auth
const client = new Client({
  ...AwsSigv4Signer({
    region: AWS_REGION,
    service: 'es',
    getCredentials: () => {
      const credentialsProvider = defaultProvider();
      return credentialsProvider();
    },
  }),
  node: `https://${OPENSEARCH_ENDPOINT}`,
});

// CORS headers
const headers = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  'Content-Type': 'application/json'
};

/**
 * Main Lambda handler
 */
exports.handler = async (event) => {
  console.log('Event:', JSON.stringify(event, null, 2));

  // Handle OPTIONS preflight
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers,
      body: ''
    };
  }

  try {
    const queryParams = event.queryStringParameters || {};
    const action = queryParams.action || 'recent';

    switch (action) {
      case 'recent':
        return await getRecentData(queryParams);
      case 'historical':
        return await getHistoricalData(queryParams);
      case 'search':
        return await vectorSearch(queryParams);
      case 'stats':
        return await getStats();
      default:
        return errorResponse(400, 'Invalid action');
    }
  } catch (error) {
    console.error('Error:', error);
    return errorResponse(500, error.message);
  }
};

/**
 * Get recent stock data (last N records)
 */
async function getRecentData(params) {
  const instrument = params.instrument;
  const limit = parseInt(params.limit || 100);

  const query = {
    index: OPENSEARCH_INDEX,
    body: {
      query: instrument ? {
        match: { 'metadata.instrument': instrument }
      } : {
        match_all: {}
      },
      sort: [{ 'metadata.timestamp': 'desc' }],
      size: limit
    }
  };

  const result = await client.search(query);
  
  return successResponse({
    count: result.body.hits.hits.length,
    data: result.body.hits.hits.map(hit => ({
      id: hit._id,
      instrument: hit._source.metadata.instrument,
      timestamp: hit._source.metadata.timestamp,
      is_live: hit._source.metadata.is_live,
      text: hit._source.text,
      score: hit._score
    }))
  });
}

/**
 * Get historical data for specific instrument and time range
 */
async function getHistoricalData(params) {
  const instrument = params.instrument;
  const from = params.from;
  const to = params.to;
  const limit = parseInt(params.limit || 1000);

  if (!instrument) {
    return errorResponse(400, 'instrument parameter is required');
  }

  const query = {
    index: OPENSEARCH_INDEX,
    body: {
      query: {
        bool: {
          must: [
            { match: { 'metadata.instrument': instrument } }
          ],
          filter: []
        }
      },
      sort: [{ 'metadata.timestamp': 'asc' }],
      size: limit
    }
  };

  // Add time range if provided
  if (from || to) {
    query.body.query.bool.filter.push({
      range: {
        'metadata.timestamp': {
          ...(from && { gte: from }),
          ...(to && { lte: to })
        }
      }
    });
  }

  const result = await client.search(query);
  
  return successResponse({
    instrument,
    count: result.body.hits.hits.length,
    data: result.body.hits.hits.map(hit => ({
      id: hit._id,
      timestamp: hit._source.metadata.timestamp,
      is_live: hit._source.metadata.is_live,
      text: hit._source.text
    }))
  });
}

/**
 * Vector similarity search for pattern matching
 */
async function vectorSearch(params) {
  const query = params.query;
  const k = parseInt(params.k || 5);

  if (!query) {
    return errorResponse(400, 'query parameter is required');
  }

  // This is a simple text search. For actual vector search,
  // you'd need to generate embeddings from the query text first
  const searchQuery = {
    index: OPENSEARCH_INDEX,
    body: {
      query: {
        multi_match: {
          query: query,
          fields: ['text', 'metadata.instrument']
        }
      },
      size: k
    }
  };

  const result = await client.search(searchQuery);
  
  return successResponse({
    query,
    count: result.body.hits.hits.length,
    results: result.body.hits.hits.map(hit => ({
      id: hit._id,
      instrument: hit._source.metadata.instrument,
      timestamp: hit._source.metadata.timestamp,
      text: hit._source.text,
      score: hit._score
    }))
  });
}

/**
 * Get index statistics
 */
async function getStats() {
  const stats = await client.indices.stats({ index: OPENSEARCH_INDEX });
  const count = await client.count({ index: OPENSEARCH_INDEX });
  
  return successResponse({
    index: OPENSEARCH_INDEX,
    document_count: count.body.count,
    size_in_bytes: stats.body._all.total.store.size_in_bytes,
    segments: stats.body._all.total.segments.count
  });
}

/**
 * Success response helper
 */
function successResponse(data) {
  return {
    statusCode: 200,
    headers,
    body: JSON.stringify({
      status: 'success',
      data
    })
  };
}

/**
 * Error response helper
 */
function errorResponse(statusCode, message) {
  return {
    statusCode,
    headers,
    body: JSON.stringify({
      status: 'error',
      message
    })
  };
}
