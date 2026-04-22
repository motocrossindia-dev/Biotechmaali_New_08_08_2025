import 'package:biotech_maali/src/other_modules/franchise_enquiry/franchise_enquiry_provider.dart';
import 'package:biotech_maali/src/other_modules/our_store/our_store_provider.dart';
import 'package:biotech_maali/src/other_modules/our_store/our_store_screen.dart';
import '../../../import.dart';

class FranchiseScreen extends StatelessWidget {
  FranchiseScreen({super.key});

  // Form validation helper methods
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contact number is required';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit contact number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validateArea(String? value) {
    if (value == null || value.isEmpty) {
      return 'Area is required';
    }
    if (value.length < 5) {
      return 'Please provide more details about the area';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    if (value.length < 10) {
      return 'Please provide a complete address';
    }
    return null;
  }

  String? validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Message is required';
    }
    return null;
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Franchise Enquiry'),
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
                        const TextSpan(text: 'Grow with '),
                        TextSpan(
                          text: 'Gidan',
                          style: GoogleFonts.playfairDisplay(
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFFA6C13C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Join our network of sustainable gardening partners and cultivate success.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(height: 100, color: const Color(0xFF3B5226)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Consumer<FranchiseProvider>(
                      builder: (context, provider, child) {
                        return Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PARTNER REGISTRATION',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFA6C13C),
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1B3012),
                                  ),
                                  children: [
                                    const TextSpan(text: 'Get a '),
                                    TextSpan(
                                      text: 'Franchise',
                                      style: GoogleFonts.playfairDisplay(
                                        fontStyle: FontStyle.italic,
                                        color: const Color(0xFFA6C13C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Share your details and our team will get back to you with the next steps.',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildNewTextField(
                                      'Full Name',
                                      provider.name,
                                      Icons.person_outline,
                                      validator: validateName,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildNewTextField(
                                      'Contact Number',
                                      provider.contact,
                                      Icons.phone_outlined,
                                      validator: validateContact,
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ],
                              ),
                              _buildNewTextField(
                                'Email Address',
                                provider.email,
                                Icons.email_outlined,
                                validator: validateEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildNewTextField(
                                      'Desired Area',
                                      provider.area,
                                      Icons.corporate_fare_outlined,
                                      validator: validateArea,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildNewTextField(
                                      'Current Address',
                                      provider.address,
                                      Icons.map_outlined,
                                      validator: validateAddress,
                                    ),
                                  ),
                                ],
                              ),
                              _buildNewTextField(
                                'Tell us about your interest...',
                                provider.message,
                                Icons.chat_bubble_outline,
                                maxLines: 4,
                                validator: validateMessage,
                              ),
                              const SizedBox(height: 24),
                              if (provider.error != null) ...[
                                Text(
                                  provider.error!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                              ],
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: provider.isLoading
                                      ? null
                                      : () {
                                          if (formKey.currentState!.validate()) {
                                            provider.submitForm(context);
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1B3012),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: provider.isLoading
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Request Call-back',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Icon(Icons.send_outlined, size: 20),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Why We Rock? Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'OUR PHILOSOPHY',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFA6C13C),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1B3012),
                      ),
                      children: [
                        const TextSpan(text: 'Why We '),
                        TextSpan(
                          text: 'Rock?',
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
                    'Gidan is India\'s newest destination for thoughtfully curated garden products, plants, planters, and supplies. Built with a deep respect for nature and a strong commitment to education-driven gardening, we represent a community of plant lovers, growers, and cultivators across homes, farms, and agricultural ecosystems.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            _buildStoreLocationsSection(),

            // Store Cards
            Consumer<OurStoreProvider>(
              builder: (context, storeProvider, child) {
                if (storeProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (storeProvider.stores.isEmpty) {
                  return const SizedBox();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: storeProvider.stores.length.clamp(0, 2), // Show only first 2
                  itemBuilder: (context, index) {
                    return StoreCard(store: storeProvider.stores[index]);
                  },
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OurStoresScreen(),
                      ),
                    );
                  },
                  icon: const Text('View All Stores'),
                  label: const Icon(Icons.arrow_forward),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1B3012),
                    side: const BorderSide(color: Color(0xFF1B3012)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildNewTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.black26),
          prefixIcon: Icon(icon, size: 20, color: Colors.black26),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Consumer<FranchiseProvider>(
        builder: (context, provider, _) {
          return TextFormField(
            maxLines: maxLines,
            maxLength: maxLength,
            keyboardType: keyboardType,
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF8BC34A)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: validator,
          );
        },
      ),
    );
  }

  Widget _buildWhyWeRockSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonTextWidget(
            title: 'Why We Rock?',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          const CommonTextWidget(
              title:
                  'Take the first step and become a part of the family that is ever-growing. Partner with the Most Trusted Plant Nursery in the market. The vision of Gidan franchise is to deliver our unique cultural blend and values to each corner of this world.',
              fontSize: 16),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/png/images/franchise_pic_3.png',
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreLocationsSection() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: CommonTextWidget(
        title: 'Check Out Our Stores',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  List<Widget> _buildFeatureItems() {
    final features = [
      {
        'title': 'Target Audience',
        'icon': Icons.group_outlined,
        'description':
            'We are a major attraction for youths who are spending more than 5,00,000 minutes in our outlets. In the coming years, we are targeting to reach more cities and to serve more people.',
      },
      {
        'title': 'Prominence',
        'icon': Icons.star_outline,
        'description':
            'We are a major attraction for youths who are spending more than 5,00,000 minutes in our outlets. In the coming years, we are targeting to reach more cities and to serve more people.',
      },
      {
        'title': 'Fresh Concept',
        'icon': Icons.local_florist_outlined,
        'description':
            'We are a major attraction for youths who are spending more than 5,00,000 minutes in our outlets. In the coming years, we are targeting to reach more cities and to serve more people.',
      },
      {
        'title': 'Brand Value',
        'icon': Icons.trending_up_outlined,
        'description':
            'We are a major attraction for youths who are spending more than 5,00,000 minutes in our outlets. In the coming years, we are targeting to reach more cities and to serve more people.',
      },
    ];

    return features
        .map(
          (feature) => Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    size: 24,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(
                        title: feature['title'] as String,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feature['description'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  // List<Widget> _buildStoreCards() {
  //   return [
  //     _buildStoreCard('Bangalore', 'ELECTRONICS CITY Ph Gate'),
  //     _buildStoreCard('Bangalore', 'ELECTRONICS CITY Ph Gate'),
  //   ];
  // }

  // Widget _buildStoreCard(String city, String location) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: const Color(0xFF8BC34A)),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 city,
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const Icon(Icons.location_on_outlined,
  //                   color: Color(0xFF8BC34A)),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           Text(location),
  //           const Text('Contact Number: 9999999999'),
  //           const Text('Time: 9am to 9pm'),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
