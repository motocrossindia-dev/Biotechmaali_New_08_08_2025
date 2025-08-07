import '../../../../import.dart';

class FilterCategoryItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterCategoryItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,  // Align to top for multi-line text
          children: [
            if (isSelected)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: cButtonGreen,
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.only(right: 8, top: 4),  // Added top margin
              ),
            if (!isSelected)
              sizedBoxWidth15,
            Expanded(  // Added Expanded
              child: CommonTextWidget(
               title:   title,
               color: isSelected ? cButtonGreen : Colors.black87,
               fontSize: 15,
               fontWeight:isSelected ? FontWeight.w600 : FontWeight.normal,
               
              ),
            ),
          ],
        ),
      ),
    );
  }
}