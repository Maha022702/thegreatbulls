import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html show window;
import 'kite_config.dart';
import 'kite_oauth_service.dart';

class OAuthLoginPage extends StatefulWidget {
  const OAuthLoginPage({super.key});

  @override
  State<OAuthLoginPage> createState() => _OAuthLoginPageState();
}

class _OAuthLoginPageState extends State<OAuthLoginPage> {
  bool _isLoading = false;

  Future<void> _checkTokenStatus() async {
    print('🔍 Checking token status...');
    final isLoggedIn = await KiteOAuthService.isLoggedIn();
    print('🔍 Token status result: $isLoggedIn');

    // Also try to manually check storage
    try {
      final accessToken = await KiteOAuthService.getAccessTokenForDebug();
      final publicToken = await KiteOAuthService.getPublicTokenForDebug();
      print('🔍 Manual storage check:');
      print('🔍 Access Token: ${accessToken != null ? 'EXISTS (${accessToken.length} chars)' : 'NULL'}');
      print('🔍 Public Token: ${publicToken != null ? 'EXISTS (${publicToken.length} chars)' : 'NULL'}');
    } catch (e) {
      print('🔍 Storage error: $e');
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Status: ${isLoggedIn ? 'LOGGED IN' : 'NOT LOGGED IN'}\nCheck console for details'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _setTestTokens() async {
    print('🧪 Setting test tokens...');
    try {
      await KiteOAuthService.setTestTokensForDebug('YlCF1r0tzWHxX22sp22Zc4UqCjOI93zT', 'gPL0L3tTuFClXCGOMaXNEvRZuKGOJ5Wn');
      print('🧪 Test tokens set successfully');

      // Check if they were saved
      final accessToken = await KiteOAuthService.getAccessTokenForDebug();
      final publicToken = await KiteOAuthService.getPublicTokenForDebug();
      print('🧪 Verification - Access Token: ${accessToken != null ? 'SAVED' : 'NOT SAVED'}');
      print('🧪 Verification - Public Token: ${publicToken != null ? 'SAVED' : 'NOT SAVED'}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test tokens set! Click "Check Login Status" to verify.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('🧪 Error setting test tokens: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting test tokens: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _checkLoginStatus() async {
    print('🔍 LoginPage: Checking login status...');
    final isLoggedIn = await KiteOAuthService.isLoggedIn();
    print('🔍 LoginPage: Login status result: $isLoggedIn');
    if (isLoggedIn && mounted) {
      print('🔍 LoginPage: User is logged in, redirecting to dashboard...');
      context.go('/oauth-dashboard');
    } else {
      print('🔍 LoginPage: User is not logged in, staying on login page');
    }
  }

  Future<void> _startOAuthLogin() async {
    setState(() => _isLoading = true);

    try {
      final loginUrl = KiteOAuthService.getLoginUrl();
      print('🌐 Opening login URL: $loginUrl');

      if (kIsWeb) {
        // For Flutter Web, redirect in the SAME window so callback works
        print('🌐 Web platform detected - using same-window navigation');
        html.window.location.href = loginUrl;
      } else {
        // For mobile/desktop, use external browser
        final uri = Uri.parse(loginUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $loginUrl';
        }
      }
    } catch (e) {
      print('❌ Error starting OAuth login: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting login: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              // Logo/Title
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber, width: 2),
                ),
                child: const Icon(
                  Icons.trending_up,
                  size: 60,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 32),

              // App Title
              const Text(
                'DevForge',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Zerodha Kite Integration',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 48),

              // Login Instructions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    const Text(
                      '🔐 Secure OAuth Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Click below to securely login with your Zerodha account. You\'ll be redirected to Zerodha\'s official login page.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _startOAuthLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Login with Zerodha',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Debug Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _checkTokenStatus,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.amber),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Check Login Status',
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Test Tokens Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _setTestTokens,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Set Test Tokens (Debug)',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Your credentials are handled securely by Zerodha\'s official servers.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}