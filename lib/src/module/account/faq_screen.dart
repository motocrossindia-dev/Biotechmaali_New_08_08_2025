import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/other_modules/contact_us/contact_us_screen.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How are the plants packaged for shipping?',
      'answer': 'We use eco-friendly, sturdy packaging designed to keep your plant safe and secure during transit. Each plant is carefully wrapped and supported to prevent movement or damage, ensuring it arrives in pristine condition.'
    },
    {
      'question': 'Will my plant look exactly like the picture?',
      'answer': 'While we do our best to match the product image, each plant is unique. Variations in size, shape, and color are natural. Rest assured, you’ll receive a healthy plant of the same species and quality.'
    },
    {
      'question': 'What if my plant arrives damaged?',
      'answer': 'If your plant arrives damaged, please contact us within 24 hours with photos of the package and plant. We’ll evaluate the issue immediately and offer a replacement or refund as appropriate.'
    },
    {
      'question': 'How do I care for my plant once it arrives?',
      'answer': 'Each plant comes with a basic care guide. You’ll also find detailed care instructions on our website under the product page. Our support team is also available for personalized advice.'
    },
    {
      'question': 'Do you ship all over India?',
      'answer': 'Yes, we ship to most pin codes across India. Delivery might depend on your specific location\'s courier service availability. You can check serviceability by entering your pin code on any product page.'
    },
    {
      'question': 'Can I cancel or modify my order?',
      'answer': 'Orders can be canceled or modified only before they are shipped. Please contact us immediately if you need to make changes. Once dispatched, modifications are unfortunately not possible.'
    },
    {
      'question': 'What types of plants do you sell?',
      'answer': 'We offer a wide variety of indoor plants, outdoor plants, succulents, flowering plants, and air-purifying plants. Each product listing includes details about ideal conditions and maintenance requirements.'
    },
    {
      'question': 'Can I gift plants to someone?',
      'answer': 'Absolutely! During checkout, you can mark your order as a gift and include a personalized message. We’ll ensure your gift is packed beautifully and delivered on time to your loved one.'
    },
  ];

  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('FAQ\'s'),
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
              child: Column(
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
                        const TextSpan(text: 'Help '),
                        TextSpan(
                          text: 'Center\nResources',
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
                    'Find answers to common questions about plant delivery, care, and more. We\'re here to help you grow your perfect garden environment.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FCF3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.eco_outlined, color: Color(0xFFA6C13C), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'General Questions',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B3012),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // FAQ List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: faqs.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      bool isExpanded = expandedIndex == index;
                      return Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          key: Key('faq_$index'),
                          initiallyExpanded: isExpanded,
                          onExpansionChanged: (expanded) {
                            setState(() {
                              expandedIndex = expanded ? index : null;
                            });
                          },
                          title: Text(
                            faqs[index]['question']!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w500,
                              color: isExpanded ? const Color(0xFFA6C13C) : Colors.black87,
                            ),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: isExpanded ? cButtonGreen : Colors.black26,
                              size: 20,
                            ),
                          ),
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFAFAFA),
                              ),
                              child: Text(
                                faqs[index]['answer']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),

                  // Still have questions Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Still have questions?',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'We\'re here to help you grow your perfect garden.',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B3012),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: Text(
                            'Contact Support',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
