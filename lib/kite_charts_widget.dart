import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class KiteChartsPage extends StatefulWidget {
  const KiteChartsPage({super.key});

  @override
  State<KiteChartsPage> createState() => _KiteChartsPageState();
}

class _KiteChartsPageState extends State<KiteChartsPage> {
  String _selectedSymbol = 'RELIANCE';
  String _selectedInterval = '60minute'; // in Kite API format
  String _selectedInstrumentToken = '738561'; // RELIANCE token

  final List<Map<String, dynamic>> nseStocks = [
    {'name': 'Reliance Industries', 'symbol': 'RELIANCE', 'token': '738561'},
    {'name': 'TCS', 'symbol': 'TCS', 'token': '1922569'},
    {'name': 'Infosys', 'symbol': 'INFY', 'token': '1594725'},
    {'name': 'HDFC Bank', 'symbol': 'HDFCBANK', 'token': '1275529'},
    {'name': 'ICICI Bank', 'symbol': 'ICICIBANK', 'token': '1913'},
    {'name': 'State Bank of India', 'symbol': 'SBIN', 'token': '4963329'},
    {'name': 'ITC', 'symbol': 'ITC', 'token': '897537'},
    {'name': 'Maruti Suzuki', 'symbol': 'MARUTI', 'token': '1346009'},
    {'name': 'Wipro', 'symbol': 'WIPRO', 'token': '11484297'},
    {'name': 'Asian Paints', 'symbol': 'ASIANPAINT', 'token': '971009'},
  ];

