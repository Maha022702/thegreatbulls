import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
            Text('Interactive Demo', style: TextStyle(color: Colors.amber)),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section
              Container(
                height: 250,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.amber, Colors.orange, Colors.red],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.playCircle, size: 60, color: Colors.black),
                      const SizedBox(height: 20),
                      const Text(
                        'Interactive Platform Demo',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'See The Great Bulls in action',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Demo Content
              Container(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    _buildDemoSection(
                      '📊 Live Charts Demo',
                      'Experience real-time candlestick charts with AI pattern recognition',
                      [
                        _buildDemoFeature(
                          'Real-time Price Updates',
                          'Watch live price movements with sub-second updates',
                          FontAwesomeIcons.chartLine,
                          Colors.blue,
                        ),
                        _buildDemoFeature(
                          'Pattern Detection',
                          'AI automatically identifies chart patterns like head & shoulders',
                          FontAwesomeIcons.search,
                          Colors.green,
                        ),
                        _buildDemoFeature(
                          'Multi-Timeframe',
                          'Switch between 1m, 5m, and 15m charts instantly',
                          FontAwesomeIcons.layerGroup,
                          Colors.purple,
                        ),
                      ],
                      'View Live Demo',
                      () => _showChartDemo(),
                    ),

                    const SizedBox(height: 60),

                    _buildDemoSection(
                      '🤖 AI Predictions Demo',
                      'See how our AI predicts price movements with 85%+ accuracy',
                      [
                        _buildDemoFeature(
                          'Price Forecasting',
                          'AI predicts next candle direction with confidence scores',
                          FontAwesomeIcons.robot,
                          Colors.orange,
                        ),
                        _buildDemoFeature(
                          'Risk Assessment',
                          'Automated risk-reward ratio calculations',
                          FontAwesomeIcons.balanceScale,
                          Colors.red,
                        ),
                        _buildDemoFeature(
                          'Sentiment Analysis',
                          'Real-time market sentiment from news and social media',
                          FontAwesomeIcons.newspaper,
                          Colors.teal,
                        ),
                      ],
                      'Try AI Demo',
                      () => _showAIDemo(),
                    ),

                    const SizedBox(height: 60),

                    _buildDemoSection(
                      '⚡ Trading Execution Demo',
                      'Experience lightning-fast order execution and portfolio management',
                      [
                        _buildDemoFeature(
                          'Instant Orders',
                          'Place market, limit, and stop orders with one click',
                          FontAwesomeIcons.bolt,
                          Colors.yellow,
                        ),
                        _buildDemoFeature(
                          'Portfolio Tracking',
                          'Real-time P&L, holdings, and position monitoring',
                          FontAwesomeIcons.wallet,
                          Colors.indigo,
                        ),
                        _buildDemoFeature(
                          'Risk Management',
                          'Automated stop-loss and position sizing',
                          FontAwesomeIcons.shieldAlt,
                          Colors.pink,
                        ),
                      ],
                      'Trade Demo',
                      () => _showTradingDemo(),
                    ),

                    const SizedBox(height: 60),

                    // Call to Action
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.amber, Colors.orange],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Ready to Transform Your Trading?',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Join thousands of traders who have revolutionized their trading with AI-powered insights and lightning-fast execution.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: () => context.go('/'),
                            icon: const FaIcon(FontAwesomeIcons.rocket),
                            label: const Text('Start Your Journey'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.amber,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
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
      ),
    );
  }

  Widget _buildDemoSection(String title, String subtitle, List<Widget> features, String buttonText, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 30),
          ...features,
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: const FaIcon(FontAwesomeIcons.play),
              label: Text(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoFeature(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChartDemo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          '📊 Live Charts Demo',
          style: TextStyle(color: Colors.amber),
        ),
        content: const SizedBox(
          width: 400,
          child: Text(
            'This demo would show interactive candlestick charts with:\n\n'
            '• Real-time price updates\n'
            '• AI pattern recognition\n'
            '• Volume histograms\n'
            '• Multiple timeframes\n'
            '• Technical indicators\n\n'
            'Connect your Zerodha account to see the real thing!',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.amber)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  void _showAIDemo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          '🤖 AI Predictions Demo',
          style: TextStyle(color: Colors.amber),
        ),
        content: const SizedBox(
          width: 400,
          child: Text(
            'AI Demo Features:\n\n'
            '• Price prediction with 85%+ accuracy\n'
            '• Confidence scores for each prediction\n'
            '• Risk-reward ratio analysis\n'
            '• Market sentiment indicators\n'
            '• Pattern-based signals\n\n'
            'Our AI is trained on 10+ years of market data!',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  void _showTradingDemo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          '⚡ Trading Demo',
          style: TextStyle(color: Colors.amber),
        ),
        content: const SizedBox(
          width: 400,
          child: Text(
            'Trading Demo Includes:\n\n'
            '• One-click order placement\n'
            '• Real-time portfolio tracking\n'
            '• P&L calculations\n'
            '• Position management\n'
            '• Risk management tools\n\n'
            'Experience <1ms execution speed!',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }
}