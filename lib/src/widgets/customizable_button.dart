import '../../import.dart';

class CustomizableButton extends StatelessWidget {
  final String title;
  final VoidCallback? event;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomizableButton(
      {required this.title,
      this.event,
      this.fontSize,
      this.fontWeight,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: cButtonGreen, // background
        foregroundColor: cButtonText, // foreground
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: event,
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }
}
