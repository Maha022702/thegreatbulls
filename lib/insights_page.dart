import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

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
            Text('Technical Insights', style: TextStyle(color: Colors.amber)),
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
                  colors: [Colors.purple, Colors.indigo, Colors.blue],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.lightbulb, size: 50, color: Colors.white),
                    const SizedBox(height: 15),
                    const Text(
                      'AI-Powered Technical Insights',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Advanced analysis with 50+ technical indicators',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Insights Content
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Technical Indicators
                  _buildInsightsCategory(
                    '📊 Technical Indicators',
                    'Comprehensive analysis using proven technical indicators',
                    Colors.blue,
                    [
                      _buildIndicatorCard(
                        'RSI (Relative Strength Index)',
                        'Momentum oscillator measuring price changes',
                        'Overbought: >70, Oversold: <30',
                        '14-period default',
                        FontAwesomeIcons.chartBar,
                        Colors.blue,
                      ),
                      _buildIndicatorCard(
                        'MACD (Moving Average Convergence Divergence)',
                        'Trend-following momentum indicator',
                        'Signal line crossovers',
                        '12, 26, 9 periods',
                        FontAwesomeIcons.chartLine,
                        Colors.green,
                      ),
                      _buildIndicatorCard(
                        'Bollinger Bands',
                        'Volatility bands around moving average',
                        'Price touching bands indicates extremes',
                        '20-period, 2 SD',
                        FontAwesomeIcons.circle,
                        Colors.orange,
                      ),
                      _buildIndicatorCard(
                        'Stochastic Oscillator',
                        'Momentum indicator comparing closing price to range',
                        '%K and %D lines',
                        '14, 3, 3 periods',
                        FontAwesomeIcons.waveSquare,
                        Colors.red,
                      ),
                      _buildIndicatorCard(
                        'Fibonacci Retracements',
                        'Key levels based on Fibonacci ratios',
                        '23.6%, 38.2%, 61.8%',
                        'Automatic level detection',
                        FontAwesomeIcons.ruler,
                        Colors.purple,
                      ),
                      _buildIndicatorCard(
                        'Volume Profile',
                        'Price levels with highest trading volume',
                        'Value Area, Point of Control',
                        'Real-time calculation',
                        FontAwesomeIcons.chartArea,
                        Colors.teal,
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Market Sentiment
                  _buildInsightsCategory(
                    '📰 Market Sentiment Analysis',
                    'AI-powered analysis of market mood and news impact',
                    Colors.green,
                    [
                      _buildSentimentCard(
                        'News Sentiment',
                        'Real-time analysis of financial news and press releases',
                        '85% accuracy',
                        FontAwesomeIcons.newspaper,
                        Colors.blue,
                      ),
                      _buildSentimentCard(
                        'Social Media Buzz',
                        'Twitter, Reddit, and financial forums sentiment tracking',
                        '72% correlation',
                        FontAwesomeIcons.hashtag,
                        Colors.purple,
                      ),
                      _buildSentimentCard(
                        'Put/Call Ratio',
                        'Options market sentiment indicator',
                        '>1.0 = Bearish',
                        FontAwesomeIcons.balanceScale,
                        Colors.orange,
                      ),
                      _buildSentimentCard(
                        'VIX Fear Index',
                        'Market volatility and fear gauge',
                        '<20 = Complacency',
                        FontAwesomeIcons.exclamationTriangle,
                        Colors.red,
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Risk Management
                  _buildInsightsCategory(
                    '🛡️ Risk Management Tools',
                    'Intelligent risk assessment and position management',
                    Colors.red,
                    [
                      _buildRiskCard(
                        'Dynamic Stop Loss',
                        'AI-adjusts stop loss based on volatility and trend strength',
                        'Trailing stops, percentage-based',
                        FontAwesomeIcons.shieldAlt,
                        Colors.red,
                      ),
                      _buildRiskCard(
                        'Position Sizing',
                        'Optimal position size calculation based on risk tolerance',
                        '1-2% risk per trade recommended',
                        FontAwesomeIcons.calculator,
                        Colors.orange,
                      ),
                      _buildRiskCard(
                        'Risk-Reward Ratio',
                        'Automated calculation of potential profit vs loss',
                        'Minimum 1:2 ratio recommended',
                        FontAwesomeIcons.balanceScale,
                        Colors.green,
                      ),
                      _buildRiskCard(
                        'Portfolio Heat Map',
                        'Visual representation of portfolio risk exposure',
                        'Sector and stock correlation analysis',
                        FontAwesomeIcons.thermometerHalf,
                        Colors.blue,
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // AI Insights Engine
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
                          '🤖 AI Insights Engine',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Our proprietary AI combines multiple data sources to provide actionable trading insights:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildAIInsight(
                          'Price Prediction Model',
                          'LSTM neural networks trained on 10+ years of market data',
                          '85% directional accuracy',
                          Colors.blue,
                        ),
                        _buildAIInsight(
                          'Pattern Recognition',
                          'Computer vision algorithms for chart pattern detection',
                          '50+ patterns recognized',
                          Colors.green,
                        ),
                        _buildAIInsight(
                          'Sentiment Analysis',
                          'NLP models processing news and social media',
                          'Real-time sentiment scoring',
                          Colors.purple,
                        ),
                        _buildAIInsight(
                          'Risk Assessment',
                          'Monte Carlo simulations for portfolio risk analysis',
                          'VaR and stress testing',
                          Colors.red,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Performance Metrics
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
                          '📈 Performance Metrics',
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
                            _buildMetricCard('85%', 'Prediction Accuracy', Colors.green),
                            _buildMetricCard('<1s', 'Signal Generation', Colors.blue),
                            _buildMetricCard('50+', 'Indicators', Colors.orange),
                            _buildMetricCard('24/7', 'Analysis', Colors.purple),
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
                      label: const Text('View Live Insights'),
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

  Widget _buildInsightsCategory(String title, String subtitle, Color color, List<Widget> insights) {
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
        ...insights,
      ],
    );
  }

  Widget _buildIndicatorCard(String name, String description, String signals, String parameters, IconData icon, Color color) {
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Signals: $signals',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Parameters: $parameters',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentimentCard(String name, String description, String accuracy, IconData icon, Color color) {
    return Container(
      width: 280,
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
              FaIcon(icon, color: color, size: 20),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Text(
              accuracy,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskCard(String name, String description, String recommendation, IconData icon, Color color) {
    return Container(
      width: 280,
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
              FaIcon(icon, color: color, size: 20),
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
          Text(
            recommendation,
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsight(String title, String description, String metric, Color color) {
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
              child: FaIcon(FontAwesomeIcons.robot, color: color, size: 20),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                const SizedBox(height: 5),
                Text(
                  metric,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String value, String label, Color color) {
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