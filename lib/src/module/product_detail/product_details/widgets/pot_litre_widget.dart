import '../../../../../import.dart';

class PotLitreWidget extends StatelessWidget {
  final int id;
  final String name;
  final VoidCallback event;

  const PotLitreWidget(
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
                    color: provider.selectedLitreId == id
                        ? cButtonGreen
                        : Colors.white,
                    border: Border.all(
                        color: provider.selectedLitreId == id
                            ? cButtonGreen
                            : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(6)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, top: 10, bottom: 10),
                  child: CommonTextWidget(
                    title: name,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: provider.selectedLitreId == id
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
