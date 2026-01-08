import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PatternsPage extends StatelessWidget {
  const PatternsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => context.go('/'),
        ),
        title: Row(
          children: const [
            FaIcon(FontAwesomeIcons.bullseye, color: Colors.amber, size: 24),
            SizedBox(width: 10),
            Text('Chart Patterns', style: TextStyle(color: Colors.amber)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.teal, Colors.blue],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.search, size: 50, color: Colors.white),
                    const SizedBox(height: 15),
                    const Text(
                      'AI-Powered Pattern Recognition',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '50+ chart patterns detected automatically',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.withOpacity(0.25)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 10)),
                  ],
                ),
                child: const Text(
                  'Pattern calls are paired with quality metrics: confidence score, volume confirmation, and multi-timeframe alignment so you know when to trust the setup.',
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
              ),
            ),

            // Patterns Content
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bullish Patterns
                  _buildPatternCategory(
                    '📈 Bullish Patterns',
                    'Patterns that indicate potential upward price movement',
                    Colors.green,
                    [
                      _buildPatternCard(
                        'Head & Shoulders',
                        'Reversal pattern with three peaks, middle one highest',
                        '85% success rate',
                        FontAwesomeIcons.chartLine,
                        Colors.green,
                        'High probability reversal signal',
                      ),
                      _buildPatternCard(
                        'Double Bottom',
                        'Two troughs at similar price level forming "W" shape',
                        '78% success rate',
                        FontAwesomeIcons.arrowUp,
                        Colors.green,
                        'Strong support level confirmation',
                      ),
                      _buildPatternCard(
                        'Bullish Flag',
                        'Consolidation after strong upward move, flagpole + flag',
                        '82% success rate',
                        FontAwesomeIcons.flag,
                        Colors.green,
                        'Continuation pattern after breakout',
                      ),
                      _buildPatternCard(
                        'Cup & Handle',
                        'Rounded bottom followed by small consolidation',
                        '75% success rate',
                        FontAwesomeIcons.mugHot,
                        Colors.green,
                        'Long-term bullish continuation',
                      ),
                      _buildPatternCard(
                        'Ascending Triangle',
                        'Higher lows, horizontal resistance, upward breakout',
                        '80% success rate',
                        FontAwesomeIcons.triangleExclamation,
                        Colors.green,
                        'Accumulation pattern',
                      ),
                      _buildPatternCard(
                        'Bullish Engulfing',
                        'Large bullish candle engulfs previous bearish candle',
                        '70% success rate',
                        FontAwesomeIcons.circleUp,
                        Colors.green,
                        'Short-term reversal signal',
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Bearish Patterns
                  _buildPatternCategory(
                    '📉 Bearish Patterns',
                    'Patterns that indicate potential downward price movement',
                    Colors.red,
                    [
                      _buildPatternCard(
                        'Inverse Head & Shoulders',
                        'Reversal pattern with three troughs, middle one lowest',
                        '83% success rate',
                        FontAwesomeIcons.chartLine,
                        Colors.red,
                        'High probability reversal signal',
                      ),
                      _buildPatternCard(
                        'Double Top',
                        'Two peaks at similar price level forming "M" shape',
                        '76% success rate',
                        FontAwesomeIcons.arrowDown,
                        Colors.red,
                        'Strong resistance level confirmation',
                      ),
                      _buildPatternCard(
                        'Bearish Flag',
                        'Consolidation after strong downward move',
                        '79% success rate',
                        FontAwesomeIcons.flag,
                        Colors.red,
                        'Continuation pattern after breakdown',
                      ),
                      _buildPatternCard(
                        'Descending Triangle',
                        'Lower highs, horizontal support, downward breakout',
                        '77% success rate',
                        FontAwesomeIcons.triangleExclamation,
                        Colors.red,
                        'Distribution pattern',
                      ),
                      _buildPatternCard(
                        'Bearish Engulfing',
                        'Large bearish candle engulfs previous bullish candle',
                        '68% success rate',
                        FontAwesomeIcons.circleDown,
                        Colors.red,
                        'Short-term reversal signal',
                      ),
                      _buildPatternCard(
                        'Shooting Star',
                        'Candlestick with long upper wick, small body',
                        '65% success rate',
                        FontAwesomeIcons.star,
                        Colors.red,
                        'Rejection of higher prices',
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Continuation Patterns
                  _buildPatternCategory(
                    '🔄 Continuation Patterns',
                    'Patterns that suggest a pause before continuing the trend',
                    Colors.blue,
                    [
                      _buildPatternCard(
                        'Bullish Pennant',
                        'Small symmetrical triangle after strong move',
                        '74% success rate',
                        FontAwesomeIcons.flag,
                        Colors.blue,
                        'Short-term consolidation',
                      ),
                      _buildPatternCard(
                        'Bearish Pennant',
                        'Small symmetrical triangle after strong down move',
                        '72% success rate',
                        FontAwesomeIcons.flag,
                        Colors.blue,
                        'Short-term consolidation',
                      ),
                      _buildPatternCard(
                        'Symmetrical Triangle',
                        'Converging trendlines, can break either way',
                        '60% success rate',
                        FontAwesomeIcons.play,
                        Colors.blue,
                        'Neutral consolidation pattern',
                      ),
                      _buildPatternCard(
                        'Rectangle/Box',
                        'Horizontal support and resistance levels',
                        '65% success rate',
                        FontAwesomeIcons.square,
                        Colors.blue,
                        'Trading range continuation',
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // How AI Detection Works
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🤖 How AI Pattern Recognition Works',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildAIProcessStep(
                          '1. Data Collection',
                          'Real-time price, volume, and order book data from Kite WebSocket',
                          FontAwesomeIcons.database,
                          Colors.blue,
                        ),
                        _buildAIProcessStep(
                          '2. Pattern Analysis',
                          'Computer vision algorithms scan price action for known patterns',
                          FontAwesomeIcons.search,
                          Colors.green,
                        ),
                        _buildAIProcessStep(
                          '3. Confidence Scoring',
                          'AI assigns probability scores based on pattern completeness and market conditions',
                          FontAwesomeIcons.percentage,
                          Colors.orange,
                        ),
                        _buildAIProcessStep(
                          '4. Signal Generation',
                          'Alerts sent when confidence exceeds 70% threshold',
                          FontAwesomeIcons.bell,
                          Colors.red,
                        ),
                        _buildAIProcessStep(
                          '5. Risk Assessment',
                          'Position sizing and stop-loss recommendations based on pattern strength',
                          FontAwesomeIcons.shieldAlt,
                          Colors.purple,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Pattern Statistics
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📊 Pattern Detection Statistics',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatCard('50+', 'Patterns Detected', Colors.blue),
                            _buildStatCard('75%', 'Average Accuracy', Colors.green),
                            _buildStatCard('<1s', 'Detection Time', Colors.orange),
                            _buildStatCard('24/7', 'Monitoring', Colors.purple),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // CTA
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/dashboard'),
                      icon: const FaIcon(FontAwesomeIcons.chartLine),
                      label: const Text('View Live Patterns'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternCategory(String title, String subtitle, Color color, List<Widget> patterns) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: patterns,
        ),
      ],
    );
  }

  Widget _buildPatternCard(String name, String description, String successRate, IconData icon, Color color, String tip) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(icon, color: color, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Text(
                  successRate,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                tip,
                style: TextStyle(
                  color: color.withOpacity(0.7),
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIProcessStep(String step, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: FaIcon(icon, color: color, size: 20),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}