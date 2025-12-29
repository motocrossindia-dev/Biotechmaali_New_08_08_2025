import 'package:biotech_maali/src/payment_and_order/local_store_list/local_store_list_provider.dart';
import 'package:biotech_maali/src/payment_and_order/local_store_list/local_store_list_screen.dart';

import '../../../../import.dart';

class DeliveryOptionsWidget extends StatefulWidget {
  const DeliveryOptionsWidget({super.key});

  @override
  State<DeliveryOptionsWidget> createState() => _DeliveryOptionsWidgetState();
}

class _DeliveryOptionsWidgetState extends State<DeliveryOptionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<OrderSummaryProvider, LocalStoreListProvider>(
      builder: (context, orderProvider, storeProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Choose Delivery Option',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            _buildDeliveryOption('Door Step Delivery', orderProvider),
            // _buildDeliveryOption('Express', orderProvider),
            _buildPickupOption(orderProvider, storeProvider),
          ],
        );
      },
    );
  }

  Widget _buildDeliveryOption(String option, OrderSummaryProvider provider) {
    return RadioListTile<String>(
      title: Text(option),
      value: 'Door Delivery',
      groupValue: provider.selectedDeliveryOption,
      onChanged: (value) {
        provider.setDeliveryOption(value ?? 'Door Delivery');
        provider.setChooseDeliveryOption(false);
      },
      activeColor: Colors.green,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }

  Widget _buildPickupOption(
    OrderSummaryProvider orderProvider,
    LocalStoreListProvider storeProvider,
  ) {
    final isPickupSelected =
        orderProvider.selectedDeliveryOption == "Pick Up Store";

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Pick from local store'),
                value: "Pick Up Store",
                groupValue: orderProvider.selectedDeliveryOption,
                onChanged: (value) async {
                  orderProvider.setDeliveryOption(value ?? 'Door Delivery');
                  if (value == "Pick Up Store") {
                    await _showStoreSelection(context, storeProvider);
                  }
                },
                activeColor: Colors.green,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ),
            if (isPickupSelected)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: TextButton(
                  onPressed: () => _showStoreSelection(context, storeProvider),
                  child: const Text(
                    'Change',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
          ],
        ),
        if (isPickupSelected && storeProvider.stores.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 16.0),
            child: _buildSelectedStoreDetails(storeProvider),
          ),
      ],
    );
  }

  Widget _buildSelectedStoreDetails(LocalStoreListProvider provider) {
    final store = provider.stores[provider.selectedStoreIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          title: store.location,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 4),
        CommonTextWidget(
          title: store.address,
          fontSize: 14,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.access_time, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            CommonTextWidget(
              title: store.timePeriod,
              fontSize: 12,
              color: Colors.grey,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.phone, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            CommonTextWidget(
              title: store.contact,
              fontSize: 12,
              color: Colors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showStoreSelection(
    BuildContext context,
    LocalStoreListProvider provider,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectLocalStoreScreen(),
      ),
    );

    if (result != null && context.mounted) {
      provider.setSelectedStoreModel(result);
      context.read<OrderSummaryProvider>().setChooseDeliveryOption(true);
    }
  }
}
