const express = require('express');
const cors = require('cors');
const axios = require('axios');
const crypto = require('crypto');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Kite API Configuration
const KITE_API_KEY = process.env.KITE_API_KEY;
const KITE_API_SECRET = process.env.KITE_API_SECRET;
const KITE_API_URL = 'https://api.kite.trade';
const KITE_LOGIN_URL = 'https://kite.zerodha.com/connect/login';
const FRONTEND_URL = process.env.FRONTEND_URL || 'http://localhost:8080';

// In-memory token storage (use Redis/DB in production)
const tokenStore = new Map();

// Middleware
app.use(cors({
  origin: [FRONTEND_URL, 'http://localhost:8080', 'http://127.0.0.1:8080', 'https://www.thegreatbulls.in', 'https://thegreatbulls.in'],
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Generate SHA256 checksum
function generateChecksum(requestToken) {
  const message = `${KITE_API_KEY}${requestToken}${KITE_API_SECRET}`;
  return crypto.createHash('sha256').update(message).digest('hex');
}

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Get login URL
app.get('/api/login-url', (req, res) => {
  const state = Date.now().toString();
  const redirectUri = encodeURIComponent(process.env.KITE_REDIRECT_URI);
  const loginUrl = `${KITE_LOGIN_URL}?v=3&api_key=${KITE_API_KEY}&redirect_uri=${redirectUri}&state=${state}`;
  
  console.log('📤 Generated login URL:', loginUrl);
  res.json({ loginUrl, state });
});

// Exchange request token for access token
app.post('/api/token', async (req, res) => {
  const { request_token } = req.body;
  
  if (!request_token) {
    return res.status(400).json({ error: 'request_token is required' });
  }

  console.log('🔄 Exchanging request token:', request_token);

  try {
    const checksum = generateChecksum(request_token);
    console.log('🔐 Generated checksum:', checksum);

    const response = await axios.post(
      `${KITE_API_URL}/session/token`,
      new URLSearchParams({
        api_key: KITE_API_KEY,
        request_token: request_token,
        checksum: checksum
      }),
      {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Kite-Version': '3'
        }
      }
    );

    console.log('✅ Token exchange successful');
    console.log('📥 Response:', JSON.stringify(response.data, null, 2));

    if (response.data.status === 'success') {
      const { access_token, public_token, user_id } = response.data.data;
      
      // Store tokens (keyed by user_id for simplicity)
      tokenStore.set(user_id, {
        access_token,
        public_token,
        created_at: new Date().toISOString()
      });

      // Also store with a simple session key for the frontend
      const sessionId = crypto.randomBytes(32).toString('hex');
      tokenStore.set(sessionId, {
        access_token,
        public_token,
        user_id,
        created_at: new Date().toISOString()
      });

      res.json({
        status: 'success',
        data: {
          access_token,
          public_token,
          user_id,
          session_id: sessionId
        }
      });
    } else {
      res.status(400).json(response.data);
    }
  } catch (error) {
    console.error('❌ Token exchange error:', error.response?.data || error.message);
    res.status(error.response?.status || 500).json({
      error: 'Token exchange failed',
      details: error.response?.data || error.message
    });
  }
});

// Proxy API requests to Kite
async function proxyKiteRequest(req, res, endpoint, method = 'GET') {
  const authHeader = req.headers.authorization;
  
  if (!authHeader) {
    return res.status(401).json({ error: 'Authorization header required' });
  }

  try {
    const config = {
      method,
      url: `${KITE_API_URL}${endpoint}`,
      headers: {
        'Authorization': authHeader,
        'X-Kite-Version': '3'
      }
    };

    if (method === 'POST' && req.body) {
      config.data = req.body;
    }

    console.log(`📡 Proxying ${method} request to: ${config.url}`);
    const response = await axios(config);
    res.json(response.data);
  } catch (error) {
    console.error(`❌ API Error for ${endpoint}:`, error.response?.data || error.message);
    res.status(error.response?.status || 500).json({
      error: 'API request failed',
      details: error.response?.data || error.message
    });
  }
}

// User Profile
app.get('/api/user/profile', (req, res) => proxyKiteRequest(req, res, '/user/profile'));

// User Margins
app.get('/api/user/margins', (req, res) => proxyKiteRequest(req, res, '/user/margins'));
app.get('/api/user/margins/:segment', (req, res) => proxyKiteRequest(req, res, `/user/margins/${req.params.segment}`));

// Portfolio - Holdings
app.get('/api/portfolio/holdings', (req, res) => proxyKiteRequest(req, res, '/portfolio/holdings'));

// Portfolio - Positions
app.get('/api/portfolio/positions', (req, res) => proxyKiteRequest(req, res, '/portfolio/positions'));

// Orders
app.get('/api/orders', (req, res) => proxyKiteRequest(req, res, '/orders'));
app.get('/api/orders/:order_id', (req, res) => proxyKiteRequest(req, res, `/orders/${req.params.order_id}`));
app.get('/api/orders/:order_id/trades', (req, res) => proxyKiteRequest(req, res, `/orders/${req.params.order_id}/trades`));

// Place Order
app.post('/api/orders/:variety', async (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ error: 'Authorization header required' });
  }

  try {
    const response = await axios.post(
      `${KITE_API_URL}/orders/${req.params.variety}`,
      new URLSearchParams(req.body),
      {
        headers: {
          'Authorization': authHeader,
          'X-Kite-Version': '3',
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      }
    );
    res.json(response.data);
  } catch (error) {
    console.error('❌ Order placement error:', error.response?.data || error.message);
    res.status(error.response?.status || 500).json({
      error: 'Order placement failed',
      details: error.response?.data || error.message
    });
  }
});

