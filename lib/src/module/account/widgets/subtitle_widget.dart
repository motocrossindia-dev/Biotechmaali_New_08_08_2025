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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 45), // Matching the indentation of the main icons
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.black26,
            )
          ],
        ),
      ),
    );
  }
}
