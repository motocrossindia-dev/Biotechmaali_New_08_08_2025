import '../../../import.dart';

class MobileNumberScreen extends StatelessWidget {
  const MobileNumberScreen({super.key});

  static const Color _primaryGreen = Color(0xFF3B5226);
  static const Color _darkGreen = Color(0xFF1B3012);
  static const Color _bgColor = Color(0xFFF9FBF7);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: _bgColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Consumer<MobileNumberProvider>(
          builder: (context, loginProvider, child) {
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Image.asset(
                        'assets/png/Gidan Logo.png',
                        height: 70,
                        width: 140,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: SvgPicture.asset(
                        'assets/svg/mobile_screen_pic.svg',
                        height: 200,
                        width: 200,
                      ),
                    ),
                    const SizedBox(height: 60),
                    Text(
                      'Welcome to\nGidan',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _darkGreen,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your journey towards a greener lifestyle begins here. Please enter your mobile number to get started.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Mobile Number Input
                    Text(
                      'Mobile Number',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _darkGreen,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: loginProvider.mobileNumber,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '00000 00000',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey.shade300,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 2,
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                          child: Text(
                            '+91',
                            style: GoogleFonts.poppins(
                              color: _primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.red, width: 1),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter mobile number';
                        } else if (value.length != 10) {
                          return 'Mobile number must be 10 digits';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.length == 10) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                    
                    loginProvider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: _primaryGreen),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                loginProvider.registerMobile(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryGreen,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'GET OTP',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'By continuing, you agree to our Terms & Privacy Policy',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
