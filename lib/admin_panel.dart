import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedIndex = 0;
  final List<String> _tabs = [
    'Dashboard',
    'Courses',
    'Students',
    'Analytics',
    'Revenue',
    'Content',
    'Settings'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            const FaIcon(FontAwesomeIcons.crown, color: Colors.amber, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.amber),
            onPressed: () => context.go('/'),
            tooltip: 'Back to App',
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.amber),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.amber),
            onPressed: () {
              final appState = Provider.of<AppState>(context, listen: false);
              appState.adminLogout();
              context.go('/login');
            },
            tooltip: 'Logout',
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.admin_panel_settings, color: Colors.black, size: 18),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Admin',
                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            color: Colors.grey[900],
            child: Column(
              children: [
                const SizedBox(height: 20),
                ...List.generate(_tabs.length, (index) => _buildSidebarItem(index)),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const FaIcon(FontAwesomeIcons.chartLine, color: Colors.amber, size: 24),
                      const SizedBox(height: 8),
                      const Text(
                        'Performance',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '98.5% Uptime',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              color: Colors.black,
              child: _buildMainContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index) {
    final isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.amber.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.amber : Colors.transparent,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          _getTabIcon(index),
          color: isSelected ? Colors.amber : Colors.white70,
          size: 20,
        ),
        title: Text(
          _tabs[index],
          style: TextStyle(
            color: isSelected ? Colors.amber : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => setState(() => _selectedIndex = index),
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  IconData _getTabIcon(int index) {
    switch (index) {
      case 0: return FontAwesomeIcons.chartPie;
      case 1: return FontAwesomeIcons.graduationCap;
      case 2: return FontAwesomeIcons.users;
      case 3: return FontAwesomeIcons.chartBar;
      case 4: return FontAwesomeIcons.rupeeSign;
      case 5: return FontAwesomeIcons.fileVideo;
      case 6: return FontAwesomeIcons.cog;
      default: return FontAwesomeIcons.circle;
    }
  }

  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0: return _buildDashboard();
      case 1: return _buildCoursesManagement();
      case 2: return _buildStudentsManagement();
      case 3: return _buildAnalytics();
      case 4: return _buildRevenue();
      case 5: return _buildContentManagement();
      case 6: return _buildSettings();
      default: return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard Overview',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Welcome back! Here\'s what\'s happening with your courses.',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Key Metrics
          Row(
            children: [
              _buildMetricCard(
                'Total Students',
                '2,847',
                '+12.5%',
                FontAwesomeIcons.users,
                Colors.blue,
              ),
              const SizedBox(width: 24),
              _buildMetricCard(
                'Active Courses',
                '4',
                '+0%',
                FontAwesomeIcons.graduationCap,
                Colors.green,
              ),
              const SizedBox(width: 24),
              _buildMetricCard(
                'Revenue This Month',
                '₹4,23,500',
                '+18.2%',
                FontAwesomeIcons.rupeeSign,
                Colors.amber,
              ),
              const SizedBox(width: 24),
              _buildMetricCard(
                'Completion Rate',
                '87.3%',
                '+5.1%',
                FontAwesomeIcons.trophy,
                Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Charts Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildRevenueChart(),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: _buildCoursePopularityChart(),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Recent Activity
          _buildRecentActivity(),

          const SizedBox(height: 40),

          // Quick Actions
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String change, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(icon, color: color, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: change.startsWith('+') ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      color: change.startsWith('+') ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue Trend',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 1),
                      const FlSpot(2, 4),
                      const FlSpot(3, 3),
                      const FlSpot(4, 5),
                      const FlSpot(5, 3),
                      const FlSpot(6, 4),
                      const FlSpot(7, 6),
                    ],
                    isCurved: true,
                    color: Colors.amber,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.amber.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursePopularityChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Course Popularity',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 35,
                    title: 'Combo',
                    color: Colors.amber,
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: 25,
                    title: 'Equity',
                    color: Colors.blue,
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: 25,
                    title: 'Options',
                    color: Colors.orange,
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: 15,
                    title: 'Beginner',
                    color: Colors.green,
                    radius: 60,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              color: Colors.purple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(5, (index) => _buildActivityItem(index)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = [
      {'user': 'Rahul S.', 'action': 'enrolled in', 'course': 'Complete Trading Bundle', 'time': '2 min ago'},
      {'user': 'Priya M.', 'action': 'completed module', 'course': 'Options Fundamentals', 'time': '15 min ago'},
      {'user': 'Amit K.', 'action': 'purchased', 'course': 'Equity Trading Mastery', 'time': '1 hour ago'},
      {'user': 'Sneha R.', 'action': 'left review for', 'course': 'Beginner Course', 'time': '2 hours ago'},
      {'user': 'Vikram T.', 'action': 'accessed community', 'course': 'Premium Discussion', 'time': '3 hours ago'},
    ];

    final activity = activities[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.amber.withOpacity(0.2),
            child: Text(
              (activity['user'] as String).substring(0, 1),
              style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: activity['user'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' ${activity['action'] as String} '),
                      TextSpan(
                        text: activity['course'] as String,
                        style: const TextStyle(color: Colors.amber),
                      ),
                    ],
                  ),
                ),
                Text(
                  activity['time'] as String,
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildActionButton(
                'Add New Course',
                FontAwesomeIcons.plus,
                Colors.blue,
                () => _showAddCourseDialog(),
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                'Send Notification',
                FontAwesomeIcons.bell,
                Colors.amber,
                () => _showNotificationDialog(),
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                'Generate Report',
                FontAwesomeIcons.fileAlt,
                Colors.purple,
                () => _generateReport(),
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                'Manage Users',
                FontAwesomeIcons.usersCog,
                Colors.red,
                () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: FaIcon(icon, size: 16),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withOpacity(0.3)),
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Course Management',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your courses, modules, and content.',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddCourseDialog(),
                icon: const FaIcon(FontAwesomeIcons.plus, size: 18),
                label: const Text('Add New Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  elevation: 4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildCourseStatCard(
                  'Total Courses',
                  '12',
                  FontAwesomeIcons.book,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCourseStatCard(
                  'Active Students',
                  '3,229',
                  FontAwesomeIcons.users,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCourseStatCard(
                  'Total Revenue',
                  '₹96.87L',
                  FontAwesomeIcons.rupeeSign,
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCourseStatCard(
                  'Avg Rating',
                  '4.8/5',
                  FontAwesomeIcons.star,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Search and Filters
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search courses by name or ID...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: const Icon(Icons.search, color: Colors.amber),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: DropdownButton<String>(
                  value: 'All Status',
                  dropdownColor: Colors.grey[900],
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                  items: ['All Status', 'Active', 'Draft', 'Archived']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: DropdownButton<String>(
                  value: 'Sort by',
                  dropdownColor: Colors.grey[900],
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                  items: ['Sort by', 'Name', 'Students', 'Revenue', 'Rating']
                      .map((sort) => DropdownMenuItem(
                            value: sort,
                            child: Text(sort),
                          ))
                      .toList(),
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Course Cards
          ..._buildCourseManagementCards(),
        ],
      ),
    );
  }

  Widget _buildCourseStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCourseManagementCards() {
    final courses = [
      {
        'id': 'beginner',
        'title': 'Beginner Trading Course',
        'description': 'Learn the fundamentals of stock market trading',
        'price': '₹2,999',
        'students': 1247,
        'rating': 4.8,
        'status': 'Active',
        'modules': 8,
        'lessons': 42,
        'duration': '4 weeks',
        'instructor': 'Raj Kumar',
        'color': Colors.green,
      },
      {
        'id': 'equity',
        'title': 'Equity Trading Mastery',
        'description': 'Master equity trading strategies and techniques',
        'price': '₹5,999',
        'students': 892,
        'rating': 4.9,
        'status': 'Active',
        'modules': 12,
        'lessons': 68,
        'duration': '8 weeks',
        'instructor': 'Priya Singh',
        'color': Colors.blue,
      },
      {
        'id': 'options',
        'title': 'Option Buying Course',
        'description': 'Complete guide to options trading strategies',
        'price': '₹7,999',
        'students': 634,
        'rating': 4.7,
        'status': 'Active',
        'modules': 10,
        'lessons': 55,
        'duration': '6 weeks',
        'instructor': 'Arjun Patel',
        'color': Colors.orange,
      },
      {
        'id': 'combo',
        'title': 'Complete Trading Bundle',
        'description': 'All courses combined at a special price',
        'price': '₹12,999',
        'students': 456,
        'rating': 4.9,
        'status': 'Active',
        'modules': 30,
        'lessons': 165,
        'duration': '18 weeks',
        'instructor': 'Multiple Instructors',
        'color': Colors.amber,
      },
    ];

    return courses.map((course) => Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (course['color'] as Color).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: (course['color'] as Color).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: (course['color'] as Color).withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        course['description'] as String,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: course['status'] as String == 'Active'
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: course['status'] as String == 'Active' ? Colors.green : Colors.orange,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        course['status'] as String == 'Active'
                            ? FontAwesomeIcons.circleCheck
                            : FontAwesomeIcons.hourglass,
                        size: 14,
                        color: course['status'] as String == 'Active' ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        course['status'] as String,
                        style: TextStyle(
                          color: course['status'] as String == 'Active' ? Colors.green : Colors.orange,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Course Details Grid
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pricing and Basic Info
                Row(
                  children: [
                    _buildDetailItem(
                      'Price',
                      course['price'] as String,
                      Colors.amber,
                      FontAwesomeIcons.rupeeSign,
                    ),
                    const SizedBox(width: 20),
                    _buildDetailItem(
                      'Instructor',
                      course['instructor'] as String,
                      Colors.blue,
                      FontAwesomeIcons.chalkboardUser,
                    ),
                    const SizedBox(width: 20),
                    _buildDetailItem(
                      'Duration',
                      course['duration'] as String,
                      Colors.purple,
                      FontAwesomeIcons.clock,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Stats Row
                Row(
                  children: [
                    _buildStatItem(
                      FontAwesomeIcons.users,
                      '${course['students']}',
                      'Students',
                    ),
                    const SizedBox(width: 24),
                    _buildStatItem(
                      FontAwesomeIcons.star,
                      '${course['rating']}',
                      'Rating',
                    ),
                    const SizedBox(width: 24),
                    _buildStatItem(
                      FontAwesomeIcons.book,
                      '${course['modules']} Modules',
                      'Course',
                    ),
                    const SizedBox(width: 24),
                    _buildStatItem(
                      FontAwesomeIcons.video,
                      '${course['lessons']}',
                      'Lessons',
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: (course['color'] as Color).withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _editCourse(course['id'] as String, course),
                    icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 16),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: course['color'] as Color,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewCourseAnalytics(course['id'] as String, course),
                    icon: const FaIcon(FontAwesomeIcons.chartLine, size: 16),
                    label: const Text('Analytics'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: course['color'] as Color),
                      foregroundColor: course['color'] as Color,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _manageCourseContent(course['id'] as String, course),
                    icon: const FaIcon(FontAwesomeIcons.videoCamera, size: 16),
                    label: const Text('Content'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: course['color'] as Color),
                      foregroundColor: course['color'] as Color,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => _showCourseOptions(course),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: (course['color'] as Color).withOpacity(0.5)),
                      padding: EdgeInsets.zero,
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.ellipsisVertical,
                      size: 18,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Row(
      children: [
        FaIcon(icon, color: Colors.white.withOpacity(0.7), size: 16),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(icon, color: color, size: 14),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Student Management',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage enrolled students, track progress, and handle subscriptions.',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Search and Filters
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search students...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: const Icon(Icons.search, color: Colors.amber),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: 'All Courses',
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                items: ['All Courses', 'Beginner', 'Equity', 'Options', 'Combo']
                    .map((course) => DropdownMenuItem(
                          value: course,
                          child: Text(course),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.download),
                label: const Text('Export'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Students Table
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Student', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Course', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Progress', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Enrollment Date', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Status', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Actions', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                ],
                rows: List.generate(10, (index) => _buildStudentRow(index)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildStudentRow(int index) {
    final students = [
      {'name': 'Rahul Sharma', 'email': 'rahul@email.com', 'course': 'Complete Trading Bundle', 'progress': 85, 'date': '2024-01-15', 'status': 'Active'},
      {'name': 'Priya Mehta', 'email': 'priya@email.com', 'course': 'Equity Trading Mastery', 'progress': 92, 'date': '2024-01-12', 'status': 'Active'},
      {'name': 'Amit Kumar', 'email': 'amit@email.com', 'course': 'Option Buying Course', 'progress': 67, 'date': '2024-01-10', 'status': 'Active'},
      {'name': 'Sneha Reddy', 'email': 'sneha@email.com', 'course': 'Beginner Course', 'progress': 100, 'date': '2024-01-08', 'status': 'Completed'},
      {'name': 'Vikram Singh', 'email': 'vikram@email.com', 'course': 'Complete Trading Bundle', 'progress': 45, 'date': '2024-01-05', 'status': 'Active'},
      {'name': 'Kavita Patel', 'email': 'kavita@email.com', 'course': 'Equity Trading Mastery', 'progress': 78, 'date': '2024-01-03', 'status': 'Active'},
      {'name': 'Rajesh Gupta', 'email': 'rajesh@email.com', 'course': 'Option Buying Course', 'progress': 23, 'date': '2024-01-01', 'status': 'Active'},
      {'name': 'Meera Joshi', 'email': 'meera@email.com', 'course': 'Beginner Course', 'progress': 89, 'date': '2023-12-28', 'status': 'Active'},
      {'name': 'Suresh Nair', 'email': 'suresh@email.com', 'course': 'Complete Trading Bundle', 'progress': 34, 'date': '2023-12-25', 'status': 'Paused'},
      {'name': 'Anita Desai', 'email': 'anita@email.com', 'course': 'Equity Trading Mastery', 'progress': 56, 'date': '2023-12-22', 'status': 'Active'},
    ];

    final student = students[index];
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.amber.withOpacity(0.2),
                child: Text(
                  (student['name'] as String).substring(0, 1),
                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'] as String,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    student['email'] as String,
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(Text(student['course'] as String, style: const TextStyle(color: Colors.white))),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: (student['progress'] as int) / 100,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(
                  student['progress'] as int > 80 ? Colors.green :
                  student['progress'] as int > 50 ? Colors.amber : Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${student['progress']}%',
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
              ),
            ],
          ),
        ),
        DataCell(Text(student['date'] as String, style: const TextStyle(color: Colors.white))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: student['status'] == 'Active' ? Colors.green.withOpacity(0.2) :
                     student['status'] == 'Completed' ? Colors.blue.withOpacity(0.2) :
                     student['status'] == 'Paused' ? Colors.amber.withOpacity(0.2) :
                     Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: student['status'] == 'Active' ? Colors.green :
                       student['status'] == 'Completed' ? Colors.blue :
                       student['status'] == 'Paused' ? Colors.amber :
                       Colors.red,
              ),
            ),
            child: Text(
              student['status'] as String,
              style: TextStyle(
                color: student['status'] == 'Active' ? Colors.green :
                       student['status'] == 'Completed' ? Colors.blue :
                       student['status'] == 'Paused' ? Colors.amber :
                       Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.eye, size: 16),
                color: Colors.blue,
                onPressed: () => _viewStudentDetails(student),
                tooltip: 'View Details',
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.envelope, size: 16),
                color: Colors.amber,
                onPressed: () => _sendMessageToStudent(student),
                tooltip: 'Send Message',
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.cog, size: 16),
                color: Colors.white70,
                onPressed: () => _manageStudent(student),
                tooltip: 'Manage',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalytics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analytics & Insights',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Deep insights into your course performance and student engagement.',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Analytics Cards
          Row(
            children: [
              _buildAnalyticsCard(
                'Course Completion Rate',
                '87.3%',
                '+5.1%',
                FontAwesomeIcons.trophy,
                Colors.green,
                'Students who complete courses',
              ),
              const SizedBox(width: 24),
              _buildAnalyticsCard(
                'Average Session Time',
                '45 min',
                '+12%',
                FontAwesomeIcons.clock,
                Colors.blue,
                'Time spent per session',
              ),
              const SizedBox(width: 24),
              _buildAnalyticsCard(
                'Student Retention',
                '94.2%',
                '+2.3%',
                FontAwesomeIcons.userCheck,
                Colors.purple,
                'Students returning after enrollment',
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Detailed Charts
          Row(
            children: [
              Expanded(
                child: _buildDetailedAnalyticsChart('Student Engagement Over Time'),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildDetailedAnalyticsChart('Course Performance Metrics'),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Top Performing Content
          _buildTopContentSection(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, String change, IconData icon, Color color, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(icon, color: color, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: change.startsWith('+') ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      color: change.startsWith('+') ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedAnalyticsChart(String title) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(24),
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
              color: Colors.amber,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                        return Text(
                          titles[value.toInt() % titles.length],
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 4),
                      const FlSpot(2, 2),
                      const FlSpot(3, 5),
                      const FlSpot(4, 3),
                      const FlSpot(5, 6),
                    ],
                    isCurved: true,
                    color: Colors.amber,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.amber.withOpacity(0.1),
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopContentSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Performing Content',
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(5, (index) => _buildTopContentItem(index)),
        ],
      ),
    );
  }

  Widget _buildTopContentItem(int index) {
    final content = [
      {'title': 'Introduction to Stock Market', 'views': 2847, 'completion': 94, 'rating': 4.9},
      {'title': 'Technical Analysis Fundamentals', 'views': 2156, 'completion': 89, 'rating': 4.8},
      {'title': 'Options Trading Basics', 'views': 1893, 'completion': 87, 'rating': 4.7},
      {'title': 'Risk Management Strategies', 'views': 1654, 'completion': 92, 'rating': 4.9},
      {'title': 'Chart Pattern Recognition', 'views': 1423, 'completion': 85, 'rating': 4.6},
    ];

    final item = content[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    FaIcon(FontAwesomeIcons.eye, color: Colors.white.withOpacity(0.5), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${item['views']} views',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    FaIcon(FontAwesomeIcons.checkCircle, color: Colors.green, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${item['completion']}% completion',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    FaIcon(FontAwesomeIcons.star, color: Colors.amber, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${item['rating']}',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.chartBar, size: 16),
            color: Colors.blue,
            onPressed: () {},
            tooltip: 'View Analytics',
          ),
        ],
      ),
    );
  }

  Widget _buildRevenue() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue Management',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track revenue, manage subscriptions, and handle payments.',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Revenue Overview
          Row(
            children: [
              _buildRevenueMetric('Total Revenue', '₹12,45,678', '+18.2%', Colors.green),
              const SizedBox(width: 24),
              _buildRevenueMetric('Monthly Recurring', '₹3,42,100', '+12.5%', Colors.blue),
              const SizedBox(width: 24),
              _buildRevenueMetric('Average Order Value', '₹7,234', '+8.1%', Colors.amber),
              const SizedBox(width: 24),
              _buildRevenueMetric('Refund Rate', '2.1%', '-0.3%', Colors.red),
            ],
          ),

          const SizedBox(height: 40),

          // Revenue Charts
          Row(
            children: [
              Expanded(
                child: _buildRevenueTrendChart(),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildRevenueBreakdownChart(),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Recent Transactions
          _buildTransactionsTable(),
        ],
      ),
    );
  }

  Widget _buildRevenueMetric(String title, String value, String change, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: change.startsWith('+') ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                change,
                style: TextStyle(
                  color: change.startsWith('+') ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueTrendChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue Trend (Last 12 Months)',
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 15,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                        return Text(
                          months[value.toInt()],
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: Colors.green)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: Colors.green)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 7, color: Colors.green)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 12, color: Colors.green)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 9, color: Colors.green)]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 11, color: Colors.green)]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 13, color: Colors.green)]),
                  BarChartGroupData(x: 7, barRods: [BarChartRodData(toY: 10, color: Colors.green)]),
                  BarChartGroupData(x: 8, barRods: [BarChartRodData(toY: 14, color: Colors.green)]),
                  BarChartGroupData(x: 9, barRods: [BarChartRodData(toY: 12, color: Colors.green)]),
                  BarChartGroupData(x: 10, barRods: [BarChartRodData(toY: 15, color: Colors.green)]),
                  BarChartGroupData(x: 11, barRods: [BarChartRodData(toY: 13, color: Colors.green)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueBreakdownChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue by Course',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 35,
                    title: 'Combo\n35%',
                    titleStyle: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                    color: Colors.amber,
                    radius: 80,
                  ),
                  PieChartSectionData(
                    value: 30,
                    title: 'Equity\n30%',
                    titleStyle: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                    color: Colors.blue,
                    radius: 80,
                  ),
                  PieChartSectionData(
                    value: 25,
                    title: 'Options\n25%',
                    titleStyle: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                    color: Colors.orange,
                    radius: 80,
                  ),
                  PieChartSectionData(
                    value: 10,
                    title: 'Beginner\n10%',
                    titleStyle: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                    color: Colors.green,
                    radius: 80,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTable() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.download, size: 16),
                label: const Text('Export All'),
                style: TextButton.styleFrom(foregroundColor: Colors.amber),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Transaction ID', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Student', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Course', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Amount', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Date', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Actions', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
              ],
              rows: List.generate(8, (index) => _buildTransactionRow(index)),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildTransactionRow(int index) {
    final transactions = [
      {'id': 'TXN001234', 'student': 'Rahul Sharma', 'course': 'Complete Trading Bundle', 'amount': '₹12,999', 'date': '2024-01-15', 'status': 'Completed'},
      {'id': 'TXN001235', 'student': 'Priya Mehta', 'course': 'Equity Trading Mastery', 'amount': '₹5,999', 'date': '2024-01-14', 'status': 'Completed'},
      {'id': 'TXN001236', 'student': 'Amit Kumar', 'course': 'Option Buying Course', 'amount': '₹7,999', 'date': '2024-01-13', 'status': 'Pending'},
      {'id': 'TXN001237', 'student': 'Sneha Reddy', 'course': 'Beginner Course', 'amount': '₹2,999', 'date': '2024-01-12', 'status': 'Completed'},
      {'id': 'TXN001238', 'student': 'Vikram Singh', 'course': 'Complete Trading Bundle', 'amount': '₹12,999', 'date': '2024-01-11', 'status': 'Refunded'},
      {'id': 'TXN001239', 'student': 'Kavita Patel', 'course': 'Equity Trading Mastery', 'amount': '₹5,999', 'date': '2024-01-10', 'status': 'Completed'},
      {'id': 'TXN001240', 'student': 'Rajesh Gupta', 'course': 'Option Buying Course', 'amount': '₹7,999', 'date': '2024-01-09', 'status': 'Failed'},
      {'id': 'TXN001241', 'student': 'Meera Joshi', 'course': 'Beginner Course', 'amount': '₹2,999', 'date': '2024-01-08', 'status': 'Completed'},
    ];

    final transaction = transactions[index];
    return DataRow(
      cells: [
        DataCell(
          SelectableText(
            transaction['id'] as String,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DataCell(Text(transaction['student'] as String, style: const TextStyle(color: Colors.white))),
        DataCell(Text(transaction['course'] as String, style: const TextStyle(color: Colors.white))),
        DataCell(
          Text(
            transaction['amount'] as String,
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(Text(transaction['date'] as String, style: const TextStyle(color: Colors.white))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: transaction['status'] as String == 'Completed' ? Colors.green.withOpacity(0.2) :
                     transaction['status'] as String == 'Pending' ? Colors.amber.withOpacity(0.2) :
                     transaction['status'] as String == 'Refunded' ? Colors.blue.withOpacity(0.2) :
                     Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: transaction['status'] as String == 'Completed' ? Colors.green :
                       transaction['status'] as String == 'Pending' ? Colors.amber :
                       transaction['status'] as String == 'Refunded' ? Colors.blue :
                       Colors.red,
              ),
            ),
            child: Text(
              transaction['status'] as String,
              style: TextStyle(
                color: transaction['status'] as String == 'Completed' ? Colors.green :
                       transaction['status'] as String == 'Pending' ? Colors.amber :
                       transaction['status'] as String == 'Refunded' ? Colors.blue :
                       Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.eye, size: 16),
                color: Colors.blue,
                onPressed: () => _viewTransactionDetails(transaction),
                tooltip: 'View Details',
              ),
              if (transaction['status'] == 'Completed')
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.undo, size: 16),
                  color: Colors.red,
                  onPressed: () => _processRefund(transaction),
                  tooltip: 'Process Refund',
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Content Management',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _uploadContent(),
                icon: const FaIcon(FontAwesomeIcons.upload),
                label: const Text('Upload Content'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Manage videos, documents, and course materials.',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Content Stats
          Row(
            children: [
              _buildContentStatCard('Total Videos', '156', FontAwesomeIcons.video, Colors.red),
              const SizedBox(width: 24),
              _buildContentStatCard('Documents', '89', FontAwesomeIcons.fileAlt, Colors.blue),
              const SizedBox(width: 24),
              _buildContentStatCard('Quizzes', '34', FontAwesomeIcons.questionCircle, Colors.green),
              const SizedBox(width: 24),
              _buildContentStatCard('Storage Used', '2.4 GB', FontAwesomeIcons.hdd, Colors.amber),
            ],
          ),

          const SizedBox(height: 40),

          // Content Library
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Content Library',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: 'All Courses',
                      dropdownColor: Colors.grey[900],
                      style: const TextStyle(color: Colors.white),
                      items: ['All Courses', 'Beginner', 'Equity', 'Options', 'Combo']
                          .map((course) => DropdownMenuItem(
                                value: course,
                                child: Text(course),
                              ))
                          .toList(),
                      onChanged: (value) {},
                    ),
                    const SizedBox(width: 16),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search content...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        prefixIcon: const Icon(Icons.search, color: Colors.amber),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...List.generate(6, (index) => _buildContentItem(index)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            FaIcon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentItem(int index) {
    final content = [
      {'title': 'Introduction to Stock Market', 'type': 'Video', 'course': 'Beginner Course', 'duration': '15:30', 'size': '245 MB', 'views': 2847},
      {'title': 'Technical Analysis Fundamentals', 'type': 'Video', 'course': 'Beginner Course', 'duration': '22:45', 'size': '312 MB', 'views': 2156},
      {'title': 'Options Trading Basics', 'type': 'Video', 'course': 'Options Course', 'duration': '18:20', 'size': '278 MB', 'views': 1893},
      {'title': 'Risk Management Guide', 'type': 'Document', 'course': 'All Courses', 'duration': '-', 'size': '2.4 MB', 'views': 1654},
      {'title': 'Chart Patterns Quiz', 'type': 'Quiz', 'course': 'Equity Course', 'duration': '10 questions', 'size': '-', 'views': 1423},
      {'title': 'Live Trading Session Recording', 'type': 'Video', 'course': 'Combo Course', 'duration': '45:12', 'size': '567 MB', 'views': 987},
    ];

    final item = content[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: item['type'] == 'Video' ? Colors.red.withOpacity(0.2) :
                     item['type'] == 'Document' ? Colors.blue.withOpacity(0.2) :
                     Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item['type'] == 'Video' ? FontAwesomeIcons.video :
              item['type'] == 'Document' ? FontAwesomeIcons.fileAlt :
              FontAwesomeIcons.questionCircle,
              color: item['type'] == 'Video' ? Colors.red :
                     item['type'] == 'Document' ? Colors.blue :
                     Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item['course'] as String,
                        style: const TextStyle(color: Colors.amber, fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['duration'] as String,
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['size'] as String,
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    FaIcon(FontAwesomeIcons.eye, color: Colors.white.withOpacity(0.5), size: 10),
                    const SizedBox(width: 4),
                    Text(
                      '${item['views']}',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.play, size: 16),
                color: Colors.blue,
                onPressed: () {},
                tooltip: 'Preview',
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.edit, size: 16),
                color: Colors.amber,
                onPressed: () => _editContent(item),
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.trash, size: 16),
                color: Colors.red,
                onPressed: () => _deleteContent(item),
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings & Configuration',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Configure your platform settings and preferences.',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Settings Sections
          _buildSettingsSection(
            'General Settings',
            [
              _buildSettingItem('Platform Name', 'The Great Bulls', 'text'),
              _buildSettingItem('Support Email', 'support@thegreatbulls.com', 'email'),
              _buildSettingItem('Timezone', 'Asia/Kolkata (IST)', 'select'),
              _buildSettingItem('Language', 'English', 'select'),
            ],
          ),

          const SizedBox(height: 32),

          _buildSettingsSection(
            'Payment Settings',
            [
              _buildSettingItem('Currency', 'INR (₹)', 'select'),
              _buildSettingItem('Payment Gateway', 'Razorpay', 'select'),
              _buildSettingItem('Tax Rate', '18% GST', 'text'),
              _buildSettingItem('Refund Policy', '30 days', 'select'),
            ],
          ),

          const SizedBox(height: 32),

          _buildSettingsSection(
            'Email Settings',
            [
              _buildSettingItem('SMTP Host', 'smtp.gmail.com', 'text'),
              _buildSettingItem('SMTP Port', '587', 'number'),
              _buildSettingItem('Email Templates', '5 active', 'info'),
              _buildSettingItem('Welcome Email', 'Enabled', 'toggle'),
            ],
          ),

          const SizedBox(height: 32),

          _buildSettingsSection(
            'Security Settings',
            [
              _buildSettingItem('Two-Factor Auth', 'Enabled', 'toggle'),
              _buildSettingItem('Session Timeout', '24 hours', 'select'),
              _buildSettingItem('IP Whitelisting', 'Disabled', 'toggle'),
              _buildSettingItem('Audit Logs', 'Enabled', 'toggle'),
            ],
          ),

          const SizedBox(height: 32),

          // Save Button
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _saveSettings(),
              icon: const FaIcon(FontAwesomeIcons.save),
              label: const Text('Save All Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.all(24),
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
              color: Colors.amber,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingItem(String label, String value, String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: type == 'text' || type == 'email' || type == 'number'
                ? TextField(
                    controller: TextEditingController(text: value),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  )
                : type == 'select'
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: value,
                          dropdownColor: Colors.grey[900],
                          style: const TextStyle(color: Colors.white),
                          underline: const SizedBox(),
                          items: [value, 'Option 2', 'Option 3']
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          onChanged: (newValue) {},
                        ),
                      )
                    : type == 'toggle'
                        ? Switch(
                            value: value == 'Enabled',
                            onChanged: (bool newValue) {},
                            activeColor: Colors.amber,
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.amber),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  // Action Methods
  void _showAddCourseDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Create New Course',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.amber),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Form Fields
                _buildFormField('Course Title', 'e.g., Advanced Options Trading'),
                const SizedBox(height: 16),
                _buildFormField('Description', 'Course description'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField('Price (₹)', '5,999'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFormField('Instructor', 'Instructor name'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField('Duration', '8 weeks'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFormField('Modules', '12'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.amber),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Course created successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      icon: const FaIcon(FontAwesomeIcons.check, size: 16),
                      label: const Text('Create Course'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.amber.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.amber.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.amber, width: 2),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  void _showNotificationDialog() {
    // Implementation for sending notifications
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Send Notification dialog would open here'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void _generateReport() {
    // Implementation for generating reports
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating comprehensive report...'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void _editCourse(String courseId, Map<String, dynamic> course) {
    int selectedTab = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 900,
            height: 700,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Text(
                      'Course Management & Customization',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.amber),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${course['title'] as String} • Complete course editor',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                ),
                const SizedBox(height: 24),
                
                // Tab Navigation
                Row(
                  children: [
                    _buildTabButton('Basic Info', 0, selectedTab, () {
                      setDialogState(() => selectedTab = 0);
                    }),
                    const SizedBox(width: 8),
                    _buildTabButton('Frontend Design', 1, selectedTab, () {
                      setDialogState(() => selectedTab = 1);
                    }),
                    const SizedBox(width: 8),
                    _buildTabButton('Curriculum', 2, selectedTab, () {
                      setDialogState(() => selectedTab = 2);
                    }),
                    const SizedBox(width: 8),
                    _buildTabButton('Settings', 3, selectedTab, () {
                      setDialogState(() => selectedTab = 3);
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.amber.withOpacity(0.2)),
                const SizedBox(height: 20),

                // Tab Content
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildCourseEditTabContent(selectedTab, course),
                  ),
                ),
                
                const SizedBox(height: 20),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.amber),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ Course updated successfully!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      icon: const FaIcon(FontAwesomeIcons.floppyDisk, size: 16),
                      label: const Text('Save All Changes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index, int selectedTab, VoidCallback onPressed) {
    bool isSelected = index == selectedTab;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.amber : Colors.grey[800],
        foregroundColor: isSelected ? Colors.black : Colors.amber,
        elevation: isSelected ? 4 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCourseEditTabContent(int tab, Map<String, dynamic> course) {
    switch (tab) {
      case 0:
        return _buildBasicInfoTab(course);
      case 1:
        return _buildFrontendDesignTab(course);
      case 2:
        return _buildCurriculumTab(course);
      case 3:
        return _buildSettingsTab(course);
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoTab(Map<String, dynamic> course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Course Information', style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildFormField('Course Title', course['title'] as String),
        const SizedBox(height: 16),
        _buildFormField('Course Description', course['description'] as String),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildFormField('Price (₹)', course['price'] as String)),
            const SizedBox(width: 16),
            Expanded(child: _buildFormField('Discount %', '10')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildFormField('Instructor Name', course['instructor'] as String)),
            const SizedBox(width: 16),
            Expanded(child: _buildFormField('Instructor Email', 'instructor@example.com')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildFormField('Duration', course['duration'] as String)),
            const SizedBox(width: 16),
            Expanded(child: _buildFormField('Skill Level', 'Intermediate')),
          ],
        ),
        const SizedBox(height: 16),
        _buildFormField('Course Category', 'Trading & Finance'),
        const SizedBox(height: 16),
        _buildFormField('Tags', 'stocks, trading, investing, finance'),
      ],
    );
  }

  Widget _buildFrontendDesignTab(Map<String, dynamic> course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Course Display & Frontend', style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.image, color: Colors.amber, size: 18),
                  const SizedBox(width: 12),
                  const Text('Course Thumbnail', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.upload, size: 14),
                    label: const Text('Upload Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildFormField('Thumbnail Alt Text', 'Learn trading from basics to advanced'),
        const SizedBox(height: 16),
        const Text('Card Display Color', style: TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildColorOption(Colors.green, 'Green'),
            const SizedBox(width: 12),
            _buildColorOption(Colors.blue, 'Blue'),
            const SizedBox(width: 12),
            _buildColorOption(Colors.orange, 'Orange'),
            const SizedBox(width: 12),
            _buildColorOption(Colors.amber, 'Amber'),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Course Badge', style: TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildBadgeOption('🔥 Bestseller', true),
            const SizedBox(width: 12),
            _buildBadgeOption('⭐ New', false),
            const SizedBox(width: 12),
            _buildBadgeOption('🎯 Featured', false),
          ],
        ),
        const SizedBox(height: 16),
        _buildFormField('Short Description (for listing)', 'A concise description shown on course cards'),
      ],
    );
  }

  Widget _buildColorOption(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBadgeOption(String badge, bool isSelected) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.amber : Colors.grey[800],
        foregroundColor: isSelected ? Colors.black : Colors.white,
      ),
      child: Text(badge),
    );
  }

  Widget _buildCurriculumTab(Map<String, dynamic> course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Course Curriculum', style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
              label: const Text('Add Module'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...List.generate(
          3,
          (i) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.gripVertical, color: Colors.amber, size: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Module ${i + 1}: Advanced Strategies', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('5 lessons • 45 minutes', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(icon: const FaIcon(FontAwesomeIcons.pen, size: 14, color: Colors.amber), onPressed: () {}),
                IconButton(icon: const FaIcon(FontAwesomeIcons.trash, size: 14, color: Colors.red), onPressed: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab(Map<String, dynamic> course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Course Settings', style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildToggleSetting('Course Published', true, '✓ Live on platform'),
        const SizedBox(height: 12),
        _buildToggleSetting('Allow Enrollment', true, '✓ Students can enroll'),
        const SizedBox(height: 12),
        _buildToggleSetting('Show on Homepage', true, '✓ Featured'),
        const SizedBox(height: 12),
        _buildToggleSetting('Certificate on Completion', true, '✓ Enabled'),
        const SizedBox(height: 16),
        Divider(color: Colors.amber.withOpacity(0.2)),
        const SizedBox(height: 16),
        _buildFormField('Prerequisites', 'None'),
        const SizedBox(height: 16),
        _buildFormField('Max Enrollment', 'Unlimited'),
        const SizedBox(height: 16),
        const Text('Refund Policy', style: TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Radio(value: 30, groupValue: 30, onChanged: (v) {}, fillColor: MaterialStateProperty.all(Colors.amber)),
            const Text('30 days', style: TextStyle(color: Colors.white)),
            const SizedBox(width: 24),
            Radio(value: 15, groupValue: 30, onChanged: (v) {}, fillColor: MaterialStateProperty.all(Colors.amber)),
            const Text('15 days', style: TextStyle(color: Colors.white)),
            const SizedBox(width: 24),
            Radio(value: 0, groupValue: 30, onChanged: (v) {}, fillColor: MaterialStateProperty.all(Colors.amber)),
            const Text('No refund', style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleSetting(String label, bool value, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(description, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (v) {},
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  void _viewCourseAnalytics(String courseId, Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 700,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Course Analytics',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.amber),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  course['title'] as String,
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                ),
                const SizedBox(height: 24),
                // Analytics Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildAnalyticsStatCard(
                      'Total Enrollments',
                      '${course['students']}',
                      Colors.blue,
                      FontAwesomeIcons.userCheck,
                      '+12% this month',
                    ),
                    _buildAnalyticsStatCard(
                      'Completion Rate',
                      '76.5%',
                      Colors.green,
                      FontAwesomeIcons.circleCheck,
                      '+5% growth',
                    ),
                    _buildAnalyticsStatCard(
                      'Average Rating',
                      '${course['rating']}/5',
                      Colors.amber,
                      FontAwesomeIcons.star,
                      'Excellent feedback',
                    ),
                    _buildAnalyticsStatCard(
                      'Total Revenue',
                      '₹${((course['students'] as int) * 5000).toStringAsFixed(0)}',
                      Colors.green,
                      FontAwesomeIcons.rupeeSign,
                      'This month',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
                  label: const Text('Close'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
              ),
              FaIcon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _manageCourseContent(String courseId, Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 700,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Course Content Manager',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.amber),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  course['title'] as String,
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                ),
                const SizedBox(height: 24),
                // Content Stats
                Row(
                  children: [
                    _buildContentStat('Modules', '${course['modules']}', Colors.blue),
                    const SizedBox(width: 16),
                    _buildContentStat('Lessons', '${course['lessons']}', Colors.green),
                    const SizedBox(width: 16),
                    _buildContentStat('Videos', '${(course['lessons'] as int) - 5}', Colors.orange),
                  ],
                ),
                const SizedBox(height: 24),
                // Module List
                Text(
                  'Modules',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(3, (index) => _buildModuleItem(index + 1)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
                      label: const Text('Close'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.amber),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Content saved successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const FaIcon(FontAwesomeIcons.floppyDisk, size: 16),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleItem(int moduleNum) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '$moduleNum',
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Module $moduleNum - Advanced Strategies',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '5 lessons • 45 minutes',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.pen, size: 16, color: Colors.amber),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _showCourseOptions(Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOptionButton(
                'Duplicate Course',
                FontAwesomeIcons.copy,
                Colors.blue,
                () => Navigator.pop(context),
              ),
              _buildOptionButton(
                'Archive Course',
                FontAwesomeIcons.box,
                Colors.orange,
                () => Navigator.pop(context),
              ),
              _buildOptionButton(
                'View Enrollments',
                FontAwesomeIcons.userGroup,
                Colors.green,
                () => Navigator.pop(context),
              ),
              _buildOptionButton(
                'Delete Course',
                FontAwesomeIcons.trash,
                Colors.red,
                () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: FaIcon(icon, size: 16, color: color),
        label: Text(
          label,
          style: TextStyle(color: color),
        ),
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  void _viewStudentDetails(Map<String, dynamic> student) {
    // Implementation for viewing student details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for: ${student['name'] as String}'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void _sendMessageToStudent(Map<String, dynamic> student) {
    // Implementation for sending message to student
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending message to: ${student['name'] as String}'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void _manageStudent(Map<String, dynamic> student) {
    // Implementation for managing student
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Managing student: ${student['name'] as String}'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void _viewTransactionDetails(Map<String, dynamic> transaction) {
    // Implementation for viewing transaction details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing transaction: ${transaction['id']}'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void _processRefund(Map<String, dynamic> transaction) {
    // Implementation for processing refund
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing refund for: ${transaction['id']}'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void _uploadContent() {
    // Implementation for uploading content
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Upload Content dialog would open here'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void _editContent(Map<String, dynamic> content) {
    // Implementation for editing content
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing content: ${content['title']}'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void _deleteContent(Map<String, dynamic> content) {
    // Implementation for deleting content
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleting content: ${content['title']}'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void _saveSettings() {
    // Implementation for saving settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}