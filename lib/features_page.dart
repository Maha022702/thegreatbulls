import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

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
            Text('Features', style: TextStyle(color: Colors.amber)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: 300,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.amber, Colors.orange, Colors.amber],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.star, size: 60, color: Colors.black),
                    const SizedBox(height: 20),
                    const Text(
                      'Revolutionary Features',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Discover what makes The Great Bulls the future of trading',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Elite Value Snapshot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.amber.withOpacity(0.25)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Built for elite, latency-sensitive traders',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Single cockpit for AI signals, real-time execution, and compliance-friendly logging. Zero fluff—every module is actionable and measurable.',
                      style: TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            // Features Grid
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  _buildFeatureSection(
                    '🤖 AI & Machine Learning',
                    [
                      _buildDetailedFeature(
                        FontAwesomeIcons.robot,
                        'AI Price Predictions',
                        'Advanced machine learning models analyze historical data, market sentiment, and technical indicators to predict price movements with up to 85% accuracy.',
                        'Trained on 10+ years of NSE data',
                        Colors.purple,
                      ),
                      _buildDetailedFeature(
                        FontAwesomeIcons.brain,
                        'Sentiment Analysis',
                        'Real-time analysis of news articles, social media, and market data to gauge market sentiment and predict volatility.',
                        'Processes 1000+ sources per minute',
                        Colors.blue,
                      ),
                      _buildDetailedFeature(
                        FontAwesomeIcons.chartLine,
                        'Pattern Recognition AI',
                        'Computer vision algorithms automatically detect 50+ chart patterns including head & shoulders, double tops, triangles, and flags.',
                        'Real-time pattern alerts with confidence scores',
                        Colors.green,
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  _buildFeatureSection(
                    '📊 Advanced Analytics',
                    [
                      _buildDetailedFeature(
                        FontAwesomeIcons.search,
                        'Technical Indicators',
                        '50+ technical indicators including RSI, MACD, Bollinger Bands, Fibonacci retracements, and custom indicators.',
                        'Real-time calculation with alerts',
                        Colors.orange,
                      ),
                      _buildDetailedFeature(
                        FontAwesomeIcons.chartBar,
                        'Multi-Timeframe Analysis',
                        'Analyze charts across multiple timeframes simultaneously from 1-minute to monthly charts.',
                        'Synchronized cross-timeframe analysis',
                        Colors.teal,
                      ),
                      _buildDetailedFeature(
                        FontAwesomeIcons.balanceScale,
                        'Risk Management',
                        'Automated position sizing, stop-loss calculations, and risk-reward ratio analysis.',
                        'Portfolio-level risk monitoring',
                        Colors.red,
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  _buildFeatureSection(
                    '⚡ Performance & Speed',
                    [
                      _buildDetailedFeature(
                        FontAwesomeIcons.bolt,
                        'Lightning Execution',
                        'Sub-millisecond order execution through direct Kite Connect WebSocket integration.',
                        '<1ms latency, 99.9% uptime',
                        Colors.yellow,
                      ),
                      _buildDetailedFeature(
                        FontAwesomeIcons.database,
                        'Real-time Data',
                        'Live streaming of 10 major NSE stocks with tick-by-tick updates during market hours.',
                        'Zero data lag with local caching',
                        Colors.indigo,
                      ),
                      _buildDetailedFeature(
                        FontAwesomeIcons.mobileAlt,
                        'Cross-Platform',
                        'Seamless experience across desktop, tablet, and mobile devices with responsive design.',
                        'Progressive Web App (PWA)',
                        Colors.pink,
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // CTA Section
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Ready to Experience the Future?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Join thousands of traders who have transformed their trading with AI-powered insights.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => context.go('/'),
                              icon: const FaIcon(FontAwesomeIcons.signInAlt),
                              label: const Text('Get Started'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              ),
                            ),
                            const SizedBox(width: 20),
                            OutlinedButton.icon(
                              onPressed: () => context.go('/demo'),
                              icon: const FaIcon(FontAwesomeIcons.play),
                              label: const Text('Watch Demo'),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.amber),
                                foregroundColor: Colors.amber,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildFeatureSection(String title, List<Widget> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 30),
        ...features,
      ],
    );
  }

  Widget _buildDetailedFeature(IconData icon, String title, String description, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(icon, size: 32, color: color),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}