import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

class TradingViewChartPage extends StatefulWidget {
  const TradingViewChartPage({super.key});

  @override
  State<TradingViewChartPage> createState() => _TradingViewChartPageState();
}

class _TradingViewChartPageState extends State<TradingViewChartPage> {
  String _selectedSymbol = 'NSE:RELIANCE';
  String _selectedInterval = 'D';

  final List<Map<String, String>> popularSymbols = [
    {'name': 'Reliance Industries', 'symbol': 'NSE:RELIANCE'},
    {'name': 'TCS', 'symbol': 'NSE:TCS'},
    {'name': 'Infosys', 'symbol': 'NSE:INFY'},
    {'name': 'HDFC Bank', 'symbol': 'NSE:HDFCBANK'},
    {'name': 'ICICI Bank', 'symbol': 'NSE:ICICIBANK'},
    {'name': 'State Bank of India', 'symbol': 'NSE:SBIN'},
    {'name': 'ITC', 'symbol': 'NSE:ITC'},
    {'name': 'Maruti Suzuki', 'symbol': 'NSE:MARUTI'},
    {'name': 'Wipro', 'symbol': 'NSE:WIPRO'},
    {'name': 'Asian Paints', 'symbol': 'NSE:ASIANPAINT'},
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
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Advanced Charts',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Real-time interactive charts powered by TradingView',
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
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
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
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
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
                  'Charts are powered by TradingView and provide real-time market data. '
                  'You can zoom, pan, and apply technical indicators. '
                  'Data is updated in real-time for all NSE stocks.',
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
