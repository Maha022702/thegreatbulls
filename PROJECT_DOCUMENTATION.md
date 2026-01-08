# The Great Bulls - Complete Project Documentation

## 📋 Project Overview

**Project Name:** The Great Bulls  
**Domain:** https://thegreatbulls.in  
**Type:** Stock Market Analysis & Live Trading Dashboard  
**Platform:** Web (Flutter)  
**Status:** ✅ Phase 1 Complete - Live Data Streaming Working

---

## 🎯 Project Objective

Build a world-class stock market intelligence platform that provides:
1. **Real-time live market data** streaming via Kite WebSocket
2. **Interactive candlestick charts** with multiple timeframes
3. **User authentication** via Zerodha Kite OAuth
4. **Portfolio tracking** - Holdings, Positions, Orders
5. **Persistent data storage** for chart history
6. **Premium subscription features** (future)

---

## 🏗️ Current Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           PRODUCTION ARCHITECTURE                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────────┐         ┌──────────────────┐                         │
│  │   USER BROWSER   │         │     VERCEL       │                         │
│  │                  │◄───────►│   (Frontend)     │                         │
│  │  thegreatbulls.in│  HTTPS  │   Flutter Web    │                         │
│  └────────┬─────────┘         └──────────────────┘                         │
│           │                                                                 │
│           │ WebSocket (wss://)                                              │
│           ▼                                                                 │
│  ┌──────────────────┐                                                       │
│  │   KITE TRADE     │                                                       │
│  │   WebSocket      │  Live tick data (binary)                              │
│  │ ws.kite.trade    │  10 NSE stocks streaming                              │
│  └──────────────────┘                                                       │
│           │                                                                 │
│           │ Token Exchange                                                  │
│           ▼                                                                 │
│  ┌──────────────────┐         ┌──────────────────┐                         │
│  │  AWS API Gateway │────────►│   AWS Lambda     │                         │
│  │   /prod/token    │         │  Token Exchange  │                         │
│  └──────────────────┘         └────────┬─────────┘                         │
│                                        │                                    │
│                                        ▼                                    │
│                               ┌──────────────────┐                         │
│                               │   KITE API       │                         │
│                               │ api.kite.trade   │                         │
│                               └──────────────────┘                         │
│                                                                             │
│  ┌──────────────────┐                                                       │
│  │   IndexedDB      │  Local browser storage                                │
│  │   (Browser)      │  Candle data persistence (7 days)                     │
│  └──────────────────┘                                                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Technology Stack

### Frontend
| Technology | Version | Purpose |
|------------|---------|---------|
| Flutter | 3.38.5 | Cross-platform web framework |
| Dart | 3.10.4 | Programming language |
| Lightweight Charts | v4 | Candlestick charting library |
| go_router | - | Navigation/routing |
| provider | - | State management |
| font_awesome_flutter | - | Icons |
| http | - | API calls |
| crypto | - | SHA256 checksum |

### Backend / Cloud Services
| Service | Region | Purpose |
|---------|--------|---------|
| Vercel | Global | Frontend hosting, CDN |
| AWS Lambda | ap-south-1 | Token exchange (serverless) |
| AWS API Gateway | ap-south-1 | HTTP API endpoint |
| AWS IAM | - | Role & permissions |

### External APIs
| API | Purpose |
|-----|---------|
| Kite Connect OAuth | User authentication |
| Kite REST API | Portfolio, Orders, Holdings |
| Kite WebSocket | Real-time tick data |

### Storage
| Storage | Location | Purpose | Retention |
|---------|----------|---------|-----------|
| IndexedDB | Browser | Candle history | 7 days |
| localStorage | Browser | Auth tokens | Until logout |

---

## 🔐 Authentication Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    KITE OAUTH FLOW                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. User clicks "Login with Zerodha"                            │
│     └──► Opens: kite.zerodha.com/connect/login?api_key=xxx      │
│                                                                 │
│  2. User enters Zerodha credentials (2FA)                       │
│     └──► Kite validates credentials                             │
│                                                                 │
│  3. Kite redirects to callback URL with request_token           │
│     └──► https://www.thegreatbulls.in/auth/callback             │
│         ?request_token=xxx&status=success                       │
│                                                                 │
│  4. Frontend calls AWS API Gateway                              │
│     └──► POST /prod/token { request_token: xxx }                │
│                                                                 │
│  5. Lambda generates checksum & exchanges token                 │
│     └──► SHA256(api_key + request_token + api_secret)           │
│     └──► POST api.kite.trade/session/token                      │
│                                                                 │
│  6. Kite returns access_token (valid for 1 day)                 │
│     └──► Stored in localStorage                                 │
│                                                                 │
│  7. WebSocket connects with access_token                        │
│     └──► wss://ws.kite.trade?api_key=xxx&access_token=xxx       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📊 Live Data Streaming

### Stocks Being Tracked (10 NSE Stocks)
| Symbol | Company | Instrument Token |
|--------|---------|------------------|
| RELIANCE | Reliance Industries | 738561 |
| TCS | Tata Consultancy Services | 3786497 |
| INFY | Infosys | 408065 |
| SBIN | State Bank of India | 779521 |
| HDFCBANK | HDFC Bank | 341249 |
| ITC | ITC Limited | 424961 |
| BAJFINANCE | Bajaj Finance | 4267265 |
| WIPRO | Wipro | 969473 |
| MARUTI | Maruti Suzuki | 2815745 |
| ASIANPAINT | Asian Paints | 971009 |

### WebSocket Packet Structure
| Mode | Packet Size | Data Fields |
|------|-------------|-------------|
| LTP | 8 bytes | token, last_price |
| Quote | 44 bytes | + OHLC, volume, buy/sell qty |
| Full | 184 bytes | + depth, OI, timestamps |

### Candlestick Aggregation
| Timeframe | Candles Stored | Coverage |
|-----------|----------------|----------|
| 1 minute | 500 | ~8.3 hours |
| 5 minutes | 500 | ~41 hours |
| 15 minutes | 500 | ~5 days |

---

## 📁 Project Structure

```
thegreatbulls/
├── lib/
│   ├── main.dart                    # App entry, routes, home page
│   ├── kite_config.dart             # API keys, URLs config
│   ├── kite_oauth_service.dart      # OAuth & API methods
│   ├── oauth_dashboard.dart         # Main dashboard (11 tabs)
│   ├── live_market_data_widget.dart # Live charts (WebSocket + Canvas)
│   ├── auth_callback_page.dart      # OAuth callback handler
│   ├── tradingview_widget.dart      # TradingView embed (unused)
│   ├── kite_charts_widget.dart      # Kite charts (unused)
│   ├── privacy_policy_page.dart     # Legal pages
│   ├── refund_policy_page.dart
│   ├── faq_page.dart
│   └── terms_and_conditions_page.dart
│
├── aws-lambda/
│   ├── token-exchange.js            # Lambda function code
│   ├── index.js                     # DynamoDB functions (future)
│   └── package.json
│
├── web/
│   ├── index.html                   # HTML entry point
│   └── manifest.json                # PWA manifest
│
├── build/
│   └── web/                         # Production build output
│
├── .github/
│   └── copilot-instructions.md      # AI assistant config
│
├── pubspec.yaml                     # Flutter dependencies
├── vercel.json                      # Vercel deployment config
├── build.sh                         # Build script for Vercel
├── README.md                        # Project readme
└── PROJECT_DOCUMENTATION.md         # This file
```

---

## ⚙️ Configuration Details

### Kite Connect App
```
App Name:        TheGreatbulls
API Key:         j3xfcw2nl5v4lx3v
API Secret:      d2jx1v3z138wb51njixjy4vtq55otooj
Client ID:       ZLE384
Redirect URL:    https://www.thegreatbulls.in/auth/callback
```

### AWS Services
```
Region:          ap-south-1 (Mumbai)
Lambda Function: thegreatbulls-token-exchange
API Gateway:     s23gqm7047
API Endpoint:    https://s23gqm7047.execute-api.ap-south-1.amazonaws.com/prod/token
IAM Role:        thegreatbulls-lambda-role
```

### Vercel
```
Project:         thegreatbulls
Team:            ajs-projects-a0154539
Domain:          thegreatbulls.in, www.thegreatbulls.in
Build Command:   ./build.sh
Output Dir:      build/web
```

### Domain (GoDaddy)
```
Domain:          thegreatbulls.in
DNS:             Vercel nameservers
SSL:             Auto (Vercel)
```

---

## 🚀 Deployment Process

### Frontend (Vercel)
```bash
# Build
flutter build web

# Deploy
vercel deploy --prod
```

### Lambda (AWS)
```bash
# Package
cd aws-lambda
zip -r ../token-lambda.zip token-exchange.js package.json

# Deploy
aws lambda update-function-code \
  --function-name thegreatbulls-token-exchange \
  --zip-file fileb://token-lambda.zip \
  --region ap-south-1
```

---

## 📈 Features - Current Status

### ✅ Phase 1 - Complete
- [x] Flutter web app setup
- [x] Kite OAuth authentication
- [x] AWS Lambda for token exchange
- [x] Live WebSocket connection
- [x] Real-time price streaming
- [x] Candlestick charts (1m, 5m, 15m)
- [x] IndexedDB data persistence
- [x] Volume histogram
- [x] OHLC stats display
- [x] Connection status indicator
- [x] Real-time clock (IST)
- [x] Last tick indicator
- [x] 10 NSE stocks tracking

### 🔄 Phase 2 - Planned
- [ ] Firebase Authentication (Email/Google)
- [ ] User registration & profiles
- [ ] AWS DynamoDB for user data
- [ ] Store Kite tokens per user
- [ ] Multiple watchlists
- [ ] Custom stock selection
- [ ] Price alerts

### 📋 Phase 3 - Future
- [ ] AI-powered predictions
- [ ] Technical indicators (RSI, MACD, MA)
- [ ] Portfolio analytics
- [ ] P&L tracking
- [ ] Options chain
- [ ] Subscription plans (Razorpay)
- [ ] Mobile app (Flutter)

---

## 💰 Cost Breakdown

### Current Monthly Costs
| Service | Cost | Notes |
|---------|------|-------|
| Vercel | Free | Hobby plan, sufficient |
| AWS Lambda | ~$0-1 | 1M free requests/month |
| AWS API Gateway | ~$0-1 | 1M free requests/month |
| Kite Connect | Free | No per-request charges |
| Domain (GoDaddy) | ~₹800/year | thegreatbulls.in |
| **Total** | **~$0-2/month** | |

### Future Costs (with DynamoDB)
| Service | Estimated Cost |
|---------|----------------|
| AWS DynamoDB | $1-5/month |
| Firebase Auth | Free (first 50K users) |
| Razorpay | 2% per transaction |

---

## 🔒 Security Considerations

### Current
- ✅ HTTPS everywhere
- ✅ API secrets in Lambda (not frontend)
- ✅ CORS configured on API Gateway
- ✅ Token stored in localStorage (per-device)

### Recommendations for Phase 2
- [ ] Encrypt tokens in DynamoDB
- [ ] Implement refresh token rotation
- [ ] Add rate limiting
- [ ] Audit logging
- [ ] IP whitelisting for admin

---

## 📞 API Reference

### Token Exchange (AWS Lambda)
```
POST https://s23gqm7047.execute-api.ap-south-1.amazonaws.com/prod/token
Content-Type: application/json

Request:
{
  "request_token": "string"
}

Response (Success):
{
  "status": "success",
  "data": {
    "access_token": "string",
    "public_token": "string",
    "user_id": "string",
    "login_time": "string"
  }
}

Response (Error):
{
  "status": "error",
  "message": "string"
}
```

### Kite WebSocket
```
URL: wss://ws.kite.trade?api_key=xxx&access_token=xxx

Subscribe:
{ "a": "subscribe", "v": [738561, 3786497, ...] }

Set Mode:
{ "a": "mode", "v": ["full", [738561, 3786497, ...]] }
```

---

## 🐛 Known Issues & Limitations

1. **Market Hours Only**: WebSocket only streams data during NSE market hours (9:15 AM - 3:30 PM IST)

2. **Daily Token Expiry**: Kite access_token expires daily at ~6 AM IST, requires re-login

3. **Browser Storage**: IndexedDB data is device-specific, doesn't sync across devices

4. **CORS**: Direct Kite API calls blocked by CORS, must use Lambda proxy

5. **Kite ToS**: Cannot redistribute data publicly, each user must authenticate

---

## 📚 Useful Links

- **Kite Connect Docs**: https://kite.trade/docs/connect/v3/
- **Kite WebSocket Docs**: https://kite.trade/docs/connect/v3/websocket/
- **Flutter Web**: https://docs.flutter.dev/platform-integration/web
- **Lightweight Charts**: https://tradingview.github.io/lightweight-charts/
- **Vercel Docs**: https://vercel.com/docs
- **AWS Lambda**: https://docs.aws.amazon.com/lambda/

---

## 👨‍💻 Development Commands

```bash
# Run locally
flutter run -d chrome

# Build for production
flutter build web

# Deploy to Vercel
vercel deploy --prod

# View Vercel logs
vercel logs thegreatbulls.in

# Update Lambda
aws lambda update-function-code \
  --function-name thegreatbulls-token-exchange \
  --zip-file fileb://token-lambda.zip \
  --region ap-south-1

# View Lambda logs
aws logs tail /aws/lambda/thegreatbulls-token-exchange --follow
```

---

## 📅 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | Jan 8, 2026 | Initial release with live charts |
| 0.9.0 | Jan 7, 2026 | WebSocket streaming working |
| 0.8.0 | Jan 7, 2026 | AWS Lambda token exchange |
| 0.5.0 | Jan 6, 2026 | Basic dashboard layout |
| 0.1.0 | Jan 5, 2026 | Project scaffolding |

---

## 📝 Next Steps (Immediate)

1. **Add Firebase Auth** - Email/Google sign-in
2. **Create DynamoDB tables** - Users, Tokens, Watchlists
3. **Implement user registration** - Sign up flow
4. **Link Zerodha accounts** - One-time OAuth linking
5. **Deploy user management** - Profile page

---

*Document Last Updated: January 8, 2026*
