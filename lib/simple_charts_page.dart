import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SimpleChartsPage extends StatefulWidget {
  const SimpleChartsPage({Key? key}) : super(key: key);

  @override
  State<SimpleChartsPage> createState() => _SimpleChartsPageState();
}

class _SimpleChartsPageState extends State<SimpleChartsPage> {
  String selectedSymbol = 'RELIANCE.NS';
  String selectedInterval = '1d';
  bool isLoading = false;
  List<CandleData> candleData = [];
  String errorMessage = '';

  final Map<String, String> nseStocks = {
    'RELIANCE.NS': 'Reliance Industries',
    'TCS.NS': 'Tata Consultancy Services',
    'INFY.NS': 'Infosys',
    'HDFCBANK.NS': 'HDFC Bank',
    'ICICIBANK.NS': 'ICICI Bank',
    'HINDUNILVR.NS': 'Hindustan Unilever',
    'ITC.NS': 'ITC Limited',
    'SBIN.NS': 'State Bank of India',
    'BHARTIARTL.NS': 'Bharti Airtel',
    'KOTAKBANK.NS': 'Kotak Mahindra Bank',
  };

  final Map<String, String> intervals = {
    '1d': 'Daily',
    '1wk': 'Weekly',
    '1mo': 'Monthly',
  };

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Yahoo Finance API (free)
      final period = selectedInterval == '1d' ? '3mo' : '1y';
      final url = Uri.parse(
        'https://query1.finance.yahoo.com/v8/finance/chart/$selectedSymbol?interval=$selectedInterval&range=$period'
      );

      print('🎯 Fetching from Yahoo Finance: $url');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['chart']['result'][0];
        final timestamps = List<int>.from(result['timestamp']);
        final quote = result['indicators']['quote'][0];
        
        final List<double> opens = List<double>.from(quote['open'].map((v) => v ?? 0.0));
        final List<double> highs = List<double>.from(quote['high'].map((v) => v ?? 0.0));
        final List<double> lows = List<double>.from(quote['low'].map((v) => v ?? 0.0));
        final List<double> closes = List<double>.from(quote['close'].map((v) => v ?? 0.0));
        final List<double> volumes = List<double>.from(quote['volume'].map((v) => (v ?? 0).toDouble()));

        final List<CandleData> candles = [];
        for (int i = 0; i < timestamps.length; i++) {
          if (opens[i] > 0 && highs[i] > 0 && lows[i] > 0 && closes[i] > 0) {
            candles.add(CandleData(
              time: timestamps[i].toDouble(),
              open: opens[i],
              high: highs[i],
              low: lows[i],
              close: closes[i],
              volume: volumes[i],
            ));
          }
        }

        print('🎯 Loaded ${candles.length} candles');

        setState(() {
          candleData = candles;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('🎯 Error: $e');
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: Column(
        children: [
          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
            ),
            child: Row(
              children: [
                // Symbol selector
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedSymbol,
                    dropdownColor: Colors.grey[850],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Stock',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[700]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[700]!),
                      ),
                    ),
                    items: nseStocks.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSymbol = value;
                        });
                        _fetchChartData();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Interval selector
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedInterval,
                    dropdownColor: Colors.grey[850],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Interval',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[700]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[700]!),
                      ),
                    ),
                    items: intervals.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedInterval = value;
                        });
                        _fetchChartData();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _fetchChartData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
          // Chart
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    )
                  : errorMessage.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchChartData,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : candleData.isEmpty
                          ? const Center(
                              child: Text(
                                'No data available',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : _buildChart(),
            ),
          ),
          // Info footer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border(top: BorderSide(color: Colors.grey[800]!)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Data source: Yahoo Finance (Free) • Real-time data available with Kite Connect subscription',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    if (candleData.isEmpty) {
      return const Center(child: Text('No data'));
    }

    final maxHigh = candleData.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    final minLow = candleData.map((c) => c.low).reduce((a, b) => a < b ? a : b);

    return CandleStickChart(
      data: candleData,
      maxPrice: maxHigh,
      minPrice: minLow,
    );
  }
}

class CandleData {
  final double time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  CandleData({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}

class CandleStickChart extends StatelessWidget {
  final List<CandleData> data;
  final double maxPrice;
  final double minPrice;

  const CandleStickChart({
    Key? key,
    required this.data,
    required this.maxPrice,
    required this.minPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: (maxPrice - minPrice) / 5,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[800],
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey[800],
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: data.length / 5,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= data.length || value.toInt() < 0) {
                  return const Text('');
                }
                final date = DateTime.fromMillisecondsSinceEpoch(
                  data[value.toInt()].time.toInt() * 1000,
                );
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${date.day}/${date.month}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (maxPrice - minPrice) / 5,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₹${value.toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[800]!, width: 1),
        ),
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: minPrice * 0.99,
        maxY: maxPrice * 1.01,
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.close))
                .toList(),
            isCurved: false,
            color: Colors.amber,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.amber.withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final candle = data[spot.x.toInt()];
                return LineTooltipItem(
                  'O: ₹${candle.open.toStringAsFixed(2)}\n'
                  'H: ₹${candle.high.toStringAsFixed(2)}\n'
                  'L: ₹${candle.low.toStringAsFixed(2)}\n'
                  'C: ₹${candle.close.toStringAsFixed(2)}',
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
