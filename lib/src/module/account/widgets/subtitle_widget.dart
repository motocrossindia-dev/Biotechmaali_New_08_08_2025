import '../../../../import.dart';

class SubtitleWidget extends StatelessWidget {
  final Function()? onPressedCallBack;
  final String title;

  const SubtitleWidget(
      {this.onPressedCallBack, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressedCallBack,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              sizedBoxWidth25,
              sizedBoxWidth20,
              CommonTextWidget(
                title: title,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          Icon(
            Icons.chevron_right,
            size: 30,
            color: cAccountText,
          )
        ],
      ),
    );
  }
}
