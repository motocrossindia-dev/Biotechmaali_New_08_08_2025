import '../../../../../import.dart';

class SeedWeightWidget extends StatelessWidget {
  final int id;
  final String name;
  final VoidCallback event;

  const SeedWeightWidget(
      {required this.id, required this.name, required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: event,
          child: Consumer<ProductDetailsProvider>(
            builder: (context, provider, child) {
              return Container(
                decoration: BoxDecoration(
                  color: provider.selectedWeightId == id
                      ? cButtonGreen
                      : Colors.white,
                  border: Border.all(
                      color: provider.selectedWeightId == id
                          ? cButtonGreen
                          : Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, right: 5, top: 5, bottom: 5),
                  child: CommonTextWidget(
                    title: name,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: provider.selectedWeightId == id
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
