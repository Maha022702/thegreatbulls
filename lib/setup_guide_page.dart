import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SetupGuidePage extends StatefulWidget {
  const SetupGuidePage({super.key});

  @override
  State<SetupGuidePage> createState() => _SetupGuidePageState();
}

class _SetupGuidePageState extends State<SetupGuidePage> {
  String? _selectedCourse;

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
            FaIcon(FontAwesomeIcons.graduationCap, color: Colors.amber, size: 24),
            SizedBox(width: 10),
            Text('Trading Education', style: TextStyle(color: Colors.amber)),
          ],
        ),
      ),
      body: _selectedCourse == null ? _buildCoursesOverview() : _buildCourseDetail(_selectedCourse!),
    );
  }

  Widget _buildCoursesOverview() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber, Colors.orange, Colors.redAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(FontAwesomeIcons.chartLine, size: 60, color: Colors.black),
                  const SizedBox(height: 20),
                  const Text(
                    'Master the Markets',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Professional Trading Courses for Every Level',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Learn from Industry Experts • Lifetime Access • Certificate Included',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Courses Section
          Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Text(
                  'Choose Your Learning Path',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'From fundamentals to advanced strategies, our comprehensive courses are designed by professional traders with decades of market experience.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // Course Cards
                Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildCourseCard(
                      'beginner',
                      'Beginner Trader',
                      'Perfect for newcomers to stock markets',
                      FontAwesomeIcons.seedling,
                      Colors.green,
                      '₹2,999',
                      '3 months access',
                      [
                        'Stock Market Basics',
                        'Trading Terminology',
                        'Fundamental Analysis',
                        'Risk Management 101',
                        'Portfolio Setup',
                      ],
                      '8 weeks • 40+ lessons • Interactive quizzes',
                    ),
                    _buildCourseCard(
                      'intermediate',
                      'Technical Analyst',
                      'Master chart patterns and indicators',
                      FontAwesomeIcons.chartArea,
                      Colors.blue,
                      '₹4,999',
                      '6 months access',
                      [
                        'Technical Analysis',
                        'Chart Patterns',
                        'Indicators & Oscillators',
                        'Trading Strategies',
                        'Risk Management Advanced',
                      ],
                      '12 weeks • 80+ lessons • Live sessions',
                    ),
                    _buildCourseCard(
                      'expert',
                      'Professional Trader',
                      'Elite strategies for serious traders',
                      FontAwesomeIcons.crown,
                      Colors.amber,
                      '₹9,999',
                      'Lifetime access',
                      [
                        'Advanced Strategies',
                        'Options Trading',
                        'Algorithmic Trading',
                        'Portfolio Management',
                        'Market Psychology',
                      ],
                      '16 weeks • 120+ lessons • 1-on-1 mentoring',
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Why Choose Us Section
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Why Choose Our Courses?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildWhyChooseItem(
                            FontAwesomeIcons.chalkboardTeacher,
                            'Expert Instructors',
                            'Learn from traders with 20+ years experience',
                          ),
                          _buildWhyChooseItem(
                            FontAwesomeIcons.clock,
                            'Flexible Learning',
                            'Study at your own pace, lifetime access',
                          ),
                          _buildWhyChooseItem(
                            FontAwesomeIcons.certificate,
                            'Industry Certificate',
                            'Recognized certification upon completion',
                          ),
                          _buildWhyChooseItem(
                            FontAwesomeIcons.headset,
                            '24/7 Support',
                            'Get help whenever you need it',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Success Stories
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1a1a1a), Color(0xFF2a2a2a)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Success Stories',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTestimonial(
                              '"From zero knowledge to consistent profits in 6 months. The intermediate course changed my trading career."',
                              'Rahul M., Mumbai',
                              '₹50K → ₹2.5L in 8 months',
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: _buildTestimonial(
                              '"The expert course taught me institutional-level strategies. Now managing ₹10Cr portfolio professionally."',
                              'Priya S., Delhi',
                              'Chartered Accountant turned Trader',
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
    );
  }

  Widget _buildCourseCard(String courseId, String title, String subtitle, IconData icon, Color color, String price, String duration, List<String> features, String details) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: FaIcon(icon, size: 50, color: color),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Price
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Features
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: color, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )),

          const SizedBox(height: 15),
          Text(
            details,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 25),

          // Buttons
          Column(
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _selectedCourse = courseId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'View Course Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => _showSubscriptionDialog(courseId, title, price),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Subscribe Now',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhyChooseItem(IconData icon, String title, String description) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          FaIcon(icon, size: 40, color: Colors.amber),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonial(String quote, String author, String achievement) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            quote,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            author,
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            achievement,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseDetail(String courseId) {
    final courseData = _getCourseData(courseId);
    return SingleChildScrollView(
      child: Column(
        children: [
          // Course Header
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [courseData['color'], courseData['color'].withOpacity(0.7)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(courseData['icon'], size: 50, color: Colors.white),
                  const SizedBox(height: 15),
                  Text(
                    courseData['title'],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    courseData['subtitle'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Back Button
          Container(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _selectedCourse = null),
                icon: const Icon(Icons.arrow_back, color: Colors.amber),
                label: const Text('Back to Courses', style: TextStyle(color: Colors.amber)),
              ),
            ),
          ),

          // Course Content
          Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Course Overview',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        courseData['overview'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Curriculum
                const Text(
                  'Curriculum',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),

                ...courseData['modules'].map<Widget>((module) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module['title'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          module['description'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: module['topics'].map<Widget>((topic) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.amber.withOpacity(0.3)),
                              ),
                              child: Text(
                                topic,
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 40),

                // Pricing and CTA
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1a1a1a), Color(0xFF2a2a2a)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Course Fee: ${courseData['price']}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                courseData['duration'],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: FaIcon(courseData['icon'], size: 40, color: Colors.amber),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showSubscriptionDialog(courseId, courseData['title'], courseData['price']),
                              icon: const FaIcon(FontAwesomeIcons.creditCard),
                              label: const Text('Subscribe Now'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
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
    );
  }

  Map<String, dynamic> _getCourseData(String courseId) {
    switch (courseId) {
      case 'beginner':
        return {
          'title': 'Beginner Trader Course',
          'subtitle': 'Your Gateway to Stock Market Success',
          'color': Colors.green,
          'icon': FontAwesomeIcons.seedling,
          'price': '₹2,999',
          'duration': '3 months access',
          'overview': 'Perfect for complete beginners, this comprehensive course covers everything you need to know to start trading confidently. From basic concepts to practical strategies, you\'ll learn the fundamentals that professional traders use every day. With interactive lessons, real-world examples, and step-by-step guidance, you\'ll be ready to make your first trades within weeks.',
          'modules': [
            {
              'title': 'Module 1: Stock Market Fundamentals',
              'description': 'Understanding the basics of how stock markets work and why they exist.',
              'topics': ['What is Stock Market', 'Primary vs Secondary Market', 'Market Participants', 'Trading vs Investing', 'Market Hours & Holidays'],
            },
            {
              'title': 'Module 2: Trading Terminology',
              'description': 'Master the language of trading with comprehensive glossary and practical examples.',
              'topics': ['Bull vs Bear Market', 'Bid vs Ask Price', 'Volume & Liquidity', 'Market Orders', 'Limit Orders', 'Stop Loss'],
            },
            {
              'title': 'Module 3: Fundamental Analysis',
              'description': 'Learn to evaluate companies based on their financial health and business fundamentals.',
              'topics': ['Balance Sheet Reading', 'Profit & Loss Statement', 'Cash Flow Analysis', 'Key Financial Ratios', 'Company Valuation'],
            },
            {
              'title': 'Module 4: Risk Management 101',
              'description': 'Essential risk management principles every trader must know.',
              'topics': ['Position Sizing', 'Portfolio Diversification', 'Risk-Reward Ratio', 'Maximum Drawdown', 'Trading Psychology'],
            },
            {
              'title': 'Module 5: Portfolio Setup & Execution',
              'description': 'Setting up your trading account and executing your first trades.',
              'topics': ['Choosing a Broker', 'Account Types', 'KYC Process', 'Margin Trading', 'Tax Implications'],
            },
          ],
        };

      case 'intermediate':
        return {
          'title': 'Technical Analyst Course',
          'subtitle': 'Master Chart Patterns & Indicators',
          'color': Colors.blue,
          'icon': FontAwesomeIcons.chartArea,
          'price': '₹4,999',
          'duration': '6 months access',
          'overview': 'Take your trading to the next level with advanced technical analysis. This course covers chart patterns, technical indicators, and proven trading strategies used by professional traders. Learn to read price action, identify high-probability setups, and develop a systematic approach to trading that gives you an edge in the markets.',
          'modules': [
            {
              'title': 'Module 1: Technical Analysis Foundations',
              'description': 'Deep dive into price action and chart analysis principles.',
              'topics': ['Price Action Theory', 'Support & Resistance', 'Trend Analysis', 'Chart Timeframes', 'Volume Price Analysis'],
            },
            {
              'title': 'Module 2: Chart Patterns Mastery',
              'description': 'Learn to identify and trade the most profitable chart patterns.',
              'topics': ['Head & Shoulders', 'Double Tops/Bottoms', 'Triangles & Wedges', 'Flags & Pennants', 'Cup & Handle'],
            },
            {
              'title': 'Module 3: Technical Indicators',
              'description': 'Master the most effective technical indicators for trading decisions.',
              'topics': ['Moving Averages', 'RSI & MACD', 'Bollinger Bands', 'Stochastic Oscillator', 'Fibonacci Retracements'],
            },
            {
              'title': 'Module 4: Trading Strategies',
              'description': 'Complete trading strategies with entry, exit, and risk management rules.',
              'topics': ['Trend Following', 'Breakout Trading', 'Reversal Strategies', 'Scalping Techniques', 'Swing Trading'],
            },
            {
              'title': 'Module 5: Advanced Risk Management',
              'description': 'Professional risk management techniques for consistent profits.',
              'topics': ['Portfolio Risk', 'Correlation Analysis', 'Position Scaling', 'Drawdown Management', 'Performance Tracking'],
            },
          ],
        };

      case 'expert':
        return {
          'title': 'Professional Trader Course',
          'subtitle': 'Elite Strategies for Serious Traders',
          'color': Colors.amber,
          'icon': FontAwesomeIcons.crown,
          'price': '₹9,999',
          'duration': 'Lifetime access',
          'overview': 'The ultimate trading course for serious professionals. Learn institutional-grade strategies, options trading, algorithmic approaches, and advanced portfolio management. This comprehensive program includes one-on-one mentoring, live trading sessions, and access to proprietary trading tools. Join the ranks of elite traders who consistently outperform the market.',
          'modules': [
            {
              'title': 'Module 1: Advanced Trading Strategies',
              'description': 'Institutional strategies used by hedge funds and professional traders.',
              'topics': ['Pairs Trading', 'Arbitrage Strategies', 'Statistical Arbitrage', 'Market Making', 'High-Frequency Concepts'],
            },
            {
              'title': 'Module 2: Options Trading Mastery',
              'description': 'Complete guide to options trading from basic to advanced strategies.',
              'topics': ['Call & Put Options', 'Greeks (Delta, Gamma, Theta)', 'Iron Condor Strategy', 'Covered Calls', 'Options Greeks Management'],
            },
            {
              'title': 'Module 3: Algorithmic Trading',
              'description': 'Build and deploy automated trading systems.',
              'topics': ['Python for Trading', 'API Integration', 'Backtesting Frameworks', 'Strategy Optimization', 'Risk Management Automation'],
            },
            {
              'title': 'Module 4: Portfolio Management',
              'description': 'Professional portfolio construction and management techniques.',
              'topics': ['Asset Allocation', 'Risk Parity', 'Factor Investing', 'Portfolio Optimization', 'Performance Attribution'],
            },
            {
              'title': 'Module 5: Market Psychology & Trading Psychology',
              'description': 'Master your mind and understand market sentiment.',
              'topics': ['Trading Psychology', 'Emotional Discipline', 'Market Sentiment Analysis', 'Crowd Behavior', 'Decision Making Under Uncertainty'],
            },
          ],
        };

      default:
        return {};
    }
  }

  void _showSubscriptionDialog(String courseId, String courseName, String price) {
    final courseData = _getCourseData(courseId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            FaIcon(courseData['icon'], color: courseData['color'], size: 30),
            const SizedBox(width: 15),
            Text(
              'Subscribe to $courseName',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Fee: $price',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              courseData['duration'],
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            const SizedBox(height: 20),
            const Text(
              'What you get:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            _buildSubscriptionFeature('Lifetime access to all course materials'),
            _buildSubscriptionFeature('Interactive quizzes and assignments'),
            _buildSubscriptionFeature('Community forum access'),
            _buildSubscriptionFeature('Certificate of completion'),
            _buildSubscriptionFeature('24/7 support'),
            if (courseId == 'expert') _buildSubscriptionFeature('1-on-1 mentoring sessions'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processSubscription(courseId, courseName, price);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text('Subscribe Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionFeature(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _processSubscription(String courseId, String courseName, String price) {
    // Here you would integrate with payment gateway
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Redirecting to payment for $courseName...'),
        backgroundColor: Colors.amber,
        duration: const Duration(seconds: 2),
      ),
    );

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful! Welcome to your course!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}