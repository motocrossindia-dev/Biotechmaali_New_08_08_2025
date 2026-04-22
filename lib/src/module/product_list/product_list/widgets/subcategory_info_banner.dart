import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/explore/model/subcategory_model.dart';
import 'package:google_fonts/google_fonts.dart';

class SubcategoryInfoBanner extends StatelessWidget {
  final Subcategory subcategory;

  const SubcategoryInfoBanner({required this.subcategory, super.key});

  @override
  Widget build(BuildContext context) {
    final info = subcategory.subCategoryInfo;
    if (info == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              children: [
                if (info.headingBefore.isNotEmpty)
                  TextSpan(text: '${info.headingBefore} '),
                if (info.italicText.isNotEmpty)
                  TextSpan(
                    text: '${info.italicText} ',
                    style: GoogleFonts.poppins(
                      fontStyle: FontStyle.italic,
                      color: cButtonGreen,
                    ),
                  ),
                if (info.headingAfter.isNotEmpty)
                  TextSpan(text: info.headingAfter),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Description
          if (info.description.isNotEmpty)
            Text(
              info.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          
          // Tags
          if (info.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: info.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: cButtonGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cButtonGreen.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline, size: 14, color: cButtonGreen),
                      const SizedBox(width: 4),
                      Text(
                        tag,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: cButtonGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          
          // Stats Row
          if (info.stats.isNotEmpty) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: info.stats.map((stat) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${stat.label} ',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      stat.number,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Divider(),
          ],
        ],
      ),
    );
  }
}
