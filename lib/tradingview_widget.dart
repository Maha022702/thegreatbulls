import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

class TradingViewChartPage extends StatefulWidget {
  const TradingViewChartPage({super.key});

  @override
  State<TradingViewChartPage> createState() => _TradingViewChartPageState();
}

class _TradingViewChartPageState extends State<TradingViewChartPage> {
  String _selectedSymbol = 'NASDAQ:AAPL';
  String _selectedInterval = 'D';

  final List<Map<String, String>> popularSymbols = [
    {'name': 'Apple', 'symbol': 'NASDAQ:AAPL'},
    {'name': 'Microsoft', 'symbol': 'NASDAQ:MSFT'},
    {'name': 'NVIDIA', 'symbol': 'NASDAQ:NVDA'},
    {'name': 'Tesla', 'symbol': 'NASDAQ:TSLA'},
    {'name': 'Amazon', 'symbol': 'NASDAQ:AMZN'},
    {'name': 'Meta', 'symbol': 'NASDAQ:META'},
    {'name': 'Alphabet', 'symbol': 'NASDAQ:GOOGL'},
    {'name': 'Netflix', 'symbol': 'NASDAQ:NFLX'},
    {'name': 'S&P 500 (SPY)', 'symbol': 'AMEX:SPY'},
    {'name': 'NASDAQ 100 (QQQ)', 'symbol': 'NASDAQ:QQQ'},
  ];

  final List<Map<String, String>> intervals = [
    {'label': '1 min', 'value': '1'},
    {'label': '5 min', 'value': '5'},
    {'label': '15 min', 'value': '15'},
    {'label': '30 min', 'value': '30'},
    {'label': '1 hour', 'value': '60'},
    {'label': 'Daily', 'value': 'D'},
    {'label': 'Weekly', 'value': 'W'},
    {'label': 'Monthly', 'value': 'M'},
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
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 12)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'US Equities & ETFs',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Real-time TradingView charts for U.S. mega-caps and index ETFs.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                // Symbol Selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Ticker',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: popularSymbols.map((stock) {
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
                              _selectedSymbol = stock['symbol']!;
                            });
                          },
                          child: Text(
                            stock['name']!,
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
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 24, offset: const Offset(0, 18)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _TradingViewChart(
                symbol: _selectedSymbol,
                interval: _selectedInterval,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withOpacity(0.25)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 18, offset: const Offset(0, 12)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      'About This Chart',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'TradingView widgets stream live U.S. market data. Use the toolbar to apply indicators, drawing tools, and compare multiple tickers.',
                  style: TextStyle(color: Colors.white.withOpacity(0.82)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TradingViewChart extends StatefulWidget {
  final String symbol;
  final String interval;

  const _TradingViewChart({
    required this.symbol,
    required this.interval,
  });

  @override
  State<_TradingViewChart> createState() => _TradingViewChartState();
}

class _TradingViewChartState extends State<_TradingViewChart> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType =
        'tradingview-${widget.symbol}-${widget.interval}-${DateTime.now().millisecondsSinceEpoch}';
    _registerViewFactory();
  }

  void _registerViewFactory() {
    // Create an HTML element view factory using ui.platformViewRegistry
    ui.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..width = '100%'
          ..height = '100%'
          ..style.border = 'none'
          ..style.borderRadius = '8px';

        // Create the HTML content for the iframe
        final htmlContent = '''
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="utf-8">
            <style>
              body { margin: 0; padding: 0; background-color: #1a1a1a; font-family: system-ui, -apple-system, sans-serif; }
              #container { width: 100%; height: 100vh; }
            </style>
          </head>
          <body>
            <div id="container"></div>
            <script src="https://s3.tradingview.com/tv.js"></script>
            <script>
              function initChart() {
                if (typeof TradingView === 'undefined') {
                  setTimeout(initChart, 100);
                  return;
                }
                try {
                  new TradingView.widget({
                    "container_id": "container",
                    "symbol": "${widget.symbol}",
                    "interval": "${widget.interval}",
                    "theme": "dark",
                    "style": "1",
                    "locale": "en",
                    "timezone": "Asia/Kolkata",
                    "enable_publishing": false,
                    "hide_top_toolbar": false,
                    "hide_legend": false,
                    "allow_symbol_change": true,
                    "details": true,
                    "hotlist": true,
                    "calendar": true,
                    "show_popup_button": true,
                    "popup_width": "1000",
                    "popup_height": "650"
                  });
                } catch(e) {
                  console.error('TradingView Error:', e);
                  document.getElementById('container').innerHTML = '<div style="color: red; padding: 20px; font-weight: bold;">Error loading chart. Symbol: ${widget.symbol}</div>';
                }
              }
              document.addEventListener('DOMContentLoaded', initChart);
              setTimeout(initChart, 500);
            </script>
          </body>
          </html>
        ''';

        iframe.srcdoc = htmlContent;
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
