import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SetupGuidePage extends StatelessWidget {
  const SetupGuidePage({super.key});

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
            Text('Setup Guide', style: TextStyle(color: Colors.amber)),
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
                  colors: [Colors.blue, Colors.indigo, Colors.purple],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.cogs, size: 50, color: Colors.white),
                    const SizedBox(height: 15),
                    const Text(
                      'Kite Connect Setup Guide',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Get started with The Great Bulls in 5 minutes',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Setup Steps
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStep(
                    1,
                    'Create Zerodha Account',
                    'If you don\'t have a Zerodha account yet, sign up at zerodha.com',
                    FontAwesomeIcons.userPlus,
                    Colors.green,
                    [
                      'Visit zerodha.com',
                      'Complete KYC process',
                      'Fund your account',
                      'Note: Only Indian residents can trade on Zerodha',
                    ],
                  ),

                  const SizedBox(height: 40),

                  _buildStep(
                    2,
                    'Enable Kite Connect',
                    'Login to Kite and enable API access for third-party applications',
                    FontAwesomeIcons.key,
                    Colors.blue,
                    [
                      'Login to kite.zerodha.com',
                      'Go to Settings → Kite Connect',
                      'Click "Create API Key"',
                      'Accept the terms and conditions',
                      'Copy your API Key and Secret (keep secret safe!)',
                    ],
                  ),

                  const SizedBox(height: 40),

                  _buildStep(
                    3,
                    'Configure Redirect URL',
                    'Set the callback URL for OAuth authentication',
                    FontAwesomeIcons.link,
                    Colors.orange,
                    [
                      'In Kite Connect settings, set Redirect URL to:',
                      'https://www.thegreatbulls.in/auth/callback',
                      'Save the settings',
                      'Your API is now ready to use!',
                    ],
                  ),

                  const SizedBox(height: 40),

                  _buildStep(
                    4,
                    'Connect to The Great Bulls',
                    'Login with your Zerodha credentials on our platform',
                    FontAwesomeIcons.signInAlt,
                    Colors.purple,
                    [
                      'Click "Login with Zerodha" on our homepage',
                      'Enter your Zerodha credentials',
                      'Complete 2FA if enabled',
                      'Grant permissions to access your trading data',
                      'You\'re all set! Start trading with AI insights',
                    ],
                  ),

                  const SizedBox(height: 60),

                  // API Details Section
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
                          '🔐 API Configuration Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildApiDetail('API Key', 'Set via KITE_API_KEY (dart-define)', 'Generated in Kite Connect console'),
                        _buildApiDetail('API Secret', 'Never shown in-app', 'Keep private in your backend or environment'),
                        _buildApiDetail('Redirect URL', 'https://www.thegreatbulls.in/auth/callback', 'OAuth callback endpoint'),
                        _buildApiDetail('Supported Products', 'CNC, MIS, NRML', 'Available trading products'),
                        _buildApiDetail('Rate Limits', '10 requests/second', 'API rate limiting'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Troubleshooting Section
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🔧 Troubleshooting',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTroubleshootingItem(
                          'Login Issues',
                          'If you can\'t login, check if Kite Connect is enabled and redirect URL is correct.',
                        ),
                        _buildTroubleshootingItem(
                          'API Errors',
                          'Ensure your API key is active and you have sufficient trading permissions.',
                        ),
                        _buildTroubleshootingItem(
                          'Data Not Loading',
                          'Check your internet connection and ensure market is open (9:15 AM - 3:30 PM IST).',
                        ),
                        _buildTroubleshootingItem(
                          'Permission Denied',
                          'Make sure you\'ve granted all required permissions during OAuth flow.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Security Notice
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.shieldAlt, color: Colors.green, size: 24),
                            const SizedBox(width: 10),
                            const Text(
                              'Security & Privacy',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          '• Your Zerodha credentials are never stored on our servers\n'
                          '• All authentication happens directly with Zerodha\'s secure servers\n'
                          '• We only access the data you explicitly grant permission for\n'
                          '• API secrets stay in your environment/back-end, never displayed in the app\n'
                          '• All data transmission is encrypted using HTTPS/TLS',
                          style: TextStyle(
                            color: Colors.white,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // CTA
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const FaIcon(FontAwesomeIcons.rocket),
                      label: const Text('Start Trading Now'),
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

  Widget _buildStep(int stepNumber, String title, String description, IconData icon, Color color, List<String> instructions) {
    return Container(
      padding: const EdgeInsets.all(30),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    stepNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              FaIcon(icon, color: color, size: 28),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),
          ...instructions.map((instruction) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: Colors.amber, fontSize: 16)),
                Expanded(
                  child: Text(
                    instruction,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildApiDetail(String label, String value, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$label: ',
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingItem(String issue, String solution) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            issue,
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            solution,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}