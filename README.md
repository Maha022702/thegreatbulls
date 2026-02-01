# The Great Bulls

**Elite Stock Market Intelligence Platform**

A world-class Flutter web application that delivers sophisticated stock market analysis with real-time NSE data via Kite Connect WebSocket. Features live candlestick charts with persistent data storage.

## 🏗️ Architecture

- **Frontend**: Flutter Web (Vercel) - https://thegreatbulls.in
- **Data Source**: Kite Connect WebSocket API (direct connection)
- **Storage**: IndexedDB (browser-based, persists candle data for 7 days)
- **Charts**: Lightweight Charts v4 (candlestick + volume)

## ✨ Key Features

### 📊 Live Market Data
- Real-time WebSocket connection to Kite Trade
- 10 NSE stocks: RELIANCE, TCS, INFY, SBIN, HDFC, ITC, BAJFINANCE, WIPRO, MARUTI, ASIANPAINT
- Live price updates with change % indicators
- OHLC, Volume, Buy/Sell Qty stats

### 📈 Candlestick Charts
- **1m, 5m, 15m** interval candles
- Real-time candle aggregation from ticks
- Persistent storage via IndexedDB
- Volume histogram overlay
- Professional trading UI

### 🎯 Advanced Analytics
- Interactive Syncfusion charts
- Trend analysis tools
- Risk assessment indicators

### 👑 Premium Experience
- Dark luxury theme with amber accents
- Responsive design for all devices
- Seamless Kite OAuth integration

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Chrome browser for development

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/thegreatbulls.git
   cd thegreatbulls
   ```
   *Replace `YOUR_USERNAME` with your actual GitHub username*

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run in development mode**
   ```bash
   flutter run -d chrome
   ```

4. **Build for production**
   ```bash
   flutter build web --release
   ```

## 🎨 Design Philosophy

The Great Bulls embodies luxury and sophistication:
- **Dark Theme**: Elegant black and amber color scheme
- **Modern UI**: Material 3 design with custom gradients
- **Responsive Layout**: Optimized for desktop, tablet, and mobile
- **Smooth Animations**: Subtle shadows and transitions
- **Professional Typography**: Clean, readable fonts

## 📱 Pages

- **Landing Page**: Hero section, features showcase, about, and CTA
- **Market Analysis**: Interactive charts and data visualization
- **Predictions**: Expert market forecasts and insights
- **Subscription**: Secure premium access management
- **Support**: Dedicated customer assistance

## 🛠️ Technology Stack

- **Framework**: Flutter Web
- **State Management**: Provider
- **Routing**: Go Router
- **Charts**: Syncfusion Flutter Charts
- **Icons**: Font Awesome Flutter
- **Theme**: Material 3 with custom dark theme

## 🐍 Python Integration Script

For advanced data collection and AI analysis, use the included Python script with AWS deployment:

## 🌍 Deployments

### Main Application
- **URL**: https://thegreatbulls.in
- **Hosting**: Vercel
- **Branch**: main
- **Auto-Deploy**: Yes (on every push)

### Admin Panel
- **URL**: https://admin.thegreatbulls.in
- **Hosting**: Vercel (subdomain)
- **Branch**: main
- **Auto-Deploy**: Yes (GitHub Actions)
- **Features**: 
  - Complete course management
  - Frontend customization
  - Curriculum management
  - Course settings & analytics

### Deployment Pipeline

```
GitHub (Push to main)
  ↓
GitHub Actions (Build & Test)
  ↓
Vercel (Deploy to Production)
  ↓
✨ Live Update (2-5 minutes)
```

**Setup Guides:**
- 📖 [Quick Start Deployment](QUICK_START_DEPLOYMENT.md) - 15 min setup
- 📋 [Full Deployment Guide](DEPLOYMENT_GUIDE.md) - Detailed instructions
- ✅ [Deployment Checklist](DEPLOYMENT_CHECKLIST.md) - Step-by-step verification

## 👨‍💼 Admin Panel

The admin panel provides comprehensive course management:

### Features
- 📚 **Course Management**: Create, edit, and delete courses
- 🎨 **Frontend Customization**: Modify course appearance and branding
- 📖 **Curriculum Editor**: Organize modules and lessons
- ⚙️ **Settings Panel**: Configure course behavior and policies
- 📊 **Analytics**: View course performance metrics
- 💰 **Revenue Tracking**: Monitor course sales and student data
- 👥 **Student Management**: Track enrollments and progress

### Access
```
URL: https://admin.thegreatbulls.in (after DNS propagation)
Tabs: Dashboard | Courses | Students | Analytics | Revenue | Content | Settings
```

### Local Development
```bash
# Run admin panel locally
flutter run -d chrome

# Make changes to lib/admin_panel.dart
# Press 'r' to hot reload
```

### Deploy Changes
```bash
# Commit your changes
git add .
git commit -m "Updated admin panel: [description]"

# Push to GitHub
git push origin main

# ✨ Automatic deployment starts!
# Monitor: GitHub Actions tab
# Live in: 2-5 minutes
```

## 🚀 Getting Started
1. Navigate to the scripts directory:
   ```bash
   cd scripts
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Set environment variables:
   ```bash
   export KITE_API_KEY="your_api_key"
   export KITE_API_SECRET="your_api_secret"
   export AWS_REGION="us-east-1"
   export OPENSEARCH_ENDPOINT="your-opensearch-endpoint"
   export BEDROCK_MODEL_ID="anthropic.claude-v2"
   ```

4. Run the script:
   ```bash
   python kite_integration.py
   ```

### AWS Deployment
1. Build Docker image:
   ```bash
   docker build -t kite-collector .
   ```

2. Deploy to ECS:
   - Create ECS cluster and task definition using the Dockerfile.
   - Set environment variables in task definition.
   - Attach IAM roles for S3, OpenSearch, Bedrock access.

3. Or deploy to EC2:
   - Launch EC2 instance with Docker.
   - Use user data script to pull and run the container.

### Features
- Full Kite Connect authentication
- Historical data collection (OHLCV) with S3 backup
- Live data streaming via WebSocket
- Vector database storage with Amazon OpenSearch
- AI-powered analysis using Amazon Bedrock via LangChain
- CloudWatch logging and monitoring

## 🤝 Contributing

We welcome contributions! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📞 Contact

For inquiries or support:
- Email: info@thegreatbulls.com
- Website: [The Great Bulls](https://thegreatbulls.com)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*Empower your investments with The Great Bulls - where luxury meets intelligence.*
