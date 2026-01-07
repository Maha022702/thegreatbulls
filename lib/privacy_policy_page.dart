import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Effective Date: 01.01.2025\nLast Updated: 01.01.2025',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Text(
            'The Great Bulls ("we," "our," or "us") is committed to protecting the privacy of our traders, customers, and community. This Privacy Policy outlines how we collect, use, disclose, and safeguard your information when you engage with us through our services, including trading platforms, newsletters, educational resources, and community forums.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '1. Information We Collect',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We collect the following types of personal data:',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Personal Information: First and Last Name, email address, age, gender, Photograph, location and phone number when you sign up for our services.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            'Financial Information: Payment details, trading preferences, and transaction history.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            'Communication Data: Information provided when you contact support, participate in surveys, or engage in our community discussions.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '2. How We Use Your Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We use your information for the following purposes:',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'To provide, manage, and improve our trading services and platforms.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            'To process payments and ensure secure transactions.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            'To send important updates, newsletters, or marketing communications.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            'To comply with legal or regulatory requirements.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '3. How We Share Your Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We do not sell your personal data. However, we may share your information with:',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Service Providers: Trusted partners who assist in payment processing, hosting, or analytics.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            'Legal Authorities: To comply with applicable laws or respond to legal requests.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            'Business Partners: With your explicit consent for co-branded services or promotions.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '4. Data Retention',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We retain your data only as long as necessary to fulfill the purposes outlined in this policy, or as required by law. You can request deletion of your data at any time.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '5. Your Privacy Rights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Depending on your location, you may have the following rights:',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Access your personal data.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            'Correct inaccuracies in your information.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            'Request data deletion.',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            'Opt out of marketing communications.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'To exercise these rights, contact us at thegreatbulls2024@gmail.com.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '6. Cookies and Tracking',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We use cookies and similar technologies to enhance your experience on our platform. You can manage your preferences through your browser settings.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '7. Data Security',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We implement robust security measures, including encryption, firewalls, and secure servers, to protect your data. However, no system is 100% secure.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '8. Changes to This Policy',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We may update this policy from time to time. Any changes will be posted on this page with the updated effective date.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '9. Contact Us',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'If you have questions or concerns about this Privacy Policy, please contact us:',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Email: thegreatbulls2024@gmail.com',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            'Phone: [Insert Phone Number]',
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            'Address: Tharamangalam',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}