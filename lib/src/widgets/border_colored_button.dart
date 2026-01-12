import '../../import.dart';

class BorderColoredButton extends StatelessWidget {
  final String title;
  final VoidCallback? event;
  final double height;
  const BorderColoredButton({
    required this.title,
    required this.event,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive font sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallPhone = screenWidth < 360;
    final isTablet = screenWidth > 600;

    // Calculate responsive font size based on button height and screen size
    double fontSize;
    if (isTablet) {
      fontSize = 14;
    } else if (isSmallPhone) {
      fontSize = 11; // Smaller font for small phones
    } else {
      fontSize = 12; // Default for normal phones
    }

    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cAppBackround,
          foregroundColor: cButtonGreen,
          padding: EdgeInsets.symmetric(
            horizontal: isSmallPhone ? 4 : 8,
            vertical: 0,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: cButtonGreen, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          // Ensure button doesn't expand unnecessarily
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: event,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.3, // Tighter letter spacing for compact text
            ),
          ),
        ),
      ),
    );
  }
}
