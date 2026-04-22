import 'package:biotech_maali/src/module/account/edit_profile/edit_profile_shimmer.dart';

import '../../../../../import.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  final bool? isPlaceOrder;
  const EditProfileScreen({this.isPlaceOrder, super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditProfileProvider>().fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final editProfileProvider = context.watch<EditProfileProvider>();

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
        actions: [
          IconButton(
            icon: Icon(
              editProfileProvider.isEditing ? Icons.close : Icons.edit_outlined,
              color: Colors.white,
            ),
            onPressed: () => editProfileProvider.toggleEditMode(),
          ),
          const SizedBox(width: 8),
        ],
        title: Image.asset(
          'assets/png/Gidan Logo.png',
          height: 35,
          color: Colors.white,
        ),
      ),
      body: editProfileProvider.isLoading
          ? const Center(child: EditProfileShimmer())
          : SingleChildScrollView(
              child: Column(
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
                              const TextSpan(text: 'My '),
                              TextSpan(
                                text: 'Profile',
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
                          'Keep your information up to date to enjoy a personalized experience.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('PERSONAL DETAILS'),
                        const SizedBox(height: 16),
                        EditProfileTextForm(
                          controller: editProfileProvider.firstName,
                          hintText: 'First Name',
                          labelText: 'First Name',
                          readOnly: !editProfileProvider.isEditing,
                        ),
                        const SizedBox(height: 20),
                        EditProfileTextForm(
                          controller: editProfileProvider.lastName,
                          hintText: 'Last Name',
                          labelText: 'Last Name',
                          readOnly: !editProfileProvider.isEditing,
                        ),
                        const SizedBox(height: 24),
                        
                        _buildSectionTitle('GENDER'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildGenderOption(
                              label: 'Male',
                              value: 'Male',
                              provider: editProfileProvider,
                            ),
                            _buildGenderOption(
                              label: 'Female',
                              value: 'Female',
                              provider: editProfileProvider,
                            ),
                            _buildGenderOption(
                              label: 'Others',
                              value: 'Others',
                              provider: editProfileProvider,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        _buildSectionTitle('CONTACT INFORMATION'),
                        const SizedBox(height: 16),
                        EditProfileTextForm(
                          controller: editProfileProvider.emailAddress,
                          hintText: 'Email Address',
                          labelText: 'Email Address *',
                          keyboardType: TextInputType.emailAddress,
                          readOnly: !editProfileProvider.isEditing,
                        ),
                        const SizedBox(height: 20),
                        EditProfileTextForm(
                          controller: editProfileProvider.mobileNumber,
                          hintText: 'Mobile Number',
                          labelText: 'Mobile Number',
                          keyboardType: TextInputType.phone,
                          readOnly: true, // Always read-only as per original logic
                        ),
                        const SizedBox(height: 32),

                        _buildSectionTitle('ADDITIONAL INFO'),
                        const SizedBox(height: 16),
                        EditProfileTextForm(
                          controller: editProfileProvider.dateOfBirth,
                          hintText: 'Date of Birth',
                          labelText: 'Date of Birth',
                          onTap: editProfileProvider.isEditing
                              ? () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: editProfileProvider.dateOfBirth.text.isNotEmpty
                                        ? DateTime.parse(editProfileProvider.dateOfBirth.text)
                                        : DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    editProfileProvider.dateOfBirth.text =
                                        DateFormat('yyyy-MM-dd').format(picked);
                                  }
                                }
                              : null,
                          readOnly: !editProfileProvider.isEditing,
                        ),
                        const SizedBox(height: 20),
                        EditProfileTextForm(
                          controller: editProfileProvider.gstNumber,
                          hintText: 'GST Number',
                          labelText: 'GST Number',
                          keyboardType: TextInputType.text,
                          readOnly: !editProfileProvider.isEditing,
                          maxLength: 15,
                        ),

                        if (editProfileProvider.isEditing) ...[
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B3012),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                final success = await editProfileProvider.updateProfile(
                                    widget.isPlaceOrder, context);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Profile Updated Successfully')),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                'SAVE CHANGES',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 40),
                        const Divider(),
                        const SizedBox(height: 24),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DeleteAccountScreen(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'DELETE ACCOUNT',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1.1,
                              ),
                            ),
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

  Widget _buildGenderOption({
    required String label,
    required String value,
    required EditProfileProvider provider,
  }) {
    final isSelected = provider.selectedGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: provider.isEditing ? () => provider.selectGender(value) : null,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1B3012) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF1B3012) : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
