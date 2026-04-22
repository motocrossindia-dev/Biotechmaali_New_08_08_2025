import '../../../import.dart';

class OtpScreen extends StatelessWidget {
  final String mobile;

  const OtpScreen({
    super.key,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpProvider(),
      child: _OtpScreenContent(mobile: mobile),
    );
  }
}

class _OtpScreenContent extends StatelessWidget {
  final String mobile;

  const _OtpScreenContent({required this.mobile});

  static const Color _primaryGreen = Color(0xFF3B5226);
  static const Color _darkGreen = Color(0xFF1B3012);
  static const Color _bgColor = Color(0xFFF9FBF7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _darkGreen, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/png/Gidan Logo.png',
                      height: 70,
                      width: 140,
                    ),
                    const SizedBox(height: 40),
                    SvgPicture.asset(
                      'assets/svg/otp_screen_pic.svg',
                      height: 200,
                      width: 200,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Text(
                'Verification',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _darkGreen,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'We have sent a 4-digit verification code to '),
                    TextSpan(
                      text: '+91 $mobile',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _darkGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              const Center(child: PinputWidget()),
              
              const SizedBox(height: 40),
              
              Consumer<OtpProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: _primaryGreen),
                    );
                  }

                  if (provider.errorMessage.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(provider.errorMessage, style: GoogleFonts.poppins(fontSize: 13)),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                      provider.clearError(); // Custom method to clear error so it doesn't repeat
                    });
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              Center(
                child: Column(
                  children: [
                    Text(
                      "Didn't receive the code?",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        context.read<MobileNumberProvider>().registerMobile(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('OTP Resent Successfully', style: GoogleFonts.poppins()),
                            backgroundColor: _primaryGreen,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Text(
                        'RESEND OTP',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _primaryGreen,
                          letterSpacing: 1,
                          decoration: TextDecoration.underline,
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
      ),
    );
  }
}
