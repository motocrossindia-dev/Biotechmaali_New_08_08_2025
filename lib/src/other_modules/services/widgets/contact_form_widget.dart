import 'dart:developer';

import 'package:biotech_maali/src/other_modules/services/services_provider.dart';

import '../../../../import.dart';

class ContactFormSection extends StatefulWidget {
  const ContactFormSection({super.key});

  @override
  State<ContactFormSection> createState() => _ContactFormSectionState();
}

class _ContactFormSectionState extends State<ContactFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _locationController = TextEditingController();
  final _serviceController = TextEditingController();
  final _messageController = TextEditingController();

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    context.read<ServicesProvider>().getCurrentLocationAddress().then((value) {
      log("Location from shared preference: $value");
      _locationController.text = value;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ServicesProvider>();
      final success = await provider.submitForm(
        _nameController.text,
        _contactController.text,
        _locationController.text,
        _serviceController.text,
        _messageController.text,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted successfully!')),
        );
        _formKey.currentState!.reset();
        _nameController.clear();
        _contactController.clear();
        _locationController.clear();
        _serviceController.clear();
        _messageController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error.isEmpty
                ? 'Failed to submit form'
                : provider.error),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                const Text(
                  'Biotech Maali Service',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'assets/png/images/undraw_contact_us.png',
                  height: 150,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox(
                      height: 100,
                      child: Icon(Icons.error, color: Colors.grey[400]),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _validateField(value, 'Name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => _validateField(value, 'Contact number'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _validateField(value, 'Location'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _serviceController.text.isEmpty
                      ? null
                      : _serviceController.text,
                  decoration: const InputDecoration(
                    labelText: 'Service',
                    border: OutlineInputBorder(),
                  ),
                  items: context
                      .read<ServicesProvider>()
                      .serviceList
                      .map((String service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                  validator: (value) => _validateField(value, 'Service'),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _serviceController.text = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                  // validator: (value) => _validateField(value, 'Message'),
                ),
                const SizedBox(height: 24),
                Consumer<ServicesProvider>(
                  builder: (context, provider, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: CommonButtonWidget(
                        title: provider.isSubmitting ? 'SENDING...' : 'SEND',
                        event: provider.isSubmitting ? null : _submitForm,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _locationController.dispose();
    _serviceController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
