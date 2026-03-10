import 'dart:developer';
import 'package:biotech_maali/core/services/analytics_service.dart';
import 'package:biotech_maali/core/services/analytics_helper.dart';
import '../../../import.dart';

class LoginScreen extends StatefulWidget {
  final String mobileNumber;
  const LoginScreen({required this.mobileNumber, super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    // Track login screen view
    AnalyticsService().logScreenView(screenName: ScreenNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.read<LoginProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      sizedBoxHeight50,
                      Image.asset(
                        'assets/png/Gidan Logo.png',
                        height: 90,
                        width: 180,
                      ),
                      sizedBoxHeight40,
                      SvgPicture.asset(
                        'assets/svg/login_image.svg',
                        height: 240,
                        width: 210,
                      ),
                    ],
                  ),
                ),
                sizedBoxHeight15,
                CommonTextFormWidget(
                  controller: loginProvider.name,
                  title: 'Enter Your Name',
                  hint: ' Name is required',
                  inputType: TextInputType.text,
                ),
                // sizedBoxHeight25,
                // CommonTextFormWidget(
                //   controller: loginProvider.emailId,
                //   title: 'Enter Email Address (optional)',
                //   hint: ' Email Address',
                //   inputType: TextInputType.text,
                // ),
                sizedBoxHeight25,
                CommonTextFormWidget(
                  controller: loginProvider.referralCode,
                  title: 'Enter The Referral Code(optional)',
                  hint: ' Referral code',
                  inputType: TextInputType.text,
                ),
                sizedBoxHeight25,
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: CommonButtonWidget(
                    title: 'LOGIN',
                    event: () {
                      loginProvider.accountRegister(
                          context, widget.mobileNumber);
                      log('message');
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
