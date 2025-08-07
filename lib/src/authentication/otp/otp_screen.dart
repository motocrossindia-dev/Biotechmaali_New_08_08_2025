import 'package:shimmer/shimmer.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              sizedBoxHeight70,
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/png/biotech_logo.png',
                      height: 62,
                      width: 120,
                    ),
                    sizedBoxHeight50,
                    SvgPicture.asset(
                      'assets/svg/otp_screen_pic.svg',
                      height: 240,
                      width: 210,
                    ),
                  ],
                ),
              ),
              sizedBoxHeight50,
              const CommonTextWidget(
                title: 'Verification',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              const CommonTextWidget(
                title: 'Enter verification code',
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
              sizedBoxHeight25,
              const PinputWidget(),
              sizedBoxHeight25,
              Consumer<OtpProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: const CommonButtonWidget(
                          title: 'NEXT',
                          event: null,
                        ),
                      ),
                    );
                  }

                  if (provider.errorMessage.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(provider.errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                  }
                  return sizedBoxHeight0;

                  // return Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 30),
                  //   child: CommonButtonWidget(
                  //     title: 'NEXT',
                  //     event: () async {
                  //       await provider.validateOtp(mobile, context);
                  //     },
                  //   ),
                  // );
                },
              ),
              sizedBoxHeight05,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonTextWidget(
                    title: "Didn't receive the verification OTP?",
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: cBorderGrey,
                  ),
                  sizedBoxWidth10,
                  InkWell(
                    onTap: () {
                      context
                          .read<MobileNumberProvider>()
                          .registerMobile(context);
                    },
                    child: CommonTextWidget(
                      title: 'RESEND OTP',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: cCustomRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
