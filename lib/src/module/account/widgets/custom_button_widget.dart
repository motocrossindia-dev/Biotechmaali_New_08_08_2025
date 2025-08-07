import '../../../../import.dart';

class CustomButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressedCallBack;
  const CustomButtonWidget({required this.onPressedCallBack,required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressedCallBack,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: cAccountContainerGrey,
          border: Border(bottom: BorderSide(color: cAccountText)),
        ),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: CommonTextWidget(
                title: title,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
