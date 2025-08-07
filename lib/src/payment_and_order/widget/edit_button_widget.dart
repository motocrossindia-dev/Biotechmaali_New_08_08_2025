import '../../../import.dart';

class EditButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const EditButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(
          // side: const BorderSide(
          //   color: Color(0xFF7CB342), // Light green color
          //   width: 1.0,
          // ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15.0, right: 15, top: 5, bottom: 5),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF7CB342),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
