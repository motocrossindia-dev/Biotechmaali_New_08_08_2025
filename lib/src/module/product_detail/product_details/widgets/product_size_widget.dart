import 'dart:developer';

import '../../../../../import.dart';

class ProductSizeWidget extends StatelessWidget {
  final int id;
  final String name;
  final VoidCallback event;

  const ProductSizeWidget(
      {required this.id, required this.name, required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    log("product size id : $id");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: event,
          child: Consumer<ProductDetailsProvider>(
            builder: (context, provider, child) {
              log("provider selected product sieze id : ${provider.selectedSizeId}");
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: provider.selectedSizeId == id
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
