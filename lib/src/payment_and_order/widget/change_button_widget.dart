import '../../../import.dart';

class ChangeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double width;
  final double height;

  const ChangeButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width = 70, // Default width
    this.height = 30, // Default height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF7CB342), // Light green color
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child:  Text(
          title,
          style: const TextStyle(
            color: Color(0xFF7CB342),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
