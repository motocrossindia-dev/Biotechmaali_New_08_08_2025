import 'package:biotech_maali/src/other_modules/contact_us/contact_us_provider.dart';
import 'package:biotech_maali/src/other_modules/contact_us/model/cantact_us_model.dart';
import 'package:biotech_maali/src/other_modules/franchise_enquiry/franchise_enquiry_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../import.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String? _getFieldError(String fieldName) {
    final provider = context.read<ContactProvider>();
    final errors = provider.fieldErrors[fieldName];
    return errors?.isNotEmpty == true ? errors!.first : null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final inquiry = ContactInquiry(
        name: _nameController.text,
        contactNumber: _contactController.text,
        email: _emailController.text,
        message: _messageController.text,
      );

      final success =
          await context.read<ContactProvider>().submitInquiry(inquiry);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Message sent successfully!'
                  : context.read<ContactProvider>().error ??
                      'Failed to send message',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          _formKey.currentState?.reset();
          _nameController.clear();
          _contactController.clear();
          _emailController.clear();
          _messageController.clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Contact Us'),
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
              decoration: const BoxDecoration(
                color: Color(0xFF3B5226),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.1,
                      ),
                      children: [
                        const TextSpan(text: "Let's "),
                        TextSpan(
                          text: 'Talk\nGardening',
                          style: GoogleFonts.playfairDisplay(
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFFA6C13C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Have a question? We\'re here to help your garden thrive. Whether you\'re a beginner or an expert, our team is just a message away.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Intro Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B3012),
                      ),
                      children: [
                        const TextSpan(text: "We're just a "),
                        TextSpan(
                          text: 'message away.',
                          style: GoogleFonts.playfairDisplay(
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFFA6C13C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Whether you\'re looking for plant care advice, tracking an order, or exploring business opportunities, our team is ready to assist.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Contact Info Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildContactInfoCard(
                      icon: Icons.location_on_outlined,
                      title: 'Head Office',
                      address: 'Jayanagar, Bengaluru, KA',
                      phone: '+91 7483316150',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildContactInfoCard(
                      icon: Icons.language_outlined,
                      title: 'Nursery Store',
                      address: 'Kanakapura Road, Bengaluru',
                      phone: '+91 8971710854',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Message Form Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send a Message',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1B3012),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Expected response time: within 24 hours.',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.black26,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormTextField(
                        'Full Name',
                        _nameController,
                        Icons.person_outline,
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormTextField(
                              'Phone Number',
                              _contactController,
                              Icons.phone_android_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFormTextField(
                              'Email Address',
                              _emailController,
                              Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) =>
                                  !_isValidEmail(v ?? '') ? 'Invalid' : null,
                            ),
                          ),
                        ],
                      ),
                      _buildFormTextField(
                        'How can we help?',
                        _messageController,
                        Icons.chat_bubble_outline,
                        maxLines: 4,
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Consumer<ContactProvider>(
                        builder: (context, provider, child) {
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              onPressed:
                                  provider.isSubmitting ? null : _submitForm,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFFF1F8E9),
                                foregroundColor: const Color(0xFF1B3012),
                                side:
                                    const BorderSide(color: Color(0xFF8BC34A)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: provider.isSubmitting
                                  ? const CircularProgressIndicator(
                                      color: Color(0xFF1B3012))
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'SEND MESSAGE',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(Icons.send_outlined,
                                            size: 18),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Partnering Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFA6C13C),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interested in Partnering?',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B3012),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Request a free Franchise Consultation and join India\'s fastest growing gardening brand.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF1B3012).withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FranchiseScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B3012),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'APPLY FOR FRANCHISE',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Social Section
            Column(
              children: [
                Text(
                  'Do Follow Us',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B3012),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon('assets/png/images/facebook_icon.png',
                        'https://www.facebook.com/biotechmaali/'),
                    _buildSocialIcon('assets/png/images/instagram.png',
                        'https://www.instagram.com/biotechmaali/?hl=en'),
                    _buildSocialIcon('assets/png/images/youtube.png',
                        'https://www.youtube.com/@biotechmaali'),
                    _buildSocialIcon('assets/png/images/linkedin.png',
                        'https://www.linkedin.com/company/biotechmaali/?originalSubdomain=in'),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Image.asset(
            //   "assets/png/images/cantact_us_1.png",
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoCard({
    required IconData icon,
    required String title,
    required String address,
    required String phone,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8E9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF3B5226), size: 18),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B3012),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.black26,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            phone,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B3012),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        style: GoogleFonts.poppins(fontSize: 13),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.black26),
          prefixIcon: Icon(icon, size: 18, color: Colors.black26),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String asset, String url) {
    return InkWell(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          shape: BoxShape.circle,
        ),
        child: Image.asset(asset, height: 24, width: 24),
      ),
    );
  }
}
