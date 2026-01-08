import 'package:flutter/material.dart';

class RefundPolicyPage extends StatelessWidget {
  const RefundPolicyPage({super.key});

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
                  'Refund Policy',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Fair and Transparent Refund Guidelines',
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

          // Overview
          _buildSectionCard(
            title: 'Refund Policy Overview',
            content: 'At The Great Bulls, we strive to provide exceptional value through our AI-powered trading platform. Our refund policy is designed to balance customer satisfaction with the digital nature of our services. While we offer refunds in specific circumstances, we also recognize that trading education and tools require commitment from users.\n\nThis policy applies to all purchases including subscription plans, premium features, educational courses, and one-time service fees.',
          ),

          // Refund Eligibility
          _buildSectionCard(
            title: '1. Refund Eligibility',
            content: 'Refunds are available under the following specific conditions. All refund requests must be submitted within the applicable timeframe and meet our eligibility criteria.',
            subsections: [
              _buildSubsection(
                title: 'Technical Issues',
                content: '• Platform inaccessibility for more than 24 consecutive hours\n• Critical feature malfunction preventing core functionality\n• Account access issues not caused by user error\n• API integration failures affecting trading capabilities',
              ),
              _buildSubsection(
                title: 'Service Disruptions',
                content: '• Extended service outages (more than 48 hours in a month)\n• Data loss due to our system failures\n• Security breaches compromising user data\n• Major feature updates causing significant disruption',
              ),
              _buildSubsection(
                title: 'Billing Errors',
                content: '• Duplicate charges or incorrect amounts\n• Unauthorized subscription renewals\n• Currency conversion errors\n• Failed payment processing despite valid payment method',
              ),
              _buildSubsection(
                title: 'Account Issues',
                content: '• Unauthorized account access or changes\n• Data migration errors during account transfers\n• Subscription plan changes not initiated by user\n• Account suspension due to our error',
              ),
            ],
          ),

          // Non-Refundable Items
          _buildSectionCard(
            title: '2. Non-Refundable Services',
            content: 'The following services and situations are not eligible for refunds. These exclusions protect both users and our platform from misuse.',
            subsections: [
              _buildSubsection(
                title: 'Educational Content',
                content: '• Completed courses and webinars\n• Downloaded educational materials\n• One-on-one coaching sessions\n• Community access and discussions',
              ),
              _buildSubsection(
                title: 'Subscription Services',
                content: '• Used subscription periods (prorated refunds available)\n• Premium feature access after 7 days\n• AI prediction usage beyond trial limits\n• Advanced analytics and reporting tools',
              ),
              _buildSubsection(
                title: 'User-Initiated Actions',
                content: '• Change of mind or buyer\'s remorse\n• Dissatisfaction with trading results\n• Incompatibility with user expectations\n• Alternative service preferences',
              ),
              _buildSubsection(
                title: 'External Factors',
                content: '• Market volatility or trading losses\n• Changes in personal financial situation\n• Third-party service interruptions\n• Force majeure events (natural disasters, etc.)',
              ),
            ],
          ),

          // Refund Timeframes
          _buildSectionCard(
            title: '3. Refund Request Timeframes',
            content: 'Refund requests must be submitted within specific timeframes from the date of purchase or service activation. Late requests will not be considered.',
            subsections: [
              _buildSubsection(
                title: 'Immediate Refunds',
                content: '• Billing errors: Within 24 hours of charge\n• Account access issues: Within 48 hours of occurrence\n• Unauthorized charges: Within 7 days of discovery\n• Duplicate payments: Within 30 days of charge',
              ),
              _buildSubsection(
                title: 'Standard Refunds',
                content: '• Technical issues: Within 7 days of occurrence\n• Service disruptions: Within 14 days of incident\n• Feature malfunctions: Within 30 days of report\n• API integration issues: Within 14 days of connection',
              ),
              _buildSubsection(
                title: 'Extended Refunds',
                content: '• Security breaches: Within 90 days of incident\n• Data loss incidents: Within 60 days of occurrence\n• Major service outages: Within 30 days of resolution\n• Platform migration issues: Within 45 days of migration',
              ),
            ],
          ),

          // Refund Process
          _buildSectionCard(
            title: '4. Refund Request Process',
            content: 'All refund requests must follow our structured process to ensure fair and efficient resolution. We aim to process eligible refunds within 5-10 business days.',
            subsections: [
              _buildSubsection(
                title: 'Step 1: Contact Support',
                content: '• Email refund@thegreatbulls.com with detailed information\n• Include order number, account details, and refund reason\n• Provide screenshots or evidence supporting your claim\n• Specify preferred refund method (original payment or account credit)',
              ),
              _buildSubsection(
                title: 'Step 2: Review Process',
                content: '• Our team reviews the request within 2-3 business days\n• Additional information may be requested\n• Technical verification may be conducted\n• Decision communicated via email with detailed reasoning',
              ),
              _buildSubsection(
                title: 'Step 3: Refund Processing',
                content: '• Approved refunds processed within 5-10 business days\n• Refunds issued to original payment method\n• Account credits applied immediately\n• Confirmation email sent upon completion',
              ),
              _buildSubsection(
                title: 'Step 4: Appeals Process',
                content: '• Denied requests can be appealed within 14 days\n• Provide additional evidence or clarification\n• Appeals reviewed by senior management\n• Final decision communicated within 7 business days',
              ),
            ],
          ),

