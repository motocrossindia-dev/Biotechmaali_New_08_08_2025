import 'dart:developer';
import 'package:pinput/pinput.dart';
import '../../../../import.dart';

class PinputWidget extends StatefulWidget {
  const PinputWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PinputWidgetState createState() => _PinputWidgetState();
}

class _PinputWidgetState extends State<PinputWidget> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusedBorderColor = cBorderGrey;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    final borderColor = cButtonGreen;

    final defaultPinTheme = PinTheme(
      width: 44,
      height: 44,
      textStyle: const TextStyle(
        fontSize: 18,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
    );

    return Consumer<OtpProvider>(
      builder: (context, provider, child) {
        return Pinput(
          length: 4,
          controller: pinController,
          focusNode: focusNode,
          // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
          // listenForMultipleSmsOnAndroid: true,
          defaultPinTheme: defaultPinTheme,
          separatorBuilder: (index) => const SizedBox(width: 15),
          validator: (value) {
            return value?.length == 4 ? null : 'Pin must be 4 digits';
          },
          onCompleted: (pin) {
            log("Completed: $pin");
            provider.setOtp(pin);
          },
          onChanged: (value) {
            log("Changed: $value");
            if (value.length == 4) {
              provider.setOtp(value);
              FocusScope.of(context).unfocus();
              provider.validateOtp(
                context.read<MobileNumberProvider>().mobileNumber.text.trim(),
                context,
              );
            }
          },
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                width: 22,
                height: 1,
                color: focusedBorderColor,
              ),
            ],
          ),
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: focusedBorderColor),
            ),
          ),
          submittedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              color: fillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: focusedBorderColor),
            ),
          ),
          errorPinTheme: defaultPinTheme.copyBorderWith(
            border: Border.all(color: Colors.redAccent),
          ),
          enabled: !provider.isLoading, // Disable input while loading
        );
      },
    );
  }
}
