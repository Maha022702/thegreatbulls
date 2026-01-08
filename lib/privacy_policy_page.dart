import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.amber, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your Privacy Matters to Us',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Effective Date
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Effective Date: January 1, 2025',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Last Updated: January 1, 2025',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Introduction
          _buildSectionCard(
            title: 'Introduction',
            content: 'The Great Bulls ("we," "our," or "us") is committed to protecting the privacy and security of our users\' personal and financial information. This comprehensive Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our advanced trading platform, AI-powered analytics tools, educational resources, and community features.\n\nWe are dedicated to maintaining the highest standards of data protection while providing you with cutting-edge trading technology and market insights. This policy applies to all users of our platform, including free trial users, premium subscribers, and enterprise clients.',
          ),

          // Information We Collect
          _buildSectionCard(
            title: '1. Information We Collect',
            content: 'We collect information to provide you with personalized trading experiences, ensure platform security, and comply with regulatory requirements. We categorize the information we collect as follows:',
            subsections: [
              _buildSubsection(
                title: 'Personal Information',
                content: '• Full name, email address, phone number, and date of birth\n• Residential address and nationality\n• Government-issued identification (for KYC compliance)\n• Profile photograph (optional)\n• Professional background and trading experience level',
              ),
              _buildSubsection(
                title: 'Financial Information',
                content: '• Bank account details and payment information\n• Trading history and portfolio data\n• Investment preferences and risk tolerance\n• Tax identification numbers (where required)\n• Margin and leverage settings',
              ),
              _buildSubsection(
                title: 'Technical Data',
                content: '• IP address, browser type, and device information\n• Platform usage patterns and feature interactions\n• Performance metrics and error logs\n• Session data and authentication tokens',
              ),
              _buildSubsection(
                title: 'Communication Data',
                content: '• Customer support interactions and feedback\n• Community forum posts and discussions\n• Survey responses and research participation\n• Marketing communication preferences',
              ),
              _buildSubsection(
                title: 'AI and Analytics Data',
                content: '• Trading patterns and decision-making data\n• Market analysis preferences\n• AI model interaction logs\n• Performance analytics and improvement data',
              ),
            ],
          ),

          // How We Use Your Information
          _buildSectionCard(
            title: '2. How We Use Your Information',
            content: 'We use your information responsibly and only for legitimate business purposes. Our data usage is designed to enhance your trading experience while maintaining strict privacy standards.',
            subsections: [
              _buildSubsection(
                title: 'Service Provision',
                content: '• Deliver personalized trading platforms and tools\n• Process transactions and manage accounts\n• Provide customer support and technical assistance\n• Enable AI-powered trading insights and predictions',
              ),
              _buildSubsection(
                title: 'Platform Enhancement',
                content: '• Improve platform performance and user experience\n• Develop new features and trading tools\n• Conduct research and analytics for market insights\n• Personalize content and recommendations',
              ),
              _buildSubsection(
                title: 'Compliance and Security',
                content: '• Verify identity and prevent fraud\n• Comply with regulatory requirements (SEBI, RBI, etc.)\n• Maintain platform security and integrity\n• Conduct risk assessments and monitoring',
              ),
              _buildSubsection(
                title: 'Communication',
                content: '• Send important service updates and notifications\n• Provide educational content and market insights\n• Share relevant promotions and offers (with consent)\n• Respond to inquiries and support requests',
              ),
            ],
          ),

          // Information Sharing
          _buildSectionCard(
            title: '3. Information Sharing and Disclosure',
            content: 'We do not sell, trade, or rent your personal information to third parties. We only share information in specific circumstances and with appropriate safeguards.',
            subsections: [
              _buildSubsection(
                title: 'Authorized Sharing',
                content: '• Service Providers: Payment processors, cloud hosting, and analytics partners under strict confidentiality agreements\n• Regulatory Authorities: SEBI, RBI, and other financial regulators as required by law\n• Legal Processes: In response to court orders, subpoenas, or legal investigations\n• Business Partners: Only with explicit consent for co-branded services',
              ),
              _buildSubsection(
                title: 'Third-Party Integrations',
                content: '• Zerodha Kite Connect: Secure API integration for trading functionality\n• Market Data Providers: Real-time market data and analytics\n• Payment Gateways: Secure transaction processing\n• Analytics Tools: Platform performance and user experience insights',
              ),
              _buildSubsection(
                title: 'Data Protection Measures',
                content: '• All third parties must comply with our data protection standards\n• Data is encrypted in transit and at rest\n• Access is limited to necessary personnel only\n• Regular security audits and compliance checks',
              ),
            ],
          ),

          // AI Data Usage
          _buildSectionCard(
            title: '4. AI and Machine Learning Data',
            content: 'Our AI-powered features require specific data handling to provide accurate predictions and insights while protecting your privacy.',
            subsections: [
              _buildSubsection(
                title: 'AI Training Data',
                content: '• Anonymized trading patterns for model improvement\n• Aggregated market data and performance metrics\n• Non-personal behavioral analytics\n• Historical market trends and patterns',
              ),
              _buildSubsection(
                title: 'Personalized AI',
                content: '• Your trading preferences and risk tolerance\n• Historical performance data (with consent)\n• Market analysis preferences\n• Custom AI model adaptations',
              ),
              _buildSubsection(
                title: 'Data Protection in AI',
                content: '• All AI processing uses encrypted data\n• Personal identifiers are removed from training data\n• AI models are regularly audited for bias and accuracy\n• You can opt-out of AI personalization at any time',
              ),
            ],
          ),

          // Data Retention
          _buildSectionCard(
            title: '5. Data Retention and Deletion',
            content: 'We retain your data only as long as necessary for the purposes outlined in this policy or as required by applicable laws and regulations.',
            subsections: [
              _buildSubsection(
                title: 'Retention Periods',
                content: '• Personal Information: 7 years (as required by financial regulations)\n• Financial Records: 8 years (for tax and audit purposes)\n• Communication Logs: 3 years\n• Technical Logs: 1 year\n• AI Training Data: Anonymized and retained indefinitely',
              ),
              _buildSubsection(
                title: 'Data Deletion',
                content: '• You can request account deletion at any time\n• Financial records may be retained for regulatory compliance\n• Some anonymized data may be kept for research purposes\n• Complete data erasure available upon request',
              ),
            ],
          ),

          // Your Rights
          _buildSectionCard(
            title: '6. Your Privacy Rights',
            content: 'You have comprehensive rights regarding your personal data. We are committed to honoring these rights promptly and transparently.',
            subsections: [
              _buildSubsection(
                title: 'Access Rights',
                content: '• Request a copy of all personal data we hold\n• Access your trading history and account information\n• Download your data in a portable format\n• Review AI processing decisions affecting you',
              ),
              _buildSubsection(
                title: 'Control Rights',
                content: '• Correct inaccurate or incomplete information\n• Delete your account and associated data\n• Restrict processing of your personal data\n• Object to automated decision-making',
              ),
              _buildSubsection(
                title: 'Communication Rights',
                content: '• Opt-out of marketing communications\n• Control cookie preferences\n• Manage notification settings\n• Withdraw consent for data processing',
              ),
            ],
          ),

          // Cookies and Tracking
          _buildSectionCard(
            title: '7. Cookies and Tracking Technologies',
            content: 'We use cookies and similar technologies to enhance your experience and provide personalized services.',
            subsections: [
              _buildSubsection(
                title: 'Essential Cookies',
                content: '• Session management and authentication\n• Security and fraud prevention\n• Platform functionality and performance',
              ),
              _buildSubsection(
                title: 'Analytics Cookies',
                content: '• Usage patterns and feature interactions\n• Performance metrics and error tracking\n• Platform improvement and optimization',
              ),
              _buildSubsection(
                title: 'Marketing Cookies',
                content: '• Personalized recommendations\n• Targeted educational content\n• Relevant promotions and offers',
              ),
            ],
          ),

          // International Data Transfers
          _buildSectionCard(
            title: '8. International Data Transfers',
            content: 'As a global trading platform, we may transfer data internationally while maintaining strict protection standards.',
            subsections: [
              _buildSubsection(
                title: 'Data Transfer Safeguards',
                content: '• All transfers comply with GDPR and other regulations\n• Standard Contractual Clauses implemented\n• Encryption and security measures maintained\n• Regular compliance audits conducted',
              ),
              _buildSubsection(
                title: 'Cross-Border Processing',
                content: '• Cloud infrastructure may span multiple jurisdictions\n• Data processing centers in secure locations\n• Legal protections maintained regardless of location',
              ),
            ],
          ),

          // Security Measures
          _buildSectionCard(
            title: '9. Data Security',
            content: 'We implement comprehensive security measures to protect your data against unauthorized access, alteration, disclosure, or destruction.',
            subsections: [
              _buildSubsection(
                title: 'Technical Security',
                content: '• End-to-end encryption (AES-256)\n• Multi-factor authentication\n• Regular security audits and penetration testing\n• Intrusion detection and prevention systems',
              ),
              _buildSubsection(
                title: 'Operational Security',
                content: '• Access controls and role-based permissions\n• Employee background checks and training\n• Incident response and breach notification procedures\n• Regular backup and disaster recovery testing',
              ),
              _buildSubsection(
                title: 'Financial Security',
                content: '• PCI DSS compliance for payment data\n• Secure API integrations with brokers\n• Transaction monitoring and fraud detection\n• Cold storage for sensitive financial data',
              ),
            ],
          ),

          // Children's Privacy
          _buildSectionCard(
            title: '10. Children\'s Privacy',
            content: 'Our platform is designed for adult traders and investors. We do not knowingly collect personal information from children under 18.',
            subsections: [
              _buildSubsection(
                title: 'Age Restrictions',
                content: '• Minimum age requirement of 18 years\n• Age verification during account creation\n• Parental consent not required (adult platform)\n• Immediate account termination if underage use detected',
              ),
            ],
          ),

          // Changes to Policy
          _buildSectionCard(
            title: '11. Changes to This Privacy Policy',
            content: 'We may update this Privacy Policy to reflect changes in our practices, technology, or legal requirements.',
            subsections: [
              _buildSubsection(
                title: 'Update Process',
                content: '• Material changes will be communicated via email\n• 30-day notice period for significant updates\n• Continued use constitutes acceptance\n• Previous versions archived for reference',
              ),
            ],
          ),

          // Contact Information
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.grey, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '12. Contact Us',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'For privacy-related questions, concerns, or to exercise your rights:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 16),
                _ContactInfo(
                  icon: Icons.email,
                  label: 'Email',
                  value: 'privacy@thegreatbulls.com',
                ),
                _ContactInfo(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: '+91 [Your Phone Number]',
                ),
                _ContactInfo(
                  icon: Icons.location_on,
                  label: 'Address',
                  value: 'Tharamangalam, Tamil Nadu, India',
                ),
                _ContactInfo(
                  icon: Icons.security,
                  label: 'Data Protection Officer',
                  value: 'dpo@thegreatbulls.com',
                ),
                SizedBox(height: 16),
                Text(
                  'Response Time: We aim to respond to all privacy inquiries within 48 hours.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    List<Widget>? subsections,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(color: Colors.white, height: 1.6),
          ),
          if (subsections != null) ...[
            const SizedBox(height: 16),
            ...subsections,
          ],
        ],
      ),
    );
  }

  Widget _buildSubsection({
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(color: Colors.white, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}