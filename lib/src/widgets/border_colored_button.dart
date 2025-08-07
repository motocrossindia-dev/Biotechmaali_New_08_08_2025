import '../../import.dart';

class BorderColoredButton extends StatelessWidget {
  final String title;
  final VoidCallback? event;
  final double height;
  const BorderColoredButton({required this.title, required this.event,required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cAppBackround,

          foregroundColor: cButtonGreen, // foreground

          shape: RoundedRectangleBorder(
            side: BorderSide(color: cButtonGreen, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: event,
        child: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
