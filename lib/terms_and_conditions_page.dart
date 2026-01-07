import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Terms and Conditions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Welcome to THE GREAT BULLS! By joining and participating in our community, you agree to comply with the following terms and conditions. Please read them carefully.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '1. Eligibility',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '1.1. You must be at least 14 years old to participate in this community.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '1.2. If you are under the age of 13 years (depending on your country of residence), you may neither use our Platform in any manner nor may you register for any content or services offered therein.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '2. Code of Conduct',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '2.1. Respect: Treat all members with respect. Harassment, hate speech, or abusive language will not be tolerated.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '2.2. Honesty: Provide truthful and accurate information in discussions and transactions.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '2.3. Compliance: Follow all community rules and guidelines posted by administrators.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '2.4. No Solicitation: Do not promote external products, services, or platforms without prior approval.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '2.5. No Illegal Activities: Any illegal trading activities.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '3. Community Content',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '3.1. All information shared within the community is for educational and informational purposes only and does not constitute financial advice.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '3.2. Users are responsible for verifying the accuracy of information before making trading decisions.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '3.3. The Great Bulls is not liable for losses resulting from decisions made based on community discussions.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '4. Trading Activities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '4.1. Any trades or agreements made between members are at your own risk.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '4.2. The community is not responsible for disputes or losses arising from member-to-member transactions.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '5. Privacy and Data Protection',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '5.1. Respect the privacy of other members. Do not share personal information without consent.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '5.2. THE GREAT BULLS will collect and store user data in accordance with our Privacy Policy.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '6. Moderation and Termination',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '6.1. Community moderators reserve the right to delete content, issue warnings, or ban users for violations of these terms.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '6.2. Membership may be revoked at any time for failure to comply with these terms or at the discretion of the administrators.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '7. Zerodha Kite Connect Integration',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '7.1. Our platform uses Zerodha Kite Connect API to provide trading services. By using this feature, you agree to:',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '• Zerodha\'s terms and conditions available at https://zerodha.com/terms',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '• Kite Connect API terms available at https://kite.trade/docs/connect',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '7.2. Authorization: When you connect your Zerodha account, you authorize The Great Bulls to:',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '• Access your account information (profile, margins, holdings)',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '• View your orders, positions, and trade history',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '• Place, modify, and cancel orders on your behalf as instructed by you',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '7.3. Revocation: You can revoke access at any time by:',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '• Logging out from our platform',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '• Revoking access from Zerodha Console',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '7.4. Disclaimer: The Great Bulls is an independent platform and is not affiliated with, endorsed by, or partnered with Zerodha. We are a third-party application using Kite Connect API.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '8. Limitation of Liability',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '8.1. THE GREAT BULLS is not responsible for any financial losses, damages, or disputes arising from community participation.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '8.2. Participation in trading activities is at your own risk, and you should consult with a financial advisor before making significant financial decisions.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '8.3. We are not liable for any losses due to API downtime, connectivity issues, or order execution failures.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '8.4. Market risks are inherent in trading. Past performance does not guarantee future results.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '10. Amendments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '10.1. These terms may be updated from time to time. Members will be notified of significant changes. Continued participation in the community after updates constitutes acceptance of the new terms.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '11. Governing Law',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '11.1. These terms shall be governed by and construed in accordance with the laws of India.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            '11.2. Any disputes arising from the use of this platform shall be subject to the exclusive jurisdiction of courts in Tamil Nadu, India.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'By joining The Great Bulls, you acknowledge that you have read, understood, and agreed to these terms and conditions.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'For any questions or concerns, please contact us at thegreatbulls2024@gmail.com.',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}