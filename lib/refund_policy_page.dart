import 'package:flutter/material.dart';

class RefundPolicyPage extends StatelessWidget {
  const RefundPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Refund Policy',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Commitment to Purchase:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'All purchases are final. By purchasing our trading services, educational resources, and subscription plans, you agree that no refunds, partial or full, will be provided under any circumstances.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Product/Service Transparency:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We strive to provide clear and comprehensive information about our offerings. It is the responsibility of the buyer to review all details, terms, and conditions before completing the purchase.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Guarantee of Results:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Trading involves inherent risks, and past performance is not indicative of future results. Our trading services, educational resources, and subscription plans are designed to provide tools and information to aid in your trading journey, but success is not guaranteed.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Support and Assistance:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'If you encounter issues or have questions regarding our trading services, educational resources, and subscription plans, our support team is available to assist you.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Legal Compliance:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This policy is in compliance with applicable laws regarding digital goods and services. By completing your purchase, you acknowledge your understanding and agreement to this no-refund policy.',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}