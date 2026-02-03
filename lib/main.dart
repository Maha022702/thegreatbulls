import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:html' as html;
import 'dart:ui';
import 'dart:convert';
import 'privacy_policy_page.dart';
import 'refund_policy_page.dart';
import 'faq_page.dart';
import 'education_content.dart';
import 'terms_and_conditions_page.dart';
import 'kite_config.dart';
import 'kite_oauth_service.dart';
import 'auth_callback_page.dart';
import 'oauth_dashboard.dart';
import 'trading_dashboard.dart';
import 'features_page.dart';
import 'demo_page.dart';
import 'setup_guide_page.dart';
import 'patterns_page.dart';
import 'insights_page.dart';
import 'ai_predictions_page.dart';
import 'admin_panel.dart';
import 'test_fetch.dart';

Future<void> main() async {
  usePathUrlStrategy();
  await testFetch();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static bool _isAdminSubdomain() {
    final hostname = html.window.location.hostname ?? '';
    return hostname.startsWith('admin.');
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = _isAdminSubdomain();

    return ChangeNotifierProvider(
      create: (context) {
        final appState = AppState();
        appState.checkLoginStatus();
        return appState;
      },
      child: MaterialApp.router(
        title: isAdmin ? 'Admin Panel - The Great Bulls' : 'The Great Bulls - Stock Market Analysis',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.amber,
          ),
        ),
        routerConfig: isAdmin ? _adminRouter : _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/features',
      builder: (context, state) => const FeaturesPage(),
    ),
    GoRoute(
      path: '/demo',
      builder: (context, state) => const DemoPage(),
    ),
    GoRoute(
      path: '/setup-guide',
      builder: (context, state) => const SetupGuidePage(),
    ),
    GoRoute(
      path: '/patterns',
      builder: (context, state) => const PatternsPage(),
    ),
    GoRoute(
      path: '/insights',
      builder: (context, state) => const InsightsPage(),
    ),
    GoRoute(
      path: '/ai-predictions',
      builder: (context, state) => const AIPredictionsPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const TradingDashboard(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const SimplePageLayout(child: PrivacyPolicyPage()),
    ),
    GoRoute(
      path: '/refund-policy',
      builder: (context, state) => const SimplePageLayout(child: RefundPolicyPage()),
    ),
    GoRoute(
      path: '/faq',
      builder: (context, state) => const SimplePageLayout(child: FaqPage()),
    ),
    GoRoute(
      path: '/terms-and-conditions',
      builder: (context, state) => const SimplePageLayout(child: TermsAndConditionsPage()),
    ),
    GoRoute(
      path: '/auth/callback',
      builder: (context, state) => const AuthCallbackPage(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminPanel(),
    ),
    // Redirects for old routes
    GoRoute(
      path: '/oauth-login',
      redirect: (context, state) => '/',
    ),
    GoRoute(
      path: '/oauth-dashboard',
      redirect: (context, state) => '/dashboard',
    ),
  ],
);

// Router for admin subdomain only
final GoRouter _adminRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const AdminLoginPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const AdminPanel(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminPanel(),
    ),
    GoRoute(
      path: '/features',
      builder: (context, state) => const FeaturesPage(),
    ),
  ],
  redirect: (context, state) {
    final appState = Provider.of<AppState>(context, listen: false);
    final isLoggedIn = appState.isAdminLoggedIn;

    // Allow access to features page without login
    if (state.matchedLocation == '/features') {
      return null;
    }

    // If not logged in and not on login page, redirect to login
    if (!isLoggedIn && state.matchedLocation != '/login') {
      return '/login';
    }

    // If logged in and on login page, redirect to admin panel
    if (isLoggedIn && state.matchedLocation == '/login') {
      return '/';
    }

    // Always redirect other paths to admin panel for admin subdomain
    if (state.matchedLocation != '/' && state.matchedLocation != '/login' && state.matchedLocation != '/admin') {
      return '/';
    }

    return null;
  },
);

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both username and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final appState = Provider.of<AppState>(context, listen: false);
    final success = await appState.adminLogin(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Set admin token for GitHub commits on successful login
      html.window.localStorage['admin_token'] = '9a90c082633bec136aae7e03a306428c7df93038ed1904ed25b48402b5551299';
      
      if (mounted) {
        context.go('/');
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo/Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(FontAwesomeIcons.crown, color: Colors.amber, size: 48),
                  const SizedBox(width: 16),
                  Text(
                    'Admin Login',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Username field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.amber),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.person, color: Colors.amber),
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.amber),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.amber),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 24),

              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              if (_errorMessage != null) const SizedBox(height: 16),

              // Login button
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              const SizedBox(height: 24),

              // Footer
              Text(
                'The Great Bulls - Admin Panel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  String userName = 'Guest';
  bool isAdminLoggedIn = false;
  EducationContent _currentEducationContent = EducationContent.defaultContent();
  List<Course> _courses = [];
  List<EducationTabCourse> _educationTabCourses = EducationTabCourse.defaultCourses();

  EducationContent get currentEducationContent => _currentEducationContent;
  List<Course> get courses => _courses;
  List<EducationTabCourse> get educationTabCourses => _educationTabCourses;

  set currentEducationContent(EducationContent content) {
    _currentEducationContent = content;
    // Save to localStorage
    final contentJson = jsonEncode(content.toJson());
    html.window.localStorage['education_content'] = contentJson;
    notifyListeners();
  }

  void setCourses(List<Course> newCourses) {
    _courses = newCourses;
    // Save to localStorage
    final coursesJson = jsonEncode(_courses.map((c) => c.toJson()).toList());
    html.window.localStorage['courses'] = coursesJson;
    notifyListeners();
  }

  void addCourse(Course course) {
    _courses.add(course);
    setCourses(_courses);
  }

  void updateCourse(int index, Course course) {
    if (index >= 0 && index < _courses.length) {
      _courses[index] = course;
      setCourses(_courses);
    }
  }

  void removeCourse(int index) {
    if (index >= 0 && index < _courses.length) {
      _courses.removeAt(index);
      setCourses(_courses);
    }
  }

  // Education Tab Courses Management
  void setEducationTabCourses(List<EducationTabCourse> newCourses) {
    _educationTabCourses = newCourses;
    final coursesJson = jsonEncode(_educationTabCourses.map((c) => c.toJson()).toList());
    html.window.localStorage['education_tab_courses'] = coursesJson;
    notifyListeners();
  }

  void updateEducationTabCourse(int index, EducationTabCourse course) {
    if (index >= 0 && index < _educationTabCourses.length) {
      _educationTabCourses[index] = course;
      setEducationTabCourses(_educationTabCourses);
    }
  }

  AppState() {
    _loadEducationContent();
    _loadCourses();
    _loadEducationTabCourses();
  }

  void _loadEducationContent() {
    try {
      final storedContent = html.window.localStorage['education_content'];
      if (storedContent != null && storedContent.isNotEmpty) {
        final contentJson = jsonDecode(storedContent);
        _currentEducationContent = EducationContent.fromJson(contentJson);
      }
    } catch (e) {
      // If loading fails, keep default content
      print('Error loading education content: $e');
    }
  }

  void _loadCourses() {
    try {
      final storedCourses = html.window.localStorage['courses'];
      if (storedCourses != null && storedCourses.isNotEmpty) {
        final coursesJson = jsonDecode(storedCourses) as List;
        _courses = coursesJson.map((c) => Course.fromJson(c)).toList();
      }
    } catch (e) {
      print('Error loading courses: $e');
      _courses = [];
    }
  }

  void _loadEducationTabCourses() {
    try {
      final storedCourses = html.window.localStorage['education_tab_courses'];
      if (storedCourses != null && storedCourses.isNotEmpty) {
        final coursesJson = jsonDecode(storedCourses) as List;
        _educationTabCourses = coursesJson.map((c) => EducationTabCourse.fromJson(c)).toList();
      }
    } catch (e) {
      print('Error loading education tab courses: $e');
      _educationTabCourses = EducationTabCourse.defaultCourses();
    }
  }

  Future<void> checkLoginStatus() async {
    isLoggedIn = await KiteOAuthService.isLoggedIn();
    if (isLoggedIn) {
      try {
        final profile = await KiteOAuthService.getUserProfile();
        if (profile != null && profile['data'] != null) {
          userName = profile['data']['user_name'] ?? 'User';
        }
      } catch (e) {
        print('Error fetching profile: $e');
      }
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await KiteOAuthService.logout();
    isLoggedIn = false;
    userName = 'Guest';
    notifyListeners();
  }

  Future<bool> adminLogin(String username, String password) async {
    // Check credentials
    if (username == 'thegreatbull01' && password == 'MnLkPo9182') {
      isAdminLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void adminLogout() {
    isAdminLoggedIn = false;
    notifyListeners();
  }
}

// Simple layout for legal pages
class SimplePageLayout extends StatelessWidget {
  final Widget child;
  const SimplePageLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text('The Great Bulls', style: TextStyle(color: Colors.amber)),
          ],
        ),
      ),
      body: child,
    );
  }
}