  final List<Map<String, String>> intervals = [
    {'label': '1 min', 'value': 'minute'},
    {'label': '3 min', 'value': '3minute'},
    {'label': '5 min', 'value': '5minute'},
    {'label': '15 min', 'value': '15minute'},
    {'label': '30 min', 'value': '30minute'},
    {'label': '1 hour', 'value': '60minute'},
    {'label': 'Daily', 'value': 'day'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Live NSE Charts',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Real-time data from your Zerodha Kite API',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                // Symbol Selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Stock',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: nseStocks.map((stock) {
                        final isSelected = _selectedSymbol == stock['symbol'];
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? Colors.amber : Colors.grey[800],
                            foregroundColor: isSelected ? Colors.black : Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedSymbol = stock['symbol'];
                              _selectedInstrumentToken = stock['token'];
                            });
                          },
                          child: Text(
                            stock['name'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Interval Selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time Interval',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: intervals.map((interval) {
                        final isSelected = _selectedInterval == interval['value'];
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? Colors.amber : Colors.grey[800],
                            foregroundColor: isSelected ? Colors.black : Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedInterval = interval['value']!;
                            });
                          },
                          child: Text(
                            interval['label']!,
                            style: const TextStyle(fontSize: 11),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Chart Container
          Container(
            height: 600,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _KiteChartView(
                symbol: _selectedSymbol,
                instrumentToken: _selectedInstrumentToken,
                interval: _selectedInterval,
                key: ValueKey('$_selectedSymbol-$_selectedInterval'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green),
                    SizedBox(width: 10),
                    Text(
                      'Live NSE Data',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Data is fetched live from your Zerodha Kite API account. Charts are powered by Lightweight Charts library. '
                  'All data is real-time NSE stock data for Indian markets.',
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KiteChartView extends StatefulWidget {
  final String symbol;
  final String instrumentToken;
  final String interval;

  const _KiteChartView({
    required this.symbol,
    required this.instrumentToken,
    required this.interval,
    super.key,
  });

  @override
  State<_KiteChartView> createState() => _KiteChartViewState();
}

class _KiteChartViewState extends State<_KiteChartView> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType =
        'kite-chart-${widget.symbol}-${widget.interval}-${DateTime.now().millisecondsSinceEpoch}';
    _registerViewFactory();
  }

  void _registerViewFactory() {
    ui.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..id = 'chart-iframe-$viewId'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.border = 'none'
          ..srcdoc = _buildChartHTML(widget.symbol, widget.instrumentToken, widget.interval);

        return iframe;
      },
    );
  }

  String _buildChartHTML(String symbol, String token, String interval) {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="https://unpkg.com/lightweight-charts@4/dist/lightweight-charts.standalone.production.js"></script>
        <style>
          * { margin: 0; padding: 0; box-sizing: border-box; }
          body { 
            background: linear-gradient(180deg, #0a0a0a 0%, #1a1a1a 100%);
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
            color: white;
          }
          #container { 
            width: 100%; 
            height: 100vh;
            display: flex;
            flex-direction: column;
          }
          #chart { 
            flex: 1;
            border-radius: 0;
            position: relative;
          }
          #info {
            padding: 16px 20px;
            font-size: 13px;
            color: #e5e7eb;
            border-top: 1px solid #27272a;
            background: #0f0f0f;
          }
          .error {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 100%;
            font-size: 16px;
            color: #ef4444;
            gap: 12px;
          }
          .loading {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 100%;
            gap: 16px;
          }
          .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid #27272a;
            border-top-color: #fbbf24;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
          }
          @keyframes spin {
            to { transform: rotate(360deg); }
          }
        </style>
      </head>
      <body>
        <div id="container">
          <div id="chart">
            <div class="loading">
              <div class="spinner"></div>
              <div style="color: #fbbf24; font-weight: 600;">Loading $symbol chart...</div>
            </div>
          </div>
          <div id="info">Fetching live data...</div>
        </div>
        <script>
          console.log('🎯 Live Charts: Script loaded');
          
          async function initChart() {
            try {
              console.log('🎯 Live Charts: initChart started');
              document.getElementById('info').innerHTML = 'Initializing chart...';
              
              // Get access token from localStorage
              console.log('🎯 Live Charts: Checking localStorage for access_token');
              const access_token = localStorage.getItem('access_token');
              const apiKey = 'ucc48co5brk4kb8e'; // From kite_config.dart
              
              if (!access_token) {
                const msg = 'Error: Not authenticated. Please login first.';
                document.getElementById('info').innerHTML = msg;
                document.getElementById('chart').innerHTML = '<div style="color: red; padding: 20px;">' + msg + '</div>';
                console.error('🎯 Live Charts: No access_token in localStorage');
                console.log('🎯 Live Charts: Available keys:', Object.keys(localStorage));
                return;
              }

              console.log('🎯 Live Charts: Access token found, length:', access_token.length);
              
              // Calculate date range (last 100 days)
              // Calculate appropriate date range based on interval
              let daysBack;
              switch (interval) {
                case 'minute':
                  daysBack = 7; // Last 7 days for 1-minute data
                  break;
                case '3minute':
                case '5minute':
                  daysBack = 30; // Last month for 3/5-minute data
                  break;
                case '15minute':
                case '30minute':
                  daysBack = 60; // Last 2 months for 15/30-minute data
                  break;
                case '60minute':
                  daysBack = 100; // Last 3+ months for hourly data
                  break;
                case 'day':
                  daysBack = 365; // Last year for daily data
                  break;
                default:
                  daysBack = 30;
              }
              
              const today = new Date();
              const fromDate = new Date(today.getTime() - daysBack * 24 * 60 * 60 * 1000);
              
              const fromStr = fromDate.toISOString().split('T')[0];
              const toStr = today.toISOString().split('T')[0];

              console.log(`🎯 Live Charts: Fetching data for token: $token, interval: $interval, from: \${fromStr}, to: \${toStr}`);
              document.getElementById('info').innerHTML = 'Fetching data from Kite API...';

              // Backend URL from config
              const backendUrl = 'https://kcnpun9kwp.ap-south-1.awsapprunner.com';
              const apiUrl = `\${backendUrl}/api/instruments/historical/$token/$interval?from=\${fromStr}&to=\${toStr}`;
              
              console.log('🎯 Live Charts: API URL:', apiUrl);
              console.log('🎯 Live Charts: Auth header format: token ACCESS_TOKEN');

              const response = await fetch(apiUrl, {
                headers: {
                  'Authorization': 'token ' + access_token,
                  'Content-Type': 'application/json'
                }
              });

              console.log('🎯 Live Charts: Response status:', response.status);

              if (!response.ok) {
                const errorText = await response.text();
                console.error('🎯 Live Charts: Response error:', errorText);
                
                let errorMessage = 'Failed to load chart data';
                if (response.status === 401) {
                  errorMessage = '🔒 Authentication failed. Please logout and login again.';
                } else if (response.status === 400) {
                  errorMessage = '⚠️ Invalid request. Try a different time interval.';
                } else if (response.status === 429) {
                  errorMessage = '⏱️ Rate limit exceeded. Please wait a moment.';
                } else if (response.status >= 500) {
                  errorMessage = '🔧 Server error. Please try again later.';
                }
                
                document.getElementById('chart').innerHTML = 
                  '<div class="error">' +
                  '<div style="font-size: 48px;">⚠️</div>' +
                  '<div style="font-weight: 600;">' + errorMessage + '</div>' +
                  '<div style="color: #9ca3af; font-size: 12px;">Status: ' + response.status + '</div>' +
                  '</div>';
                document.getElementById('info').innerHTML = '<span style="color: #ef4444;">❌ Error loading data</span>';
                throw new Error(`HTTP error! status: \${response.status}`);
              }

              const data = await response.json();
              console.log('🎯 Live Charts: Response data received');
              console.log('🎯 Live Charts: Data keys:', Object.keys(data));
              
              if (!data.data || !data.data.candles) {
                const msg = 'No candle data received. Response: ' + JSON.stringify(data);
                console.error('🎯 Live Charts:', msg);
                document.getElementById('chart').innerHTML = 
                  '<div class="error">' +
                  '<div style="font-size: 48px;">📊</div>' +
                  '<div style="font-weight: 600; color: #fbbf24;">No data available</div>' +
                  '<div style="color: #9ca3af; font-size: 12px;">Try a different interval</div>' +
                  '</div>';
                document.getElementById('info').innerHTML = '<span style="color: #fbbf24;">⚠️ No data</span>';
                throw new Error(msg);
              }
              
              if (data.data.candles.length === 0) {
                console.error('🎯 Live Charts: Empty candles array');
                document.getElementById('chart').innerHTML = 
                  '<div class="error">' +
                  '<div style="font-size: 48px;">📈</div>' +
                  '<div style="font-weight: 600; color: #fbbf24;">No trading data for this period</div>' +
                  '<div style="color: #9ca3af; font-size: 12px;">Try selecting a different date range or interval</div>' +
                  '</div>';
                document.getElementById('info').innerHTML = '<span style="color: #fbbf24;">⚠️ Empty data</span>';
                return;
              }

              console.log('🎯 Live Charts: Candles count:', data.data.candles.length);

              // Clear loading state and prepare container
              const container = document.getElementById('chart');
              container.innerHTML = ''; // Clear loading spinner
              console.log('🎯 Live Charts: Creating chart in container');
              
              const chart = LightweightCharts.createChart(container, {
                layout: {
                  background: { color: '#0a0a0a' },
                  textColor: '#ffffff',
                },
                width: container.offsetWidth,
                height: container.offsetHeight,
                timeScale: {
                  timeVisible: true,
                  secondsVisible: '$interval' === 'minute',
                  borderColor: '#3f3f46',
                },
                rightPriceScale: {
                  borderColor: '#3f3f46',
                  scaleMargins: {
                    top: 0.1,
                    bottom: 0.2,
                  },
                },
                grid: {
                  vertLines: {
                    color: '#1f1f23',
                    style: 1,
                  },
                  horzLines: {
                    color: '#1f1f23',
                    style: 1,
                  },
                },
                crosshair: {
                  mode: 1,
                  vertLine: {
                    width: 1,
                    color: '#fbbf24',
                    style: 3,
                    labelBackgroundColor: '#fbbf24',
                  },
                  horzLine: {
                    width: 1,
                    color: '#fbbf24',
                    style: 3,
                    labelBackgroundColor: '#fbbf24',
                  },
                },
              });

              // Create candlestick series with better styling
              const candleSeries = chart.addCandlestickSeries({
                upColor: '#22c55e',
                downColor: '#ef4444',
                borderUpColor: '#22c55e',
                borderDownColor: '#ef4444',
                wickUpColor: '#22c55e',
                wickDownColor: '#ef4444',
                borderVisible: true,
                priceLineVisible: true,
                lastValueVisible: true,
              });

              // Parse candle data
              const candleData = data.data.candles.map(candle => {
                const [timestamp, open, high, low, close, volume] = candle;
                return {
                  time: Math.floor(new Date(timestamp * 1000).getTime() / 1000),
                  open: parseFloat(open),
                  high: parseFloat(high),
                  low: parseFloat(low),
                  close: parseFloat(close),
                };
              });

              candleSeries.setData(candleData);

              // Fit content
              chart.timeScale().fitContent();

              // Add volume series with better styling
              const volumeSeries = chart.addHistogramSeries({
                color: '#22c55e80',
                priceFormat: { type: 'volume' },
                priceScaleId: 'volume',
                lastValueVisible: false,
                priceLineVisible: false,
              });

              const volumeData = data.data.candles.map(candle => {
                const [timestamp, open, high, low, close, volume] = candle;
                const isUp = parseFloat(close) >= parseFloat(open);
                return {
                  time: Math.floor(new Date(timestamp * 1000).getTime() / 1000),
                  value: volume,
                  color: isUp ? '#22c55e60' : '#ef444460',
                };
              });

              volumeSeries.setData(volumeData);

              chart.priceScale('volume').applyOptions({
                scaleMargins: {
                  top: 0.75,
                  bottom: 0,
                },
              });

              // Update info with better formatting
              const latest = candleData[candleData.length - 1];
              const first = candleData[0];
              const change = latest.close - first.open;
              const changePercent = ((change / first.open) * 100).toFixed(2);
              const isPositive = change >= 0;
              
              const infoText = '<div style="display: flex; gap: 20px; align-items: center; flex-wrap: wrap;">' +
                '<div style="font-size: 18px; font-weight: 700; color: #fbbf24;">$symbol</div>' +
                '<div style="font-size: 24px; font-weight: 700; color: ' + (isPositive ? '#22c55e' : '#ef4444') + ';">₹' + latest.close.toFixed(2) + '</div>' +
                '<div style="color: ' + (isPositive ? '#22c55e' : '#ef4444') + '; font-weight: 600;">' + 
                  (isPositive ? '▲' : '▼') + ' ₹' + Math.abs(change).toFixed(2) + ' (' + (isPositive ? '+' : '') + changePercent + '%)</div>' +
                '<div style="color: #9ca3af;">H: <span style="color: #22c55e;">₹' + latest.high.toFixed(2) + '</span></div>' +
                '<div style="color: #9ca3af;">L: <span style="color: #ef4444;">₹' + latest.low.toFixed(2) + '</span></div>' +
                '<div style="color: #9ca3af;">O: <span style="color: #fbbf24;">₹' + latest.open.toFixed(2) + '</span></div>' +
                '<div style="color: #9ca3af;">Volume: <span style="color: #60a5fa;">' + (volumeData[volumeData.length - 1].value / 1000).toFixed(0) + 'K</span></div>' +
                '<div style="color: #f97316; font-size: 12px; margin-left: auto;">⚠️ Historical Data (~15 min delay)</div>' +
              '</div>';
              document.getElementById('info').innerHTML = infoText;
              console.log('🎯 Live Charts: Chart rendered successfully!');
              console.log('🎯 Live Charts: Latest candle:', latest);

              // Responsive
              window.addEventListener('resize', () => {
                if (container.offsetWidth > 0) {
                  chart.applyOptions({ width: container.offsetWidth, height: container.offsetHeight });
                }
              });

              // ========== LIVE WEBSOCKET STREAMING ==========
              console.log('🔴 Initializing live WebSocket connection...');
              
              let ws = null;
              let isLive = false;
              let livePrice = latest.close;
              let lastTickTime = Date.now();
              
              function connectWebSocket() {
                const wsUrl = 'wss://kcnpun9kwp.ap-south-1.awsapprunner.com/live';
                console.log('📡 Connecting to WebSocket:', wsUrl);
                
                ws = new WebSocket(wsUrl);
                
                ws.onopen = () => {
                  console.log('✅ WebSocket connected!');
                  
                  // Initialize with access token
                  ws.send(JSON.stringify({
                    type: 'init',
                    accessToken: access_token
                  }));
                  
                  // Subscribe to this instrument
                  setTimeout(() => {
                    ws.send(JSON.stringify({
                      type: 'subscribe',
                      tokens: [$token]
                    }));
                    console.log('📊 Subscribed to token: $token');
                  }, 1000);
                };
                
                ws.onmessage = (event) => {
                  try {
                    const message = JSON.parse(event.data);
                    
                    if (message.type === 'status') {
                      console.log('📡 Status:', message.message);
                      if (message.message.includes('Connected')) {
                        isLive = true;
                        updateLiveIndicator(true);
                      }
                    } else if (message.type === 'ticks' && message.data.length > 0) {
                      message.data.forEach(tick => {
                        if (tick.instrument_token == $token && tick.last_price) {
                          lastTickTime = Date.now();
                          livePrice = tick.last_price;
                          
                          // Update info bar with live data
                          const tickChange = tick.last_price - first.open;
                          const tickChangePercent = ((tickChange / first.open) * 100).toFixed(2);
                          const tickIsPositive = tickChange >= 0;
                          
                          const liveInfo = '<div style="display: flex; gap: 20px; align-items: center; flex-wrap: wrap;">' +
                            '<div style="font-size: 18px; font-weight: 700; color: #fbbf24;">$symbol</div>' +
                            '<div style="font-size: 24px; font-weight: 700; color: ' + (tickIsPositive ? '#22c55e' : '#ef4444') + ';" class="pulse">₹' + tick.last_price.toFixed(2) + '</div>' +
                            '<div style="color: ' + (tickIsPositive ? '#22c55e' : '#ef4444') + '; font-weight: 600;">' + 
                              (tickIsPositive ? '▲' : '▼') + ' ₹' + Math.abs(tickChange).toFixed(2) + ' (' + (tickIsPositive ? '+' : '') + tickChangePercent + '%)</div>' +
                            '<div style="color: #9ca3af;">H: <span style="color: #22c55e;">₹' + (tick.ohlc?.high || latest.high).toFixed(2) + '</span></div>' +
                            '<div style="color: #9ca3af;">L: <span style="color: #ef4444;">₹' + (tick.ohlc?.low || latest.low).toFixed(2) + '</span></div>' +
                            '<div style="color: #9ca3af;">O: <span style="color: #fbbf24;">₹' + (tick.ohlc?.open || latest.open).toFixed(2) + '</span></div>' +
                            '<div style="color: #9ca3af;">Volume: <span style="color: #60a5fa;">' + ((tick.volume || 0) / 1000).toFixed(0) + 'K</span></div>' +
                            '<div style="color: #22c55e; font-size: 12px; margin-left: auto; display: flex; align-items: center; gap: 5px;">' +
                              '<span style="width: 8px; height: 8px; background: #22c55e; border-radius: 50%; display: inline-block; animation: pulse 1.5s infinite;"></span>' +
                              '🔴 LIVE' +
                            '</div>' +
                          '</div>';
                          
                          document.getElementById('info').innerHTML = liveInfo;
                          
                          // Add price line for current price
                          candleSeries.createPriceLine({
                            price: tick.last_price,
                            color: tickIsPositive ? '#22c55e' : '#ef4444',
                            lineWidth: 2,
                            lineStyle: 2, // Dashed
                            axisLabelVisible: true,
                            title: 'LIVE',
                          });
                        }
                      });
                    }
                  } catch (e) {
                    console.error('❌ Error processing WebSocket message:', e);
                  }
                };
                
                ws.onerror = (error) => {
                  console.error('❌ WebSocket error:', error);
                  isLive = false;
                  updateLiveIndicator(false);
                };
                
                ws.onclose = () => {
                  console.log('📡 WebSocket closed, reconnecting in 5s...');
                  isLive = false;
                  updateLiveIndicator(false);
                  setTimeout(connectWebSocket, 5000);
                };
              }
              
              function updateLiveIndicator(live) {
                // Add pulse animation to live price
                if (!document.getElementById('pulseStyle')) {
                  const style = document.createElement('style');
                  style.id = 'pulseStyle';
                  style.textContent = `
                    @keyframes pulse {
                      0%, 100% { opacity: 1; transform: scale(1); }
                      50% { opacity: 0.7; transform: scale(1.05); }
                    }
                    .pulse {
                      animation: pulse 1.5s ease-in-out infinite;
                    }
                  `;
                  document.head.appendChild(style);
                }
              }
              
              // Check if market is open (9:15 AM to 3:30 PM IST, Mon-Fri)
              function isMarketOpen() {
                const now = new Date();
                const istTime = new Date(now.toLocaleString('en-US', { timeZone: 'Asia/Kolkata' }));
                const hours = istTime.getHours();
                const minutes = istTime.getMinutes();
                const day = istTime.getDay();
                
                // Weekend check
                if (day === 0 || day === 6) return false;
                
                // Market hours: 9:15 AM to 3:30 PM
                const currentMinutes = hours * 60 + minutes;
                const marketOpen = 9 * 60 + 15; // 9:15 AM
                const marketClose = 15 * 60 + 30; // 3:30 PM
                
                return currentMinutes >= marketOpen && currentMinutes <= marketClose;
              }
              
              // Connect to WebSocket if market is open
              if (isMarketOpen()) {
                console.log('📈 Market is open, connecting to live stream...');
                connectWebSocket();
              } else {
                console.log('🔒 Market is closed. Showing historical data only.');
                const closedMsg = '<div style="color: #f97316; font-size: 12px; display: flex; align-items: center; gap: 5px;">' +
                  '⏸️ Market Closed - Historical Data' +
                '</div>';
                document.getElementById('info').innerHTML = document.getElementById('info').innerHTML.replace(
                  '⚠️ Historical Data (~15 min delay)',
                  closedMsg
                );
              }

            } catch (error) {
              console.error('🎯 Live Charts: Chart error:', error);
              console.error('🎯 Live Charts: Error stack:', error.stack);
              
              const chartDiv = document.getElementById('chart');
              chartDiv.innerHTML = 
                '<div class="error">' +
                '<div style="font-size: 48px;">❌</div>' +
                '<div style="font-weight: 600;">Failed to load chart</div>' +
                '<div style="color: #9ca3af; font-size: 12px; margin-top: 8px;">' + error.message + '</div>' +
                '<div style="color: #52525b; font-size: 11px; margin-top: 12px;">Open browser console (F12) for details</div>' +
                '</div>';
              
              document.getElementById('info').innerHTML = 
                '<span style="color: #ef4444;">❌ Error: ' + error.message.substring(0, 100) + '</span>';
            }
          }

          console.log('🎯 Live Charts: Adding event listeners');
          document.addEventListener('DOMContentLoaded', () => {
            console.log('🎯 Live Charts: DOMContentLoaded fired');
            initChart();
          });
          setTimeout(() => {
            console.log('🎯 Live Charts: Timeout fired');
            initChart();
          }, 500);
        </script>
      </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
