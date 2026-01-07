import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import 'kite_oauth_service.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  String _status = 'Processing authorization...';
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    _handleAuthCallback();
  }

  Future<void> _handleAuthCallback() async {
    try {
      // Get the current URL parameters
      final uri = Uri.base;
      print('🔗 Full callback URL: ${uri.toString()}');
      print('🔗 Query parameters: ${uri.queryParameters}');
      print('🔗 Fragment: ${uri.fragment}');

      // Try to get parameters from query string first
      String? requestToken = uri.queryParameters['request_token'];
      String? status = uri.queryParameters['status'];

      // If not found in query, try fragment (hash)
      if (requestToken == null && uri.fragment.isNotEmpty) {
        final fragmentParams = Uri.parse('?' + uri.fragment).queryParameters;
        requestToken = fragmentParams['request_token'];
        status = fragmentParams['status'];
        print('🔗 Found params in fragment: request_token=$requestToken, status=$status');
      }

      print('📋 Auth callback received:');
      print('Request token: $requestToken');
      print('Status: $status');

      if (status != 'success' || requestToken == null || requestToken.isEmpty) {
        setState(() {
          _status = '❌ Authorization failed or cancelled\nStatus: $status\nRequest Token: $requestToken\n\nFull URL: ${uri.toString()}';
          _isProcessing = false;
        });
        return;
      }

      setState(() => _status = '🔄 Exchanging authorization code for access token...\nRequest Token: ${requestToken?.substring(0, min(10, requestToken.length)) ?? 'N/A'}...');

      // Exchange the request token for access token
      final tokenData = await KiteOAuthService.exchangeCodeForToken(requestToken);

      if (tokenData != null) {
        setState(() {
          _status = '✅ Login successful! Redirecting to dashboard...';
          _isProcessing = false;
        });

        // Verify tokens are saved before navigating
        print('🔍 Verifying tokens are saved before navigation...');
        final isLoggedIn = await KiteOAuthService.isLoggedIn();
        print('🔍 Login status after token save: $isLoggedIn');

        if (!isLoggedIn) {
          setState(() {
            _status = '❌ Tokens not saved properly! Login status: $isLoggedIn';
          });
          return;
        }

        // Wait a moment to show success message then auto-navigate
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          print('🚀 Auto-navigating to dashboard...');
          context.go('/dashboard');
        }
      } else {
        setState(() {
          _status = '❌ Failed to get access token\nCheck console for details';
          _isProcessing = false;
        });
      }
    } catch (e) {
      print('❌ Auth callback error: $e');
      setState(() {
        _status = '❌ Error processing authorization: $e';
        _isProcessing = false;
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
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber, width: 2),
                ),
                child: Icon(
                  _isProcessing ? Icons.hourglass_top : Icons.check_circle,
                  size: 60,
                  color: _isProcessing ? Colors.amber : Colors.green,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'DevForge',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 48),

              // Status Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    if (_isProcessing)
                      const SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                        ),
                      )
                    else
                      Icon(
                        _status.contains('✅') ? Icons.check_circle : Icons.error,
                        size: 32,
                        color: _status.contains('✅') ? Colors.green : Colors.red,
                      ),
                    const SizedBox(height: 16),
                    Text(
                      _status,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              if (!_isProcessing) ...[
                const SizedBox(height: 32),
                if (_status.contains('✅')) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => context.go('/oauth-dashboard'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Go to Dashboard',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => context.go('/oauth-login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}