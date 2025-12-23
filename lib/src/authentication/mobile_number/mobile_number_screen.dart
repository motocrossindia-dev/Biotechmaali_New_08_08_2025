import '../../../import.dart';

class MobileNumberScreen extends StatelessWidget {
  const MobileNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Consumer<MobileNumberProvider>(
          builder: (context, loginProvider, child) {
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom +
                      24, // Padding for keyboard
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context)
                            .unfocus(); // Dismiss keyboard on tap
                      },
                      child: Center(
                        child: Column(
                          children: [
                            sizedBoxHeight70,
                            Image.asset(
                              'assets/png/Gidan Logo.png',
                              height: 62,
                              width: 120,
                            ),
                            const SizedBox(height: 50),
                            SvgPicture.asset(
                              'assets/svg/mobile_screen_pic.svg',
                              height: 240,
                              width: 210,
                            ),
                            sizedBoxHeight50,
                            sizedBoxHeight70,
                          ],
                        ),
                      ),
                    ),
                    CommonTextFormWidget(
                      controller: loginProvider.mobileNumber,
                      title: 'Enter Your Mobile Number',
                      hint: ' 8884981840',
                      inputType: TextInputType.number,
                      maxLenght: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter mobile number';
                        } else if (value.length != 10) {
                          return 'Mobile number must be 10 digits';
                        }
                        return null;
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      onChanged: (value) {
                        if (value.length == 10) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                    sizedBoxHeight25,
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30),
                      child: loginProvider.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: cButtonGreen,
                                color: cWhiteColor,
                              ),
                            )
                          : CommonButtonWidget(
                              title: 'GET OTP',
                              event: () {
                                if (formKey.currentState!.validate()) {
                                  loginProvider.registerMobile(context);
                                }
                              },
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
