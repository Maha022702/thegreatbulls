import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:html' as html;
import 'privacy_policy_page.dart';
import 'refund_policy_page.dart';
import 'faq_page.dart';
import 'terms_and_conditions_page.dart';
import 'kite_oauth_service.dart';
import 'auth_callback_page.dart';
import 'oauth_dashboard.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final appState = AppState();
        appState.checkLoginStatus();
        return appState;
      },
      child: MaterialApp.router(
        title: 'The Great Bulls - Stock Market Analysis',
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
        routerConfig: _router,
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
      path: '/dashboard',
      builder: (context, state) => const OAuthDashboard(),
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

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  String userName = 'Guest';

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
    final loginUrl = KiteOAuthService.getLoginUrl();
    print('🔐 Starting login: $loginUrl');
    html.window.location.href = loginUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Top Navigation Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Colors.black.withOpacity(0.95),
            elevation: 0,
            expandedHeight: 60,
            title: GestureDetector(
              onTap: () => context.go('/'),
              child: Row(
                children: const [
                  FaIcon(FontAwesomeIcons.bullseye, color: Colors.amber, size: 28),
                  SizedBox(width: 12),
                  Text(
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
              Consumer<AppState>(
                builder: (context, appState, child) {
                  if (appState.isLoggedIn) {
                    return Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => context.go('/dashboard'),
                          icon: const FaIcon(FontAwesomeIcons.chartLine, color: Colors.white, size: 16),
                          label: const Text('Dashboard', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.user, color: Colors.amber, size: 14),
                              const SizedBox(width: 8),
                              Text(appState.userName, style: const TextStyle(color: Colors.amber)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () async {
                            await appState.logout();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Logged out successfully')),
                              );
                            }
                          },
                          icon: const FaIcon(FontAwesomeIcons.signOutAlt, color: Colors.redAccent, size: 16),
                          label: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
                        ),
                        const SizedBox(width: 16),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: ElevatedButton.icon(
                        onPressed: () => _startLogin(context),
                        icon: const FaIcon(FontAwesomeIcons.signInAlt, size: 16),
                        label: const Text('Login with Zerodha'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    );
                  }
                },
              ),
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
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFF1a1a1a), Colors.black],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.bullseye, size: 100, color: Colors.amber),
              const SizedBox(height: 30),
              const Text(
                'The Great Bulls',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                  shadows: [
                    Shadow(blurRadius: 20.0, color: Color(0x80FFD700), offset: Offset(0, 0)),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Personal Trading Dashboard',
                style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Connect your Zerodha account and access your portfolio,\nholdings, positions, and orders in real-time.',
                  style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
              Consumer<AppState>(
                builder: (context, appState, child) {
                  if (appState.isLoggedIn) {
                    return ElevatedButton.icon(
                      onPressed: () => context.go('/dashboard'),
                      icon: const FaIcon(FontAwesomeIcons.chartLine, size: 18),
                      label: const Text('Go to Dashboard'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    );
                  } else {
                    return ElevatedButton.icon(
                      onPressed: () => _startLogin(context),
                      icon: const FaIcon(FontAwesomeIcons.signInAlt, size: 18),
                      label: const Text('Login with Zerodha'),
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
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: const Color(0xFF1a1a1a),
      child: Column(
        children: [
          const Text(
            'What You Get',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          const SizedBox(height: 16),
          const Text(
            'Access your complete Zerodha trading data in one place',
            style: TextStyle(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureCard(FontAwesomeIcons.wallet, 'Account Balance', 'View your available margins and funds in real-time'),
              _buildFeatureCard(FontAwesomeIcons.briefcase, 'Holdings', 'Track all your long-term stock holdings'),
              _buildFeatureCard(FontAwesomeIcons.chartBar, 'Positions', 'Monitor your intraday and F&O positions'),
              _buildFeatureCard(FontAwesomeIcons.clipboardList, 'Orders', 'View pending, completed, and cancelled orders'),
              _buildFeatureCard(FontAwesomeIcons.rupeeSign, 'P&L Tracking', 'Real-time profit and loss calculations'),
              _buildFeatureCard(FontAwesomeIcons.shieldAlt, 'Secure', 'OAuth 2.0 authentication - your credentials stay with Zerodha'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        children: [
          FaIcon(icon, size: 44, color: Colors.amber),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
          const SizedBox(height: 12),
          Text(description, style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.4), textAlign: TextAlign.center),
        ],
      ),
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
                  label: const Text('Login with Zerodha'),
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
              FaIcon(FontAwesomeIcons.bullseye, color: Colors.amber, size: 20),
              SizedBox(width: 10),
              Text(
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
