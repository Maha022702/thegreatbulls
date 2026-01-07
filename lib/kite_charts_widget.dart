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
        final container = html.DivElement()
          ..id = 'chart-container-$viewId'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.backgroundColor = '#1a1a1a'
          ..style.overflow = 'hidden';

        // Create chart HTML
        final htmlContent = _buildChartHTML(widget.symbol, widget.instrumentToken, widget.interval);
        container.setInnerHtml(htmlContent, treeSanitizer: html.NodeTreeSanitizer.trusted);

        return container;
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
            background-color: #1a1a1a; 
            font-family: system-ui, -apple-system, sans-serif;
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
            border-radius: 8px;
          }
          #info {
            padding: 10px;
            font-size: 12px;
            color: #aaa;
            border-top: 1px solid #333;
          }
          .error {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 100%;
            font-size: 16px;
            color: #ff6b6b;
          }
        </style>
      </head>
      <body>
        <div id="container">
          <div id="chart"></div>
          <div id="info">Loading chart...</div>
        </div>
        <script>
          console.log('🎯 Live Charts: Script loaded');
          
          async function initChart() {
            try {
              console.log('🎯 Live Charts: initChart started');
              document.getElementById('info').innerHTML = 'Initializing chart...';
              
              // Get access token from localStorage
              console.log('🎯 Live Charts: Checking localStorage for kite_tokens');
              const tokens = localStorage.getItem('kite_tokens');
              
              if (!tokens) {
                const msg = 'Error: Not authenticated. Please login first.';
                document.getElementById('info').innerHTML = msg;
                document.getElementById('chart').innerHTML = '<div style="color: red; padding: 20px;">' + msg + '</div>';
                console.error('🎯 Live Charts: No tokens in localStorage');
                console.log('🎯 Live Charts: Available keys:', Object.keys(localStorage));
                return;
              }

              console.log('🎯 Live Charts: Tokens found:', tokens.substring(0, 50) + '...');
              const tokenData = JSON.parse(tokens);
              const { access_token } = tokenData;
              
              if (!access_token) {
                const msg = 'Error: Invalid token. Please login again.';
                document.getElementById('info').innerHTML = msg;
                document.getElementById('chart').innerHTML = '<div style="color: red; padding: 20px;">' + msg + '</div>';
                console.error('🎯 Live Charts: No access_token in parsed data');
                console.log('🎯 Live Charts: Token data keys:', Object.keys(tokenData));
                return;
              }
              
              console.log('🎯 Live Charts: Access token exists, length:', access_token.length);
              
              console.log('🎯 Live Charts: Access token exists, length:', access_token.length);
              
              // Calculate date range (last 100 days)
              const today = new Date();
              const fromDate = new Date(today.getTime() - 100 * 24 * 60 * 60 * 1000);
              
              const fromStr = fromDate.toISOString().split('T')[0];
              const toStr = today.toISOString().split('T')[0];

              console.log(`🎯 Live Charts: Fetching data for token: $token, interval: $interval, from: \${fromStr}, to: \${toStr}`);
              document.getElementById('info').innerHTML = 'Fetching data from Kite API...';

              // Backend URL from config
              const backendUrl = 'https://kcnpun9kwp.ap-south-1.awsapprunner.com';
              const apiUrl = `\${backendUrl}/api/instruments/historical/$token/$interval?from=\${fromStr}&to=\${toStr}`;
              
              console.log('🎯 Live Charts: API URL:', apiUrl);
              console.log('🎯 Live Charts: Auth header will use token format');

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
                document.getElementById('info').innerHTML = 'Error: HTTP ' + response.status;
                document.getElementById('chart').innerHTML = '<div style="color: red; padding: 20px;">Error: ' + response.status + ' - ' + errorText + '</div>';
                throw new Error(`HTTP error! status: \${response.status}, body: \${errorText}`);
              }

              const data = await response.json();
              console.log('🎯 Live Charts: Response data received');
              console.log('🎯 Live Charts: Data keys:', Object.keys(data));
              
              if (!data.data || !data.data.candles) {
                const msg = 'No candle data received. Response: ' + JSON.stringify(data);
                console.error('🎯 Live Charts:', msg);
                document.getElementById('info').innerHTML = 'Error: No data';
                document.getElementById('chart').innerHTML = '<div style="color: red; padding: 20px;">' + msg + '</div>';
                throw new Error(msg);
              }

              console.log('🎯 Live Charts: Candles count:', data.data.candles.length);
              document.getElementById('info').innerHTML = 'Rendering chart with ' + data.data.candles.length + ' candles...';

              // Create chart
              const container = document.getElementById('chart');
              console.log('🎯 Live Charts: Creating chart in container');
              
              const chart = LightweightCharts.createChart(container, {
                layout: {
                  background: { color: '#1a1a1a' },
                  textColor: '#d1d5db',
                },
                width: container.offsetWidth,
                height: container.offsetHeight,
                timeScale: {
                  timeVisible: true,
                  secondsVisible: false,
                },
                grid: {
                  horzLines: { color: '#2d2d2d' },
                  vertLines: { color: '#2d2d2d' },
                }
              });

              // Create candlestick series
              const candleSeries = chart.addCandlestickSeries({
                upColor: '#26a69a',
                downColor: '#ef5350',
                borderVisible: false,
                wickUpColor: '#26a69a',
                wickDownColor: '#ef5350',
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

              // Add volume series
              const volumeSeries = chart.addHistogramSeries({
                color: '#26a69a4d',
                priceFormat: { type: 'volume' },
                priceScaleId: 'volume',
                lastValueVisible: false,
              });

              const volumeData = data.data.candles.map(candle => {
                const [timestamp, open, high, low, close, volume] = candle;
                return {
                  time: Math.floor(new Date(timestamp * 1000).getTime() / 1000),
                  value: volume,
                  color: parseFloat(close) > parseFloat(open) ? '#26a69a4d' : '#ef53504d',
                };
              });

              volumeSeries.setData(volumeData);

              chart.priceScale('volume').applyOptions({
                scaleMargins: {
                  top: 0.8,
                  bottom: 0,
                },
              });

              // Update info
              const latest = candleData[candleData.length - 1];
              const infoText = 'Symbol: $symbol | Last Price: ₹' + latest.close.toFixed(2) + 
                ' | High: ₹' + latest.high.toFixed(2) + 
                ' | Low: ₹' + latest.low.toFixed(2);
              document.getElementById('info').innerHTML = infoText;
              console.log('🎯 Live Charts: Chart rendered successfully!');
              console.log('🎯 Live Charts: Latest candle:', latest);

              // Responsive
              window.addEventListener('resize', () => {
                if (container.offsetWidth > 0) {
                  chart.applyOptions({ width: container.offsetWidth, height: container.offsetHeight });
                }
              });

            } catch (error) {
              console.error('🎯 Live Charts: Chart error:', error);
              console.error('🎯 Live Charts: Error stack:', error.stack);
              document.getElementById('container').innerHTML = 
                '<div class="error">Error loading chart:<br>' + 
                '<small>' + error.message + '</small><br><br>' +
                '<small>Check console for details (F12)</small></div>';
              document.getElementById('info').innerHTML = 
                'Error: ' + error.message;
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
