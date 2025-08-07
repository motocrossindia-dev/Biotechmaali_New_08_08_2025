import '../../import.dart';

class CommonButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback? event;
  final double? fontsize;
  const CommonButtonWidget(
      {required this.title, this.event, this.fontsize, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cButtonGreen, // background
          foregroundColor: cButtonText, // foreground
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: event,
        child: Text(
          title,
          style: GoogleFonts.poppins(fontSize: fontsize, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