// Main Home Page / Landing Page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _startLogin(BuildContext context) {
    if (KiteConfig.apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing KITE_API_KEY. Set it via --dart-define before deploying.')),
      );
      return;
    }
    final loginUrl = KiteOAuthService.getLoginUrl();
    print('🔐 Starting login: $loginUrl');
    html.window.location.href = loginUrl;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidePanel = screenWidth > 1100;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Top Navigation Bar
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: Colors.black.withOpacity(0.85),
                elevation: 0,
                expandedHeight: 64,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                title: GestureDetector(
                  onTap: () => context.go('/'),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/logov1.png',
                        width: 36,
                        height: 36,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'The Great Bulls',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Home', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () => context.go('/insights'),
                    child: const Text('Insights', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () => context.go('/ai-predictions'),
                    child: const Text('AI Predictions', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () => context.go('/setup-guide'),
                    child: const Text('Education', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () => context.go('/admin'),
                    child: const Text('Admin', style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () => context.go('/faq'),
                    child: const Text('Contact us', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  const SizedBox(width: 30),
                  TextButton(
                    onPressed: () => _startLogin(context),
                    child: const Text('Login', style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _startLogin(context), // For now, using same login function
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Sign up'),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              // Page Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeroSection(context),
                    _buildFeaturesSection(context),
                    _buildHowItWorksSection(context),
                    _buildCtaSection(context),
                    _buildFooter(context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickNav(BuildContext context, bool showSidePanel) {
    final items = [
      ('Features', '/features', FontAwesomeIcons.gem),
      ('Patterns', '/patterns', FontAwesomeIcons.shapes),
      ('Insights', '/insights', FontAwesomeIcons.lightbulb),
      ('AI Predictions', '/ai-predictions', FontAwesomeIcons.robot),
      ('Setup', '/setup-guide', FontAwesomeIcons.wandSparkles),
      ('FAQ', '/faq', FontAwesomeIcons.circleQuestion),
      ('Privacy', '/privacy-policy', FontAwesomeIcons.userShield),
      ('Refund', '/refund-policy', FontAwesomeIcons.rotateLeft),
      ('Terms', '/terms-and-conditions', FontAwesomeIcons.fileContract),
    ];

    final glass = ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          child: showSidePanel
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: TextButton.icon(
                            onPressed: () => context.go(item.$2),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: FaIcon(item.$3, size: 16, color: Colors.amberAccent),
                            label: Text(item.$1, style: const TextStyle(color: Colors.white, fontSize: 14)),
                          ),
                        ),
                      )
                      .toList(),
                )
              : Row(
                  children: items
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ActionChip(
                            backgroundColor: Colors.white.withOpacity(0.08),
                            side: BorderSide(color: Colors.white.withOpacity(0.12)),
                            avatar: FaIcon(item.$3, size: 14, color: Colors.amberAccent),
                            label: Text(item.$1, style: const TextStyle(color: Colors.white)),
                            onPressed: () => context.go(item.$2),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
    );

    if (showSidePanel) {
      return Positioned(
        top: 120,
        right: 18,
        child: SizedBox(width: 220, child: glass),
      );
    }

    return Positioned(
      top: 90,
      left: 12,
      right: 12,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: glass,
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.9),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFF0a0a0a), Color(0xFF1a1a1a), Colors.black],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home_screen.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main Title with Gradient
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.amber, Colors.white, Colors.amber],
                      stops: [0.0, 0.5, 1.0],
                    ).createShader(bounds),
                    child: const Text(
                      'The Great Bulls',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0,
                            color: Color(0x80FFD700),
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Subtitle
                  const Text(
                    'Next-Generation Trading Intelligence Platform',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.8,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  // Description
                  Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: const Text(
                      'Experience the future of trading with AI-powered insights, real-time market data, and institutional-grade tools.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.4,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Inspirational Quote
                  const Text(
                    'It\'s not possible! No, It\'s necessary!!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.amber,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          blurRadius: 8.0,
                          color: Color(0x80FFD700),
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // CTA Button
                  Consumer<AppState>(
                    builder: (context, appState, child) {
                      if (appState.isLoggedIn) {
                        return ElevatedButton.icon(
                          onPressed: () => context.go('/dashboard'),
                          icon: const FaIcon(FontAwesomeIcons.chartLine, size: 20),
                          label: const Text('Go to Dashboard'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 10,
                            shadowColor: Colors.amber.withOpacity(0.5),
                          ),
                        );
                      } else {
                        return ElevatedButton.icon(
                          onPressed: () => _startLogin(context),
                          icon: const FaIcon(FontAwesomeIcons.signInAlt, size: 20),
                          label: const Text('Get Started'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 22),
                            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                            elevation: 15,
                            shadowColor: Colors.amber.withOpacity(0.6),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 30),

                  // Stats Row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.amber.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('10+', 'Stocks Tracked'),
                        _buildStatItem('99.9%', 'Uptime'),
                        _buildStatItem('<1ms', 'Latency'),
                        _buildStatItem('24/7', 'Support'),
                      ],
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

  Widget _buildFloatingCard(String emoji, String title, String subtitle) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
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

  Widget _buildFeaturesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      color: const Color(0xFF1a1a1a),
      child: Column(
        children: [
          const Text(
            'Revolutionary Trading Features',
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.amber),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Experience the future of trading with cutting-edge technology and AI-powered insights',
            style: TextStyle(fontSize: 20, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 80),

          // Main Features Grid
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureCard(
                FontAwesomeIcons.robot,
                'AI-Powered Predictions',
                'Machine learning algorithms analyze market patterns and predict price movements with 85%+ accuracy',
                'Advanced ML models trained on 10+ years of market data',
                Colors.purple,
              ),
              _buildFeatureCard(
                FontAwesomeIcons.chartLine,
                'Live Candlestick Charts',
                'Real-time charts with multiple timeframes, volume analysis, and advanced indicators',
                '1m, 5m, 15m intervals with 7-day history',
                Colors.blue,
              ),
              _buildFeatureCard(
                FontAwesomeIcons.search,
                'Pattern Recognition',
                'Automatic detection of 50+ chart patterns including head & shoulders, double tops, flags',
                'Real-time pattern alerts with confidence scores',
                Colors.green,
              ),
              _buildFeatureCard(
                FontAwesomeIcons.bolt,
                'Lightning Execution',
                'Sub-millisecond order execution with direct Kite Connect integration',
                '99.9% uptime with <1ms latency',
                Colors.orange,
              ),
              _buildFeatureCard(
                FontAwesomeIcons.brain,
                'Technical Insights',
                'AI-generated trading signals, risk analysis, and market sentiment indicators',
                'Real-time sentiment analysis from news & social media',
                Colors.red,
              ),
              _buildFeatureCard(
                FontAwesomeIcons.shieldAlt,
                'Secure & Compliant',
                'Bank-grade security with OAuth 2.0, your credentials stay with Zerodha',
                'ISO 27001 certified infrastructure',
                Colors.teal,
              ),
            ],
          ),

          const SizedBox(height: 80),

          // Advanced Features Section
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Advanced Trading Tools',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAdvancedFeature('📊', 'Portfolio Analytics', 'Deep insights into your trading performance'),
                    _buildAdvancedFeature('🎯', 'Risk Management', 'Automated stop-loss and position sizing'),
                    _buildAdvancedFeature('📈', 'Backtesting', 'Test strategies on historical data'),
                    _buildAdvancedFeature('🔄', 'Auto Trading', 'Execute trades based on AI signals'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description, String subtitle, Color accentColor) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(icon, size: 48, color: accentColor),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentColor.withOpacity(0.3)),
            ),
            child: Text(
              subtitle,
              style: TextStyle(
                color: accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFeature(String emoji, String title, String description) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 200,
          child: Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorksSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: Colors.black,
      child: Column(
        children: [
          const Text(
            'How It Works',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _buildStepCard('1', 'Click Login', 'Click the login button to connect with Zerodha'),
              _buildStepCard('2', 'Authenticate', 'Login with your Zerodha credentials securely'),
              _buildStepCard('3', 'View Dashboard', 'Access your complete trading data instantly'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(String step, String title, String description) {
    return SizedBox(
      width: 280,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(step, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          ),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          Text(description, style: const TextStyle(fontSize: 15, color: Colors.white70), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildCtaSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: const Color(0xFF1a1a1a),
      child: Column(
        children: [
          const Text(
            'Ready to Get Started?',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.amber),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Connect your Zerodha account and start tracking your portfolio now.',
            style: TextStyle(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Consumer<AppState>(
            builder: (context, appState, child) {
              if (appState.isLoggedIn) {
                return ElevatedButton.icon(
                  onPressed: () => context.go('/dashboard'),
                  icon: const FaIcon(FontAwesomeIcons.chartLine, size: 18),
                  label: const Text('View Your Dashboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                );
              } else {
                return ElevatedButton.icon(
                  onPressed: () => _startLogin(context),
                  icon: const FaIcon(FontAwesomeIcons.signInAlt, size: 18),
                  label: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      color: Colors.black,
      child: Column(
        children: [
          // Feature Links
          Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              TextButton(
                onPressed: () => context.go('/features'),
                child: const Text('Features', style: TextStyle(color: Colors.amber)),
              ),
              const Text('|', style: TextStyle(color: Colors.white30)),
              TextButton(
                onPressed: () => context.go('/patterns'),
                child: const Text('Chart Patterns', style: TextStyle(color: Colors.white70)),
              ),
              const Text('|', style: TextStyle(color: Colors.white30)),
              TextButton(
                onPressed: () => context.go('/insights'),
                child: const Text('Technical Insights', style: TextStyle(color: Colors.white70)),
              ),
              const Text('|', style: TextStyle(color: Colors.white30)),
              TextButton(
                onPressed: () => context.go('/ai-predictions'),
                child: const Text('AI Predictions', style: TextStyle(color: Colors.white70)),
              ),
              const Text('|', style: TextStyle(color: Colors.white30)),
              TextButton(
                onPressed: () => context.go('/setup-guide'),
                child: const Text('Setup Guide', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Legal Links
          Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              TextButton(
                onPressed: () => context.go('/privacy-policy'),
                child: const Text('Privacy Policy', style: TextStyle(color: Colors.white70)),
              ),
              const Text('|', style: TextStyle(color: Colors.white30)),
              TextButton(
                onPressed: () => context.go('/refund-policy'),
                child: const Text('Refund Policy', style: TextStyle(color: Colors.white70)),
              ),
              const Text('|', style: TextStyle(color: Colors.white30)),
              TextButton(
                onPressed: () => context.go('/faq'),
                child: const Text('FAQ', style: TextStyle(color: Colors.white70)),
              ),
              const Text('|', style: TextStyle(color: Colors.white30)),
              TextButton(
                onPressed: () => context.go('/terms-and-conditions'),
                child: const Text('Terms & Conditions', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Contact
          const Text(
            'Contact: thegreatbulls2024@gmail.com',
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              const FaIcon(FontAwesomeIcons.bullseye, color: Colors.amber, size: 20),
              const SizedBox(width: 10),
              const Text(
                '© 2026 The Great Bulls. All rights reserved.',
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Not affiliated with Zerodha. Uses Kite Connect API.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
