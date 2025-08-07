import 'package:biotech_maali/src/other_modules/contact_us/contact_us_provider.dart';
import 'package:biotech_maali/src/other_modules/contact_us/model/cantact_us_model.dart';
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Contact'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB5B5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  children: [
                    Text(
                      "Let's Talk",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "We're Here",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF1A237E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Get In Touch',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Image.asset("assets/png/images/cantact_us.png"),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: const OutlineInputBorder(),
                        errorText: _getFieldError('name'),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contactController,
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        border: const OutlineInputBorder(),
                        errorText: _getFieldError('mobile'),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your contact number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: const OutlineInputBorder(),
                        errorText: _getFieldError('email'),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your email';
                        }
                        if (!_isValidEmail(value!)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        border: const OutlineInputBorder(),
                        errorText: _getFieldError('message'),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Consumer<ContactProvider>(
                      builder: (context, provider, child) {
                        if (provider.error != null) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              provider.error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Consumer<ContactProvider>(
                      builder: (context, provider, child) {
                        return CommonButtonWidget(
                          title: provider.isSubmitting
                              ? "SENDING..."
                              : "SEND MESSAGE",
                          event: provider.isSubmitting ? null : _submitForm,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Consumer<ContactProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: provider.contacts.map((contact) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          children: [
                            Text(
                              contact.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Contact Person - ${contact.contactPerson}'),
                            Text('Contact No - ${contact.contactNo}'),
                            Text('Email - ${contact.email}'),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Do Follow Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              sizedBoxHeight25,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      final Uri url =
                          Uri.parse('https://www.facebook.com/biotechmaali/');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Image.asset(
                      'assets/png/images/facebook_icon.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final Uri url = Uri.parse(
                          'https://www.instagram.com/biotechmaali/?hl=en');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Image.asset(
                      'assets/png/images/instagram.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final Uri url =
                          Uri.parse('https://www.youtube.com/@biotechmaali');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Image.asset(
                      'assets/png/images/youtube.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final Uri url = Uri.parse(
                          'https://www.linkedin.com/company/biotechmaali/?originalSubdomain=in');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Image.asset(
                      'assets/png/images/linkedin.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 24),
              Image.asset("assets/png/images/cantact_us_1.png"),
            ],
          ),
        ),
      ),
    );
  }
}