// Market Quotes
app.get('/api/quote', async (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ error: 'Authorization header required' });
  }

  try {
    const instruments = req.query.i;
    const response = await axios.get(
      `${KITE_API_URL}/quote?i=${instruments}`,
      {
        headers: {
          'Authorization': authHeader,
          'X-Kite-Version': '3'
        }
      }
    );
    res.json(response.data);
  } catch (error) {
    console.error('❌ Quote error:', error.response?.data || error.message);
    res.status(error.response?.status || 500).json({
      error: 'Quote request failed',
      details: error.response?.data || error.message
    });
  }
});

// OHLC data
app.get('/api/quote/ohlc', async (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ error: 'Authorization header required' });
  }

  try {
    const instruments = req.query.i;
    const response = await axios.get(
      `${KITE_API_URL}/quote/ohlc?i=${instruments}`,
      {
        headers: {
          'Authorization': authHeader,
          'X-Kite-Version': '3'
        }
      }
    );
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({
      error: 'OHLC request failed',
      details: error.response?.data || error.message
    });
  }
});

// LTP data
app.get('/api/quote/ltp', async (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ error: 'Authorization header required' });
  }

  try {
    const instruments = req.query.i;
    const response = await axios.get(
      `${KITE_API_URL}/quote/ltp?i=${instruments}`,
      {
        headers: {
          'Authorization': authHeader,
          'X-Kite-Version': '3'
        }
      }
    );
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({
      error: 'LTP request failed',
      details: error.response?.data || error.message
    });
  }
});

// Instruments
app.get('/api/instruments', async (req, res) => {
  try {
    const response = await axios.get(`${KITE_API_URL}/instruments`);
    res.send(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({
      error: 'Instruments request failed',
      details: error.response?.data || error.message
    });
  }
});

app.get('/api/instruments/:exchange', async (req, res) => {
  try {
    const response = await axios.get(`${KITE_API_URL}/instruments/${req.params.exchange}`);
    res.send(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({
      error: 'Instruments request failed',
      details: error.response?.data || error.message
    });
  }
});

// Historical data
app.get('/api/instruments/historical/:instrument_token/:interval', async (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    console.log('❌ No authorization header');
    return res.status(401).json({ error: 'Authorization header required' });
  }

  try {
    const { instrument_token, interval } = req.params;
    const { from, to } = req.query;
    
    const kiteUrl = `${KITE_API_URL}/instruments/historical/${instrument_token}/${interval}?from=${from}&to=${to}`;
    console.log('📊 Fetching historical data from Kite API:', kiteUrl);
    console.log('📊 Instrument:', instrument_token, 'Interval:', interval, 'Date range:', from, 'to', to);
    
    const response = await axios.get(kiteUrl, {
      headers: {
        'Authorization': authHeader,
        'X-Kite-Version': '3'
      }
    });
    
    console.log('✅ Kite API response received, candles:', response.data?.data?.candles?.length || 0);
    res.json(response.data);
  } catch (error) {
    console.error('❌ Historical data error:', error.response?.data || error.message);
    console.error('❌ Error status:', error.response?.status);
    res.status(error.response?.status || 500).json({
      error: 'Historical data request failed',
      details: error.response?.data || error.message
    });
  }
});

// Logout - invalidate session
app.delete('/api/session', async (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ error: 'Authorization header required' });
  }

  try {
    const response = await axios.delete(
      `${KITE_API_URL}/session/token`,
      {
        headers: {
          'Authorization': authHeader,
          'X-Kite-Version': '3'
        },
        data: new URLSearchParams({ api_key: KITE_API_KEY })
      }
    );
    res.json(response.data);
  } catch (error) {
    // Even if Kite API fails, we clear local storage
    res.json({ status: 'success', message: 'Session cleared locally' });
  }
});

// Start server
app.listen(PORT, () => {
  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log('║          🐂 The Great Bulls - Backend Server 🐂           ║');
  console.log('╠════════════════════════════════════════════════════════════╣');
  console.log(`║  Server running on: http://localhost:${PORT}                  ║`);
  console.log(`║  Frontend URL: ${FRONTEND_URL}                    ║`);
  console.log('║                                                            ║');
  console.log('║  Endpoints:                                                ║');
  console.log('║  - GET  /health              - Health check                ║');
  console.log('║  - GET  /api/login-url       - Get Kite login URL          ║');
  console.log('║  - POST /api/token           - Exchange token              ║');
  console.log('║  - GET  /api/user/profile    - User profile                ║');
  console.log('║  - GET  /api/user/margins    - Account margins             ║');
  console.log('║  - GET  /api/portfolio/*     - Holdings & Positions        ║');
  console.log('║  - GET  /api/orders          - Orders                      ║');
  console.log('║  - GET  /api/quote           - Market quotes               ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
});
