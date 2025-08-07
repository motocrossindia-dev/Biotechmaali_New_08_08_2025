import '../../../../../import.dart';

class SuccessPopupDelete extends StatelessWidget {
  const SuccessPopupDelete({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.blue,
            size: 60,
          ),
          SizedBox(height: 16),
          CommonTextWidget(
            title: "The Account Is Deleted Successfully",
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}