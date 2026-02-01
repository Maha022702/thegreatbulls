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
                      'Beginner Course',
                      'Your foundation to stock market success',
                      FontAwesomeIcons.seedling,
                      Colors.green,
                      '₹2,999',
                      '6 months access',
                      [
                        'Personal Trading Story',
                        'Stock Market Fundamentals',
                        'Technical Analysis Basics',
                        'Risk Management',
                        'Emotion Control',
                      ],
                      '3 modules • 15+ lessons • Community access',
                    ),
                    _buildCourseCard(
                      'equity',
                      'Equity Trading Mastery',
                      'Complete equity trading with community support',
                      FontAwesomeIcons.chartLine,
                      Colors.blue,
                      '₹5,999',
                      '12 months access',
                      [
                        'Price Action Methods',
                        'Chart Patterns',
                        'Stock Selection Strategies',
                        'Custom Indicators',
                        'News Trading',
                      ],
                      '5 modules • 25+ lessons • Premium indicators',
                    ),
                    _buildCourseCard(
                      'options',
                      'Option Buying Course',
                      'Master options trading for high returns',
                      FontAwesomeIcons.bolt,
                      Colors.orange,
                      '₹7,999',
                      '12 months access',
                      [
                        'Options Fundamentals',
                        'ITM, ATM, OTM Strategies',
                        'Stock Selection for Options',
                        'Intraday Strategies',
                        'Live Trade Videos',
                      ],
                      '6 modules • 20+ lessons • Strategy templates',
                    ),
                    _buildCourseCard(
                      'combo',
                      'Complete Trading Bundle',
                      'Equity + Options combo for serious traders',
                      FontAwesomeIcons.crown,
                      Colors.amber,
                      '₹12,999',
                      'Lifetime access',
                      [
                        'Full Equity Course',
                        'Full Options Course',
                        'Advanced Strategies',
                        'Priority Support',
                        'All Premium Tools',
                      ],
                      '10 modules • 45+ lessons • Elite community',
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
          'title': 'Beginner Trading Course',
          'subtitle': 'Your Gateway to Stock Market Success',
          'color': Colors.green,
          'icon': FontAwesomeIcons.seedling,
          'price': '₹2,999',
          'duration': '6 months access',
          'overview': 'Perfect for complete beginners! Start your trading journey with our comprehensive foundation course. Learn from a professional trader\'s personal experience and build rock-solid fundamentals. Master technical analysis, risk management, and emotional control - the three pillars of successful trading. Get lifetime access to course materials with 6 months of dedicated support.',
          'modules': [
            {
              'title': 'Module 1: Introduction to Stock Market',
              'description': 'Begin your trading journey with essential market knowledge and real trading stories.',
              'topics': ['My Personal Trading Story & Journey', 'What is Stock Market & How it Works', 'Understanding IPO (Initial Public Offering)', 'Market Capitalization Explained', 'Role of Brokers in Trading'],
            },
            {
              'title': 'Module 2: Technical Analysis Fundamentals',
              'description': 'Master the art of reading charts and understanding price movements.',
              'topics': ['Introduction to Technical Analysis', 'Complete TradingView Tutorial', 'Understanding Different Timeframes', 'Candlestick Patterns Decoded', 'Support & Resistance Levels', 'Channel Pattern Trading'],
            },
            {
              'title': 'Module 3: Risk Management & Psychology',
              'description': 'Learn to protect your capital and master your trading emotions.',
              'topics': ['What is Risk Management & Why it Matters', 'Perfect Entry Strategies', 'Strategic Exit Planning', 'Emotional Control Techniques', 'Position Sizing Rules', 'Trading Psychology Basics'],
            },
          ],
        };

      case 'equity':
        return {
          'title': 'Equity Trading Mastery',
          'subtitle': 'Complete Stock Trading with Community & Premium Tools',
          'color': Colors.blue,
          'icon': FontAwesomeIcons.chartLine,
          'price': '₹5,999',
          'duration': '12 months access',
          'overview': 'The complete equity trading course designed for serious traders. Master advanced technical analysis, chart patterns, and stock selection strategies. Get exclusive access to our trading community and premium custom indicators. Learn price action methods and risk management techniques used by professional traders. Includes copyright-protected content and lifetime community membership.',
          'modules': [
            {
              'title': 'Module 1: Introduction & Community Setup',
              'description': 'Get started with your trading journey and unlock all premium features.',
              'topics': ['My Personal Trading Story', 'Stock Market Fundamentals', 'IPO & Market Cap Explained', 'Understanding Brokers & Trading Platforms', 'Copyright Protected Content Access', 'Community Platform Navigation'],
            },
            {
              'title': 'Module 2: Community & Resources',
              'description': 'Access our exclusive trading community and premium tools.',
              'topics': ['Complete Course Content Overview', 'How to Use Trading Community', 'Accessing Custom Indicators', 'Community Discussion Guidelines', 'Getting Support & Mentorship', 'Networking with Fellow Traders'],
            },
            {
              'title': 'Module 3: Advanced Technical Analysis',
              'description': 'Master professional-grade technical analysis and price action methods.',
              'topics': ['Deep Dive into Technical Analysis', 'Advanced TradingView Techniques', 'Multi-Timeframe Analysis Strategy', 'Price Action Trading Methods', 'Candlestick Pattern Mastery', 'Volume Analysis'],
            },
            {
              'title': 'Module 4: Chart Patterns & Analysis',
              'description': 'Learn to identify and trade profitable chart patterns.',
              'topics': ['Triangle Patterns (Ascending, Descending, Symmetrical)', 'Channel Pattern Trading', 'Trend Line Analysis & Drawing', 'Support & Resistance Zones', 'Breakout & Breakdown Strategies', 'Pattern Confirmation Techniques'],
            },
            {
              'title': 'Module 5: Risk Management for Equity',
              'description': 'Protect your capital with professional risk management.',
              'topics': ['Perfect Entry Point Identification', 'Strategic Exit Planning', 'Stop Loss Placement', 'Emotional Control & Trading Discipline', 'Position Sizing for Stocks', 'Trade Management Rules'],
            },
            {
              'title': 'Module 6: Stock Selection & Market Analysis',
              'description': 'Learn to pick winning stocks and trade during news events.',
              'topics': ['Stock Selection Criteria', 'Fundamental + Technical Screening', 'Understanding Kaynes Trade Method', 'News Trading Strategies', 'Sector Analysis', 'Market Sentiment Reading'],
            },
          ],
        };

      case 'options':
        return {
          'title': 'Option Buying Course',
          'subtitle': 'Master High-Return Options Trading Strategies',
          'color': Colors.orange,
          'icon': FontAwesomeIcons.bolt,
          'price': '₹7,999',
          'duration': '12 months access',
          'overview': 'Unlock the power of options trading for exponential returns! This comprehensive course covers everything from basics to advanced strategies. Learn ITM, ATM, OTM concepts, stock selection for options, and proven intraday strategies. Includes live trade video walkthroughs, pattern breakout strategies, and premium indicator access. Perfect for traders ready to amplify their profits through options.',
          'modules': [
            {
              'title': 'Module 1: Options Fundamentals',
              'description': 'Build a solid foundation in options trading concepts.',
              'topics': ['Important Safety Notes for Options', 'What are Options? Complete Introduction', 'Call & Put Options Explained', 'Understanding Strike Price', 'ITM, ATM, OTM - Deep Dive', 'Options Premium & Time Decay'],
            },
            {
              'title': 'Module 2: Chart Patterns for Options',
              'description': 'Identify high-probability setups for options trading.',
              'topics': ['Triangle Patterns for Options Entry', 'Channel Pattern Trading', 'Trend Line Analysis', 'Breakout Confirmation', 'Volume Analysis for Options', 'Pattern-Based Entry Timing'],
            },
            {
              'title': 'Module 3: Risk Management for Options',
              'description': 'Protect your capital in high-leverage options trading.',
              'topics': ['Options Entry Strategies', 'Strategic Exit Planning', 'Stop Loss for Options', 'Emotional Control in Options Trading', 'Position Sizing Rules', 'Risk-Reward Ratio for Options'],
            },
            {
              'title': 'Module 4: Stock Selection for Options',
              'description': 'Learn to pick the right stocks for options trading.',
              'topics': ['How to Pick Right Stock for Options', 'Liquidity & Open Interest Analysis', 'Avoiding Overbuying Mistakes', 'Sector Selection', 'News-Based Stock Picking', 'Volatility Screening'],
            },
            {
              'title': 'Module 5: Live Trade Analysis',
              'description': 'Learn from real option buying trades with detailed analysis.',
              'topics': ['Option Buying Trade Video 1', 'Option Buying Trade Video 2', 'Option Buying Trade Video 3', 'Trade Setup Analysis', 'Entry & Exit Breakdown', 'Lessons from Real Trades'],
            },
            {
              'title': 'Module 6: Intraday Options Strategies',
              'description': 'Advanced intraday strategies for consistent profits.',
              'topics': ['S1 & R1 Strategy for Intraday', 'Pattern Breakout Trading', 'Custom Indicators for Options', 'Scalping Options Intraday', 'Time-Based Strategies', 'Managing Multiple Positions'],
            },
          ],
        };

      case 'combo':
        return {
          'title': 'Complete Trading Bundle',
          'subtitle': 'Equity + Options Mastery - The Ultimate Combo',
          'color': Colors.amber,
          'icon': FontAwesomeIcons.crown,
          'price': '₹12,999',
          'duration': 'Lifetime access',
          'overview': 'The ultimate package for serious traders! Get BOTH Equity and Options courses at a massive discount. Master stock trading, options strategies, and everything in between. This comprehensive bundle includes all premium features, custom indicators, lifetime community access, and priority support. Perfect for traders who want complete market mastery. Save ₹6,000 with this exclusive combo offer!',
          'modules': [
            {
              'title': 'Module 1: Equity Foundation',
              'description': 'Complete introduction to stock market and trading.',
              'topics': ['My Personal Trading Story', 'Stock Market Fundamentals', 'IPO & Market Cap', 'Broker Selection', 'Copyright Content Access', 'Platform Setup'],
            },
            {
              'title': 'Module 2: Trading Community Access',
              'description': 'Unlock all premium community features and tools.',
              'topics': ['Course Content Navigation', 'Community Platform Usage', 'Accessing Custom Indicators', 'Getting Support', 'Networking Opportunities', 'Elite Community Benefits'],
            },
            {
              'title': 'Module 3: Advanced Technical Analysis',
              'description': 'Master technical analysis for both equity and options.',
              'topics': ['Complete Technical Analysis', 'TradingView Mastery', 'Multi-Timeframe Strategy', 'Price Action Methods', 'Candlestick Patterns', 'Volume Analysis'],
            },
            {
              'title': 'Module 4: Chart Patterns Mastery',
              'description': 'Identify and trade all major chart patterns.',
              'topics': ['Triangle Patterns', 'Channel Pattern Trading', 'Trend Line Analysis', 'Support & Resistance Zones', 'Breakout Strategies', 'Pattern Confirmation'],
            },
            {
              'title': 'Module 5: Equity Risk Management',
              'description': 'Professional risk management for stock trading.',
              'topics': ['Perfect Entry Timing', 'Strategic Exits', 'Emotional Control', 'Position Sizing', 'Portfolio Management', 'Trade Journal Maintenance'],
            },
            {
              'title': 'Module 6: Stock Selection & Analysis',
              'description': 'Learn to pick winning stocks systematically.',
              'topics': ['Stock Screening Methods', 'Kaynes Trade Strategy', 'News Trading Guide', 'Sector Analysis', 'Fundamental Screening', 'Technical Confirmation'],
            },
            {
              'title': 'Module 7: Options Fundamentals',
              'description': 'Complete introduction to options trading.',
              'topics': ['Important Options Notes', 'What are Options', 'Call & Put Options', 'Strike Price Selection', 'ITM, ATM, OTM Explained', 'Greeks Basics'],
            },
            {
              'title': 'Module 8: Options Risk Management',
              'description': 'Advanced risk management for options trading.',
              'topics': ['Options Entry Strategies', 'Exit Planning for Options', 'Emotional Control', 'Leverage Management', 'Risk-Reward Optimization', 'Capital Allocation'],
            },
            {
              'title': 'Module 9: Stock Selection for Options',
              'description': 'Pick the best stocks for options trading.',
              'topics': ['Stock Selection for Options', 'Liquidity Analysis', 'Avoiding Overbuying', 'Volatility Selection', 'Option Chain Analysis', 'Best Expiry Selection'],
            },
            {
              'title': 'Module 10: Advanced Trading Strategies',
              'description': 'Complete strategy toolkit for both markets.',
              'topics': ['Live Trade Video 1', 'Live Trade Video 2', 'Live Trade Video 3', 'S1 & R1 Strategy', 'Pattern Breakout System', 'Premium Indicators Guide'],
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
            _buildSubscriptionFeature('HD video lessons & downloadable resources'),
            _buildSubscriptionFeature('Trading community access'),
            _buildSubscriptionFeature('Certificate of completion'),
            _buildSubscriptionFeature('24/7 support'),
            if (courseId == 'equity' || courseId == 'combo') _buildSubscriptionFeature('Premium custom indicators'),
            if (courseId == 'options' || courseId == 'combo') _buildSubscriptionFeature('Live trade video walkthroughs'),
            if (courseId == 'combo') _buildSubscriptionFeature('Priority support & mentorship'),
            if (courseId == 'combo') _buildSubscriptionFeature('Save ₹6,000 with combo offer'),
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