          // Refund Amounts
          _buildSectionCard(
            title: '5. Refund Amounts and Calculations',
            content: 'Refund amounts are calculated based on usage, time elapsed, and the nature of the service. We strive for fair and reasonable refund amounts.',
            subsections: [
              _buildSubsection(
                title: 'Full Refunds',
                content: '• Billing errors or duplicate charges: 100% refund\n• Service completely inaccessible: 100% refund\n• Account created but never accessed: 100% refund\n• Unauthorized account changes: 100% refund',
              ),
              _buildSubsection(
                title: 'Partial Refunds',
                content: '• Subscription services: Prorated based on unused time\n• Technical issues: 50-90% based on severity and duration\n• Service disruptions: Calculated based on downtime percentage\n• Feature limitations: Based on impact on overall service value',
              ),
              _buildSubsection(
                title: 'Processing Fees',
                content: '• Payment processing fees may be deducted\n• Currency conversion fees not refunded\n• Bank transfer fees may apply\n• Administrative fees for certain refund types',
              ),
            ],
          ),

          // Subscription Cancellations
          _buildSectionCard(
            title: '6. Subscription Cancellation and Refunds',
            content: 'Subscription services have specific cancellation and refund terms designed to balance user flexibility with service value.',
            subsections: [
              _buildSubsection(
                title: 'Cancellation Policy',
                content: '• Cancel anytime through account settings\n• No cancellation fees\n• Access continues until end of billing period\n• Auto-renewal can be disabled anytime',
              ),
              _buildSubsection(
                title: 'Refund Eligibility',
                content: '• First 7 days: Full refund available\n• 8-30 days: Prorated refund for unused time\n• After 30 days: No refund, but cancellation effective immediately\n• Annual plans: Refund available within 14 days',
              ),
              _buildSubsection(
                title: 'Special Circumstances',
                content: '• Medical emergencies: Case-by-case consideration\n• Extended service outages: Pro-rated refunds\n• Significant feature changes: Cancellation without penalty\n• Billing disputes: Immediate investigation and resolution',
              ),
            ],
          ),

          // Trial Periods
          _buildSectionCard(
            title: '7. Free Trials and Beta Access',
            content: 'Free trial periods and beta access have specific terms to ensure fair usage and evaluation.',
            subsections: [
              _buildSubsection(
                title: 'Trial Terms',
                content: '• Free trials are promotional and may be cancelled anytime\n• No charges during trial period\n• Automatic conversion to paid plan at trial end\n• Trial extensions available for technical issues',
              ),
              _buildSubsection(
                title: 'Beta Access',
                content: '• Beta features may have limited functionality\n• User feedback expected during beta period\n• No refunds for beta feature limitations\n• Early access privileges may be revoked for abuse',
              ),
            ],
          ),

          // Chargebacks
          _buildSectionCard(
            title: '8. Chargeback Policy',
            content: 'Chargebacks initiated through your bank or payment provider are treated differently from our refund process.',
            subsections: [
              _buildSubsection(
                title: 'Chargeback Process',
                content: '• Contact us before initiating chargeback\n• We will work to resolve the issue directly\n• Chargebacks may result in account suspension\n• Chargeback fees may be charged to your account',
              ),
              _buildSubsection(
                title: 'Consequences',
                content: '• Account may be permanently suspended\n• Future purchases may be declined\n• Legal action may be taken for fraudulent chargebacks\n• Restoration requires payment of chargeback fees',
              ),
            ],
          ),

          // International Refunds
          _buildSectionCard(
            title: '9. International and Currency Considerations',
            content: 'International users may face additional considerations for refunds due to currency conversion and banking regulations.',
            subsections: [
              _buildSubsection(
                title: 'Currency Conversion',
                content: '• Refunds processed in original currency where possible\n• Conversion fees may apply for international transfers\n• Exchange rate fluctuations may affect refund amount\n• Local banking fees not covered by us',
              ),
              _buildSubsection(
                title: 'International Banking',
                content: '• Processing time may be longer for international refunds\n• Some countries have restrictions on digital refunds\n• Additional verification may be required\n• Local tax implications may apply',
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
                  '10. Contact Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'For refund requests and inquiries:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 16),
                _ContactInfo(
                  icon: Icons.email,
                  label: 'Refund Support',
                  value: 'refund@thegreatbulls.com',
                ),
                _ContactInfo(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: '+91 [Your Phone Number]',
                ),
                _ContactInfo(
                  icon: Icons.access_time,
                  label: 'Response Time',
                  value: '2-3 business days for initial review',
                ),
                _ContactInfo(
                  icon: Icons.payment,
                  label: 'Processing Time',
                  value: '5-10 business days for approved refunds',
                ),
                SizedBox(height: 16),
                Text(
                  'Please include your order number and detailed reason for the refund request.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // Policy Updates
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
                  'Policy Updates',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'This refund policy may be updated to reflect changes in our services, payment processing, or legal requirements. Users will be notified of material changes via email or platform notifications. Continued use of our services after policy updates constitutes acceptance of the new terms.',
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