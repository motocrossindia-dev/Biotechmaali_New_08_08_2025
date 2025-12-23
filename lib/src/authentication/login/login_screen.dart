import 'dart:developer';
import '../../../import.dart';

class LoginScreen extends StatelessWidget {
  final String mobileNumber;
  const LoginScreen({required this.mobileNumber, super.key});

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
                        height: 62,
                        width: 120,
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
                      loginProvider.accountRegister(context, mobileNumber);
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
