const crypto = require('crypto');

const API_KEY = 'j3xfcw2nl5v4lx3v';
const API_SECRET = 'd2jx1v3z138wb51njixjy4vtq55otooj';

exports.handler = async (event) => {
  const headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };

  // Handle CORS preflight
  if (event.httpMethod === 'OPTIONS' || event.requestContext?.http?.method === 'OPTIONS') {
    return { statusCode: 200, headers, body: '' };
  }

  try {
    const body = JSON.parse(event.body || '{}');
    const { request_token } = body;

    if (!request_token) {
      return {
        statusCode: 400,
        headers,
        body: JSON.stringify({ status: 'error', message: 'request_token is required' }),
      };
    }

    // Generate checksum
    const checksum = crypto
      .createHash('sha256')
      .update(API_KEY + request_token + API_SECRET)
      .digest('hex');

    // Exchange token with Kite
    const response = await fetch('https://api.kite.trade/session/token', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Kite-Version': '3',
      },
      body: new URLSearchParams({
        api_key: API_KEY,
        request_token: request_token,
        checksum: checksum,
      }),
    });

    const data = await response.json();
    console.log('Kite response:', JSON.stringify(data));

    if (data.status === 'error') {
      return {
        statusCode: 400,
        headers,
        body: JSON.stringify({ status: 'error', message: data.message }),
      };
    }

    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({
        status: 'success',
        data: {
          access_token: data.data.access_token,
          public_token: data.data.public_token,
          user_id: data.data.user_id,
          login_time: data.data.login_time,
        },
      }),
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ status: 'error', message: error.message }),
    };
  }
};
