import '../../../../../import.dart';

class PlanterSizeWidget extends StatelessWidget {
  final int id;
  final String name;
  final VoidCallback event;

  const PlanterSizeWidget(
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
                    border: Border.all(
                        color: provider.selectedPlanterSizeId == id
                            ? Colors.green
                            : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(6)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, top: 10, bottom: 10),
                  child: CommonTextWidget(
                    title: name,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
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
