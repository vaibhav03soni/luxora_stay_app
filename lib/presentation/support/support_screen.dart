import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How can we help you?', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildSupportCard(context, Icons.chat_bubble_outline, 'Live Chat', 'Average wait: 2 mins', () {})),
                const SizedBox(width: 16),
                Expanded(child: _buildSupportCard(context, Icons.phone_in_talk_outlined, 'Call Us', '24/7 Support line', () {})),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildSupportCard(context, Icons.email_outlined, 'Email', 'Get a reply in 24h', () {})),
                const SizedBox(width: 16),
                Expanded(child: _buildSupportCard(context, Icons.description, 'Help Center', 'Read our guides', () {})),
              ],
            ),
            const SizedBox(height: 40),
            const Text('Frequently Asked Questions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildFaqItem('How do I cancel my booking?', 'You can cancel your booking from the "My Trips" section. Simply select the booking you wish to cancel and tap the "Cancel Booking" button.'),
            _buildFaqItem('When will I receive my refund?', 'Refunds are typically processed within 5-7 business days of cancellation, depending on your bank and the hotel\'s refund policy.'),
            _buildFaqItem('Can I change my check-in date?', 'Yes, date changes are possible but depend on availability and may incur additional charges. Please contact our support team for assistance.'),
            _buildFaqItem('Are pets allowed in all hotels?', 'Pet policies vary by property. You can filter hotels by "Pet Friendly" in the search filters or check the "Amenities" section on the hotel details page.'),
            _buildFaqItem('How do I apply a coupon code?', 'You can enter your coupon code on the booking review screen before proceeding to payment.'),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Luxora Stay Version 1.0.0',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: const TextStyle(color: Colors.grey, height: 1.5, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
