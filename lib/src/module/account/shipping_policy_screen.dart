import 'package:biotech_maali/import.dart';
import 'package:url_launcher/url_launcher.dart';

class ShippingPolicyScreen extends StatelessWidget {
  const ShippingPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Shipping Policy'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cButtonGreen,
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.1,
                          ),
                          children: [
                            const TextSpan(text: 'Shipping & '),
                            TextSpan(
                              text: 'Delivery\nPromise',
                              style: GoogleFonts.poppins(
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFFA6C13C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ensuring your green companions reach you safely and swiftly across India. We partner with reputed courier agencies for a safe and timely delivery.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  // Delivery Promise Card
                  _buildSectionCard(
                    title: 'Delivery Promise',
                    content: 'Gidan ensures quality products and premium packaging. We have partnered with reputed courier agencies for a safe and timely delivery. ',
                    highlightedContent: 'Enjoy free shipping on orders above ₹2000.',
                  ),

                  const SizedBox(height: 32),

                  // Order Timelines
                  Row(
                    children: [
                      Icon(Icons.access_time, color: cButtonGreen, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Order Timelines',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimelineCard(
                          label: 'DISPATCH',
                          value: 'Within 1 Day',
                          subValue: 'FROM OUR SUSTAINABLE WAREHOUSE',
                          icon: Icons.warehouse_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTimelineCard(
                          label: 'DELIVERY',
                          value: '2-6 Work Days',
                          subValue: 'ACROSS MOST INDIAN PIN CODES',
                          icon: Icons.local_shipping_outlined,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Can you return plants?
                  _buildHeaderWithIcon(
                    icon: Icons.cancel_outlined,
                    iconColor: Colors.red,
                    title: 'Can you return plants?',
                    titleColor: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Gidan does not accept returns on plants as they may perish due to transit stress. However, we guarantee every plant will arrive at your doorstep in great condition.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF7A3030),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'If your plant arrives damaged, contact us within 24 hours with photos for a resolution.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.red.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Reviving your plant
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FCF3),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.sync, color: Color(0xFF8BA72E), size: 24),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Reviving your plant',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1F2C00),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Plants might look slightly dull due to transit stress. Exposure to indirect sunlight and proper watering will revive them to their natural healthy state within a few days.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF4C5D2C),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Non-Plant Products
                  _buildHeaderWithIcon(
                    icon: Icons.inventory_2_outlined,
                    iconColor: const Color(0xFFA6C13C),
                    title: 'Non-Plant Products',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            children: [
                              const TextSpan(text: 'Unused or unopened products can be returned or exchanged within '),
                              TextSpan(
                                text: '3 days of purchase.',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: cButtonGreen),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Simply reach out to our customer support team to initiate a return request for gardening supplies or accessories.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Assistance Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1B3012),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need Assistance?',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildContactItem(
                    icon: Icons.email_outlined,
                    label: 'EMAIL US',
                    value: 'support@gidan.store',
                  ),
                  const SizedBox(height: 20),
                  _buildContactItem(
                    icon: Icons.message_outlined,
                    label: 'WHATSAPP',
                    value: '+91 7483316150',
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined, color: Color(0xFFA6C13C), size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Return Address',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Farm Ammino Agritech Private Limited\n1st floor, 282/C, 10th Main Rd, 5th Block,\nJayanagar, Bengaluru, KA 560041',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String content, String? highlightedContent}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
                height: 1.6,
              ),
              children: [
                TextSpan(text: content),
                if (highlightedContent != null)
                  TextSpan(
                    text: highlightedContent,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFA6C13C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard({required String label, required String value, required String subValue, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Icon(icon, color: Colors.black.withOpacity(0.03), size: 60),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFA6C13C),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subValue,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderWithIcon({required IconData icon, required Color iconColor, required String title, Color? titleColor}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: titleColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({required IconData icon, required String label, required String value}) {
    return InkWell(
      onTap: () async {
        if (icon == Icons.message_outlined) {
          final Uri whatsappUri = Uri.parse("https://wa.me/917483316150");
          if (await canLaunchUrl(whatsappUri)) {
            await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
          }
        } else if (icon == Icons.email_outlined) {
          final Uri emailUri = Uri.parse("mailto:support@gidan.store");
          if (await canLaunchUrl(emailUri)) {
            await launchUrl(emailUri);
          }
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFA6C13C), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.4),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
