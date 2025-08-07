import 'package:biotech_maali/src/payment_and_order/change_address/change_address_provider.dart';
import 'package:biotech_maali/src/payment_and_order/widget/edit_button_widget.dart';
import '../../../../import.dart';
import '../model/address_model.dart';

class AddressTileWidget extends StatelessWidget {
  final AddressModel address;

  const AddressTileWidget({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CommonTextWidget(title: 'Deliver to:', color: Colors.grey),
            Row(
              children: [
                !address.isDefault
                    ? IconButton(
                        onPressed: () {
                          context
                              .read<ChangeAddressProvider>()
                              .deleteAddress(address.id);
                        },
                        icon: const Icon(Icons.delete),
                      )
                    : const SizedBox(),
                EditButtonWidget(
                  title: 'Edit',
                  onPressed: () {
                    context.read<AddEditAddressProvider>().setEditData(address);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditAddressScreen(
                            isAddAddress: false, address: address),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
        Row(
          children: [
            CommonTextWidget(
              title: '${address.firstName} ${address.lastName}',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            sizedBoxWidth5,
            Container(
              decoration: BoxDecoration(
                  color: cLightGreyHomeWork,
                  borderRadius: BorderRadius.circular(2)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CommonTextWidget(
                  title: address.addressType,
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
        CommonTextWidget(
            title: '${address.address}\n${address.city}, ${address.state}'),
        sizedBoxHeight05,
        CommonTextWidget(title: address.pincode.toString()),
      ],
    );
  }
}
