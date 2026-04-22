import 'package:biotech_maali/src/payment_and_order/change_address/model/address_model.dart';

import '../../../import.dart';

class AddEditAddressScreen extends StatefulWidget {
  final AddressModel? address;
  final bool? isFromAccount;
  final bool isAddAddress;
  const AddEditAddressScreen(
      {this.address,
      this.isFromAccount,
      required this.isAddAddress,
      super.key});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch addresses when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF3B5226),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          'assets/png/Gidan Logo.png',
          height: 35,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Consumer<AddEditAddressProvider>(
              builder: (context, provider, child) {
            return Column(
              children: [
                // Premium Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B5226),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(text: widget.isAddAddress ? 'Add ' : 'Edit '),
                            TextSpan(
                              text: 'Address',
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
                        'Provide your details to ensure accurate and timely delivery.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('RECEIVER DETAILS'),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: provider.firstNameController,
                            hint: 'First Name',
                            validator: (v) => (v == null || v.isEmpty) ? 'Enter first name' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: provider.lastNameController,
                            hint: 'Last Name',
                            validator: (v) => (v == null || v.isEmpty) ? 'Enter last name' : null,
                          ),
                          
                          const SizedBox(height: 32),
                          _buildSectionTitle('ADDRESS DETAILS'),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: provider.addressController,
                            hint: 'Complete Address',
                            validator: (v) => (v == null || v.isEmpty) ? 'Enter address' : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: provider.cityController,
                                  hint: 'City',
                                  validator: (v) => (v == null || v.isEmpty) ? 'Enter city' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  controller: provider.stateController,
                                  hint: 'State',
                                  validator: (v) => (v == null || v.isEmpty) ? 'Enter state' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: provider.pincodeController,
                            hint: 'Pincode',
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            validator: (v) => (v == null || v.isEmpty || v.length != 6) ? 'Enter valid 6-digit pincode' : null,
                          ),

                          const SizedBox(height: 32),
                          _buildSectionTitle('ADDRESS TYPE'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildAddressTypeOption(
                                label: 'Home',
                                subtitle: 'All day delivery',
                                icon: Icons.home_outlined,
                                isSelected: provider.isHomeAddress,
                                onTap: () => provider.isHomeAddress ? null : provider.toggleIsHomeAddress(),
                              ),
                              const SizedBox(width: 16),
                              _buildAddressTypeOption(
                                label: 'Work',
                                subtitle: '9 AM - 6 PM',
                                icon: Icons.work_outline,
                                isSelected: !provider.isHomeAddress,
                                onTap: () => !provider.isHomeAddress ? null : provider.toggleIsHomeAddress(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      bottomSheet: Consumer<AddEditAddressProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      'CANCEL',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.isAddAddress) {
                          provider.addAddress(context);
                        } else {
                          provider.updateAddress(context, widget.address!.id);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3012),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: provider.isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(
                            widget.isAddAddress ? 'ADD ADDRESS' : 'UPDATE ADDRESS',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1B3012).withOpacity(0.5),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF3B5226), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildAddressTypeOption({
    required String label,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1B3012) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF1B3012) : Colors.grey.shade200,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: const Color(0xFF1B3012).withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.grey.shade600, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: isSelected ? Colors.white.withOpacity(0.7) : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
