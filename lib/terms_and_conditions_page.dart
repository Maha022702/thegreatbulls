import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

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
                  'Terms and Conditions',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Legal Agreement for Platform Usage',
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

          // Agreement to Terms
          _buildSectionCard(
            title: 'Agreement to Terms',
            content: 'By accessing and using The Great Bulls platform ("Platform"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.\n\nThese Terms and Conditions constitute a legally binding agreement between you and The Great Bulls. Your continued use of the Platform following any changes to these terms constitutes acceptance of those changes.',
          ),

          // Description of Service
          _buildSectionCard(
            title: '1. Description of Service',
            content: 'The Great Bulls is an advanced trading platform that provides:',
            subsections: [
              _buildSubsection(
                title: 'Core Services',
                content: '• AI-powered trading analytics and predictions\n• Real-time market data and charting\n• Technical analysis tools and indicators\n• Pattern recognition and market insights\n• Educational resources and trading guides',
              ),
              _buildSubsection(
                title: 'Integration Services',
                content: '• Zerodha Kite Connect API integration\n• Automated trading execution\n• Portfolio management and tracking\n• Risk assessment and management tools',
              ),
              _buildSubsection(
                title: 'Community Features',
                content: '• Trading community discussions\n• Educational content and webinars\n• Market analysis sharing\n• Professional networking',
              ),
            ],
          ),

          // User Eligibility
          _buildSectionCard(
            title: '2. User Eligibility and Account Registration',
            content: 'To use our Platform, you must meet the following requirements:',
            subsections: [
              _buildSubsection(
                title: 'Age Requirements',
                content: '• Be at least 18 years old\n• Have legal capacity to enter into contracts\n• Not be prohibited from trading by applicable laws',
              ),
              _buildSubsection(
                title: 'Account Requirements',
                content: '• Provide accurate and complete registration information\n• Maintain current and valid contact information\n• Accept responsibility for account security\n• Comply with KYC/AML requirements where applicable',
              ),
              _buildSubsection(
                title: 'Trading Eligibility',
                content: '• Hold a valid demat account with a SEBI-registered broker\n• Understand trading risks and market volatility\n• Have sufficient knowledge of financial markets\n• Accept that all trading involves risk of loss',
              ),
            ],
          ),

          // Account Responsibilities
          _buildSectionCard(
            title: '3. Account Responsibilities',
            content: 'You are responsible for maintaining the confidentiality and security of your account credentials.',
            subsections: [
              _buildSubsection(
                title: 'Security Obligations',
                content: '• Keep login credentials confidential\n• Enable two-factor authentication\n• Report suspicious activity immediately\n• Use strong, unique passwords',
              ),
              _buildSubsection(
                title: 'Account Usage',
                content: '• Use the account only for lawful purposes\n• Do not share account access with others\n• Monitor account activity regularly\n• Update contact information promptly',
              ),
              _buildSubsection(
                title: 'Account Termination',
                content: '• We may suspend or terminate accounts for violations\n• Users may request account deletion\n• Financial records may be retained for regulatory compliance\n• Outstanding obligations remain enforceable',
              ),
            ],
          ),

          // Subscription and Payment Terms
          _buildSectionCard(
            title: '4. Subscription and Payment Terms',
            content: 'Access to premium features requires a valid subscription.',
            subsections: [
              _buildSubsection(
                title: 'Subscription Plans',
                content: '• Monthly and annual subscription options\n• Feature access based on plan tier\n• Automatic renewal unless cancelled\n• Price changes with 30-day notice',
              ),
              _buildSubsection(
                title: 'Payment Terms',
                content: '• Payments processed securely through authorized gateways\n• All fees are non-refundable except as stated in refund policy\n• Late payment may result in service suspension\n• Currency conversion fees may apply',
              ),
              _buildSubsection(
                title: 'Billing Disputes',
                content: '• Contact support within 30 days of charge\n• Provide detailed dispute information\n• Resolution within 14 business days\n• Refunds issued to original payment method',
              ),
            ],
          ),

          // AI and Technology Usage
          _buildSectionCard(
            title: '5. AI and Technology Usage',
            content: 'Our AI-powered features are provided for informational purposes only.',
            subsections: [
              _buildSubsection(
                title: 'AI Predictions',
                content: '• AI predictions are not guaranteed\n• Past performance does not predict future results\n• Users should verify all AI recommendations\n• AI tools supplement, do not replace, human judgment',
              ),
              _buildSubsection(
                title: 'Technology Limitations',
                content: '• Platform availability not guaranteed\n• Technical issues may cause service interruptions\n• Data accuracy depends on market conditions\n• Algorithm performance may vary',
              ),
              _buildSubsection(
                title: 'Data Usage',
                content: '• AI models trained on anonymized market data\n• Personal trading data used to improve recommendations\n• Data processing complies with privacy regulations\n• Users can opt-out of personalized AI features',
              ),
            ],
          ),

          // Trading and Financial Services
          _buildSectionCard(
            title: '6. Trading and Financial Services',
            content: 'The Platform facilitates trading through third-party broker integrations.',
            subsections: [
              _buildSubsection(
                title: 'Trading Execution',
                content: '• Orders executed through Zerodha Kite Connect\n• No guaranteed execution or price improvement\n• Market orders subject to slippage\n• Platform does not hold client funds',
              ),
              _buildSubsection(
                title: 'Risk Disclosure',
                content: '• Trading involves substantial risk of loss\n• Users may lose more than invested amount\n• Past performance does not guarantee future results\n• Market volatility can cause rapid losses',
              ),
              _buildSubsection(
                title: 'Broker Relationships',
                content: '• Independent from Zerodha and other brokers\n• Not responsible for broker service quality\n• Users must comply with broker terms\n• Disputes with brokers handled directly',
              ),
            ],
          ),

          // Prohibited Activities
          _buildSectionCard(
            title: '7. Prohibited Activities',
            content: 'Users must not engage in any activities that violate these terms or applicable laws.',
            subsections: [
              _buildSubsection(
                title: 'Trading Violations',
                content: '• Insider trading or market manipulation\n• Wash trading or spoofing\n• Front-running or unfair practices\n• Trading based on non-public information',
              ),
              _buildSubsection(
                title: 'Platform Abuse',
                content: '• Attempting to hack or compromise the platform\n• Distributing malware or viruses\n• Excessive API calls or system abuse\n• Circumventing security measures',
              ),
              _buildSubsection(
                title: 'Content Violations',
                content: '• Posting false or misleading information\n• Harassment or discriminatory content\n• Copyright infringement\n• Spam or unsolicited communications',
              ),
            ],
          ),

          // Intellectual Property
          _buildSectionCard(
            title: '8. Intellectual Property Rights',
            content: 'All content and technology on the Platform is protected by intellectual property laws.',
            subsections: [
              _buildSubsection(
                title: 'Platform IP',
                content: '• Software, algorithms, and AI models owned by us\n• User interface designs and branding\n• Educational content and trading strategies\n• Database rights and data compilations',
              ),
              _buildSubsection(
                title: 'User Content',
                content: '• Users retain rights to their original content\n• Grant us license to display and distribute\n• Must not infringe third-party rights\n• Community content subject to platform rules',
              ),
              _buildSubsection(
                title: 'Third-Party IP',
                content: '• Market data from authorized providers\n• Integration with licensed APIs\n• Open-source components under respective licenses\n• User-generated content from community',
              ),
            ],
          ),

          // Privacy and Data Protection
          _buildSectionCard(
            title: '9. Privacy and Data Protection',
            content: 'Your privacy is protected in accordance with our Privacy Policy and applicable laws.',
            subsections: [
              _buildSubsection(
                title: 'Data Collection',
                content: '• Personal information for account management\n• Trading data for platform improvement\n• Usage analytics for service optimization\n• Communication data for support purposes',
              ),
              _buildSubsection(
                title: 'Data Security',
                content: '• Industry-standard encryption methods\n• Secure data storage and transmission\n• Regular security audits and updates\n• Incident response and breach notification',
              ),
              _buildSubsection(
                title: 'Data Rights',
                content: '• Access to your personal data\n• Correction of inaccurate information\n• Data deletion upon request\n• Data portability options',
              ),
            ],
          ),

          // Disclaimers and Limitations
          _buildSectionCard(
            title: '10. Disclaimers and Limitations of Liability',
            content: 'The Platform is provided "as is" without warranties of any kind.',
            subsections: [
              _buildSubsection(
                title: 'Service Disclaimers',
                content: '• No guarantee of uninterrupted service\n• No warranty of accuracy or completeness\n• No guarantee of profitability\n• No professional financial advice provided',
              ),
              _buildSubsection(
                title: 'Liability Limitations',
                content: '• Maximum liability limited to subscription fees\n• No liability for trading losses\n• No liability for third-party actions\n• No consequential or indirect damages',
              ),
              _buildSubsection(
                title: 'Risk Acknowledgment',
                content: '• Users assume all trading risks\n• Market conditions can change rapidly\n• Technical issues may affect trading\n• Force majeure events beyond our control',
              ),
            ],
          ),

          // Indemnification
          _buildSectionCard(
            title: '11. Indemnification',
            content: 'You agree to indemnify and hold harmless The Great Bulls from any claims arising from your use of the Platform.',
            subsections: [
              _buildSubsection(
                title: 'Indemnification Scope',
                content: '• Claims from violation of these terms\n• Claims from infringement of third-party rights\n• Claims from illegal or harmful activities\n• Claims from inaccurate or misleading content',
              ),
              _buildSubsection(
                title: 'Defense Obligations',
                content: '• Promptly notify us of any claims\n• Provide reasonable cooperation in defense\n• Allow us to control defense strategy\n• Not settle claims without our consent',
              ),
            ],
          ),

          // Termination
          _buildSectionCard(
            title: '12. Termination and Suspension',
            content: 'Either party may terminate this agreement under certain conditions.',
            subsections: [
              _buildSubsection(
                title: 'Termination by User',
                content: '• Cancel subscription at any time\n• Request account deletion\n• Export data before termination\n• Outstanding payments remain due',
              ),
              _buildSubsection(
                title: 'Termination by Us',
                content: '• Immediate termination for serious violations\n• Suspension for investigation of violations\n• Notice provided for non-serious breaches\n• Appeal process available for suspensions',
              ),
              _buildSubsection(
                title: 'Post-Termination',
                content: '• Access to platform immediately ceases\n• Data retention per privacy policy\n• Outstanding obligations survive\n• Some restrictions may continue',
              ),
            ],
          ),

          // Dispute Resolution
          _buildSectionCard(
            title: '13. Dispute Resolution',
            content: 'Disputes will be resolved through binding arbitration or mediation.',
            subsections: [
              _buildSubsection(
                title: 'Informal Resolution',
                content: '• Contact support for initial dispute resolution\n• 30-day period for informal resolution\n• Documentation of dispute required\n• Good faith negotiation expected',
              ),
              _buildSubsection(
                title: 'Formal Resolution',
                content: '• Binding arbitration in Tamil Nadu, India\n• Arbitration conducted in English\n• Arbitrator decision is final and binding\n• Each party bears own arbitration costs',
              ),
              _buildSubsection(
                title: 'Class Action Waiver',
                content: '• No class action lawsuits permitted\n• Individual arbitration only\n• No representative claims\n• Waiver of class action rights',
              ),
            ],
          ),

          // Governing Law
          _buildSectionCard(
            title: '14. Governing Law and Jurisdiction',
            content: 'These terms are governed by Indian law and subject to Indian jurisdiction.',
            subsections: [
              _buildSubsection(
                title: 'Applicable Law',
                content: '• Governed by laws of India\n• Information Technology Act, 2000\n• SEBI regulations for financial services\n• Consumer Protection Act where applicable',
              ),
              _buildSubsection(
                title: 'Jurisdiction',
                content: '• Exclusive jurisdiction of Tamil Nadu courts\n• Arbitration in Chennai, Tamil Nadu\n• International users subject to Indian law\n• Compliance with local laws required',
              ),
            ],
          ),

          // Amendments and Updates
          _buildSectionCard(
            title: '15. Amendments and Updates',
            content: 'We may update these terms to reflect changes in our services or legal requirements.',
            subsections: [
              _buildSubsection(
                title: 'Update Process',
                content: '• Material changes communicated via email\n• 30-day notice for significant changes\n• Continued use constitutes acceptance\n• Previous versions archived for reference',
              ),
              _buildSubsection(
                title: 'User Obligations',
                content: '• Regular review of terms recommended\n• Notification of changes to contact information\n• Acceptance of updates required for continued use\n• Right to terminate if updates unacceptable',
              ),
            ],
          ),

          // Severability
          _buildSectionCard(
            title: '16. Severability and Entire Agreement',
            content: 'If any provision is found invalid, the remainder remains in effect.',
            subsections: [
              _buildSubsection(
                title: 'Severability',
                content: '• Invalid provisions severed from agreement\n• Remaining terms continue in full force\n• Court may modify invalid provisions\n• Intent of agreement preserved',
              ),
              _buildSubsection(
                title: 'Entire Agreement',
                content: '• These terms constitute complete agreement\n• Supersedes all prior agreements\n• Privacy Policy incorporated by reference\n• Refund Policy incorporated by reference',
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
                  '17. Contact Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'For questions about these Terms and Conditions:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 16),
                _ContactInfo(
                  icon: Icons.email,
                  label: 'Legal Support',
                  value: 'legal@thegreatbulls.com',
                ),
                _ContactInfo(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: '+91 [Your Phone Number]',
                ),
                _ContactInfo(
                  icon: Icons.location_on,
                  label: 'Registered Address',
                  value: 'Tharamangalam, Tamil Nadu, India',
                ),
                _ContactInfo(
                  icon: Icons.business,
                  label: 'Business Hours',
                  value: 'Monday - Friday, 9:00 AM - 6:00 PM IST',
                ),
                SizedBox(height: 16),
                Text(
                  'We aim to respond to all inquiries within 48 hours.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // Acceptance Acknowledgment
          Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Acknowledgment of Terms',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'By using The Great Bulls platform, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions. Your continued use of the platform constitutes ongoing acceptance of these terms.',
                  style: TextStyle(color: Colors.white, height: 1.6),
                ),
                SizedBox(height: 12),
                Text(
                  'Last updated: January 1, 2025',
                  style: TextStyle(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
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
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    ),
    );
  }
}