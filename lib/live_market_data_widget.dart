import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class LiveMarketDataWidget extends StatefulWidget {
  const LiveMarketDataWidget({Key? key}) : super(key: key);

  @override
  State<LiveMarketDataWidget> createState() => _LiveMarketDataWidgetState();
}

class _LiveMarketDataWidgetState extends State<LiveMarketDataWidget> {
  late String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'live-market-data-${DateTime.now().millisecondsSinceEpoch}';
    _registerViewFactory();
  }

  void _registerViewFactory() {
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..id = 'live-data-iframe-$viewId'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.border = 'none'
          ..srcdoc = _buildLiveDataHTML();

        return iframe;
      },
    );
  }

  String _buildLiveDataHTML() {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
          * { margin: 0; padding: 0; box-sizing: border-box; }
          
          body {
            background: linear-gradient(180deg, #0a0a0a 0%, #1a1a1a 100%);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Inter', sans-serif;
            color: #ffffff;
            padding: 20px;
            height: 100vh;
            overflow-y: auto;
          }
          
          .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding: 20px;
            background: #1f1f23;
            border: 1px solid #3f3f46;
            border-radius: 12px;
          }
          
          .header h1 {
            font-size: 24px;
            color: #fbbf24;
            margin: 0;
          }
          
          .connection-status {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
          }
          
          .connection-status.connected {
            background: #22c55e20;
            color: #22c55e;
          }
          
          .connection-status.disconnected {
            background: #ef444420;
            color: #ef4444;
          }
          
          .connection-status.connecting {
            background: #fbbf2420;
            color: #fbbf24;
          }
          
          .status-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            animation: pulse 2s infinite;
          }
          
          .status-dot.connected { background: #22c55e; }
          .status-dot.disconnected { background: #ef4444; animation: none; }
          .status-dot.connecting { background: #fbbf24; }
          
          @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
          }
          
          .stocks-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
          }
          
          .stock-card {
            background: #1f1f23;
            border: 1px solid #3f3f46;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
          }
          
          .stock-card:hover {
            border-color: #fbbf24;
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(251, 191, 36, 0.1);
          }
          
          .stock-card.updating {
            animation: cardPulse 0.5s ease;
          }
          
          @keyframes cardPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.02); }
          }
          
          .stock-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
          }
          
          .stock-name {
            font-size: 18px;
            font-weight: 700;
            color: #fbbf24;
            margin-bottom: 4px;
          }
          
          .stock-token {
            font-size: 11px;
            color: #6b7280;
          }
          
          .live-badge {
            background: #22c55e20;
            color: #22c55e;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 5px;
          }
          
          .live-badge .dot {
            width: 6px;
            height: 6px;
            background: #22c55e;
            border-radius: 50%;
            animation: pulse 1.5s infinite;
          }
          
          .price-section {
            margin: 16px 0;
          }
          
          .current-price {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 8px;
          }
          
          .current-price.up { color: #22c55e; }
          .current-price.down { color: #ef4444; }
          .current-price.neutral { color: #ffffff; }
          
          .price-change {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
          }
          
          .price-change.up { color: #22c55e; }
          .price-change.down { color: #ef4444; }
          
          .arrow {
            font-size: 16px;
          }
          
          .stock-details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid #3f3f46;
          }
          
          .detail-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
          }
          
          .detail-label {
            font-size: 11px;
            color: #9ca3af;
            font-weight: 500;
            text-transform: uppercase;
          }
          
          .detail-value {
            font-size: 14px;
            color: #e5e7eb;
            font-weight: 600;
          }
          
          .detail-value.high { color: #22c55e; }
          .detail-value.low { color: #ef4444; }
          .detail-value.volume { color: #60a5fa; }
          
          .no-data {
            grid-column: 1 / -1;
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
          }
          
          .loading {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 200px;
            gap: 16px;
          }
          
          .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid #3f3f46;
            border-top-color: #fbbf24;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
          }
          
          @keyframes spin {
            to { transform: rotate(360deg); }
          }
          
          .last-update {
            text-align: center;
            color: #6b7280;
            font-size: 12px;
            margin-top: 20px;
          }
        </style>
      </head>
      <body>
        <div class="header">
          <div>
            <h1>🔴 Live Market Data</h1>
            <div style="color: #9ca3af; font-size: 13px; margin-top: 4px;">Real-time tick streaming from Kite Connect</div>
          </div>
          <div class="connection-status disconnected" id="statusBadge">
            <div class="status-dot disconnected" id="statusDot"></div>
            <span id="statusText">Connecting...</span>
          </div>
        </div>
        
        <div class="stocks-grid" id="stocksGrid">
          <div class="loading">
            <div class="spinner"></div>
            <div style="color: #fbbf24; font-weight: 600;">Connecting to live stream...</div>
          </div>
        </div>
        
        <div class="last-update" id="lastUpdate">Waiting for data...</div>
        
        <script>
          const stocks = [
            { token: 738561, name: 'Reliance Industries' },
            { token: 3786497, name: 'Tata Consultancy Services' },
            { token: 408065, name: 'Infosys' },
            { token: 779521, name: 'State Bank of India' },
            { token: 341249, name: 'HDFC Bank' },
            { token: 424961, name: 'ITC' },
            { token: 4267265, name: 'Bajaj Finance' },
            { token: 969473, name: 'Wipro' },
            { token: 2815745, name: 'Maruti Suzuki' },
            { token: 971009, name: 'Asian Paints' }
          ];
          
          let ws = null;
          let stockData = {};
          let updateCount = 0;
          
          // Initialize stock data
          stocks.forEach(stock => {
            stockData[stock.token] = {
              name: stock.name,
              token: stock.token,
              ltp: null,
              change: 0,
              changePercent: 0,
              ohlc: {},
              volume: 0,
              lastUpdate: null
            };
          });
          
          function updateStatus(status, statusClass) {
            document.getElementById('statusText').textContent = status;
            document.getElementById('statusBadge').className = 'connection-status ' + statusClass;
            document.getElementById('statusDot').className = 'status-dot ' + statusClass;
          }
          
          function formatNumber(num) {
            if (num >= 10000000) return (num / 10000000).toFixed(2) + 'Cr';
            if (num >= 100000) return (num / 100000).toFixed(2) + 'L';
            if (num >= 1000) return (num / 1000).toFixed(2) + 'K';
            return num?.toFixed(2) || '0';
          }
          
          function renderStocks() {
            const grid = document.getElementById('stocksGrid');
            grid.innerHTML = '';
            
            stocks.forEach(stock => {
              const data = stockData[stock.token];
              const priceClass = data.change > 0 ? 'up' : data.change < 0 ? 'down' : 'neutral';
              const arrow = data.change > 0 ? '▲' : data.change < 0 ? '▼' : '—';
              
              const card = document.createElement('div');
              card.className = 'stock-card';
              card.id = 'card-' + stock.token;
              
              card.innerHTML = `
                <div class="stock-header">
                  <div>
                    <div class="stock-name">\${data.name}</div>
                    <div class="stock-token">NSE: \${data.token}</div>
                  </div>
                  <div class="live-badge">
                    <div class="dot"></div>
                    LIVE
                  </div>
                </div>
                
                <div class="price-section">
                  <div class="current-price \${priceClass}">
                    ₹\${data.ltp ? data.ltp.toFixed(2) : '—'}
                  </div>
                  <div class="price-change \${priceClass}">
                    <span class="arrow">\${arrow}</span>
                    <span>₹\${Math.abs(data.change).toFixed(2)}</span>
                    <span>(\${data.change >= 0 ? '+' : ''}\${data.changePercent.toFixed(2)}%)</span>
                  </div>
                </div>
                
                <div class="stock-details">
                  <div class="detail-item">
                    <div class="detail-label">Open</div>
                    <div class="detail-value">₹\${data.ohlc.open?.toFixed(2) || '—'}</div>
                  </div>
                  <div class="detail-item">
                    <div class="detail-label">High</div>
                    <div class="detail-value high">₹\${data.ohlc.high?.toFixed(2) || '—'}</div>
                  </div>
                  <div class="detail-item">
                    <div class="detail-label">Low</div>
                    <div class="detail-value low">₹\${data.ohlc.low?.toFixed(2) || '—'}</div>
                  </div>
                  <div class="detail-item">
                    <div class="detail-label">Volume</div>
                    <div class="detail-value volume">\${formatNumber(data.volume)}</div>
                  </div>
                </div>
              `;
              
              grid.appendChild(card);
            });
          }
          
          function updateStock(tick) {
            const data = stockData[tick.instrument_token];
            if (!data) return;
            
            data.ltp = tick.last_price;
            data.ohlc = tick.ohlc || {};
            data.volume = tick.volume || 0;
            data.lastUpdate = new Date();
            
            if (data.ohlc.close) {
              data.change = data.ltp - data.ohlc.close;
              data.changePercent = (data.change / data.ohlc.close) * 100;
            }
            
            // Add pulse animation to updated card
            const card = document.getElementById('card-' + tick.instrument_token);
            if (card) {
              card.classList.add('updating');
              setTimeout(() => card.classList.remove('updating'), 500);
            }
            
            renderStocks();
            
            updateCount++;
            document.getElementById('lastUpdate').textContent = 
              `Last update: \${new Date().toLocaleTimeString()} | \${updateCount} updates received`;
          }
          
          function connectWebSocket() {
            const accessToken = localStorage.getItem('access_token');
            
            if (!accessToken) {
              console.error('No access token found');
              document.getElementById('stocksGrid').innerHTML = 
                '<div class="no-data">⚠️ Please login to view live market data</div>';
              return;
            }
            
            updateStatus('Connecting...', 'connecting');
            
            ws = new WebSocket('wss://kcnpun9kwp.ap-south-1.awsapprunner.com/live');
            
            ws.onopen = () => {
              console.log('✅ Connected to WebSocket');
              updateStatus('Connected', 'connected');
              
              // Initialize
              ws.send(JSON.stringify({
                type: 'init',
                accessToken: accessToken
              }));
              
              // Subscribe to all stocks
              setTimeout(() => {
                const tokens = stocks.map(s => s.token);
                ws.send(JSON.stringify({
                  type: 'subscribe',
                  tokens: tokens
                }));
                console.log('📊 Subscribed to', tokens.length, 'stocks');
              }, 1000);
            };
            
            ws.onmessage = (event) => {
              try {
                const message = JSON.parse(event.data);
                
                if (message.type === 'status') {
                  console.log('Status:', message.message);
                } else if (message.type === 'ticks' && message.data) {
                  message.data.forEach(tick => updateStock(tick));
                }
              } catch (e) {
                console.error('Error processing message:', e);
              }
            };
            
            ws.onerror = (error) => {
              console.error('WebSocket error:', error);
              updateStatus('Error', 'disconnected');
            };
            
            ws.onclose = () => {
              console.log('WebSocket closed, reconnecting...');
              updateStatus('Reconnecting...', 'connecting');
              setTimeout(connectWebSocket, 5000);
            };
          }
          
          // Initialize
          renderStocks();
          connectWebSocket();
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
