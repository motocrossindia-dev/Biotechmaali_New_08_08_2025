import 'package:biotech_maali/src/payment_and_order/local_store_list/local_store_list_provider.dart';
import 'package:biotech_maali/src/payment_and_order/local_store_list/model/local_store_model.dart';

import '../../../import.dart';

class SelectLocalStoreScreen extends StatefulWidget {
  const SelectLocalStoreScreen({super.key});

  @override
  State<SelectLocalStoreScreen> createState() => _SelectLocalStoreScreenState();
}

class _SelectLocalStoreScreenState extends State<SelectLocalStoreScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch stores when screen loads
    context.read<LocalStoreListProvider>().fetchStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonTextWidget(
          title: 'Select Local Store',
          fontSize: 18,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<LocalStoreListProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text(provider.error ?? 'Something went wrong'),
            );
          }

          if (provider.stores.isEmpty) {
            return const Center(
              child: Text('No stores available'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: provider.stores.length,
                  itemBuilder: (context, index) {
                    final store = provider.stores[index];
                    return GestureDetector(
                      onTap: () => provider.setSelectedStoreModel(store),
                      child: StoreCard(
                        isSelected: provider.selectedStoreIndex == index,
                        store: store,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (provider.stores.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: cButtonGreen),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: CommonTextWidget(
                            title: 'CANCEL',
                            color: cButtonGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cButtonGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () =>
                              Navigator.pop(context, provider.selectedStore),
                          child: const CommonTextWidget(
                            title: 'PICKUP HERE',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  final bool isSelected;
  final LocalStoreModel store;

  const StoreCard({
    super.key,
    required this.isSelected,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with fixed height
          SizedBox(
            height: 120, // Fixed height for image
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: store.image != null
                      ? Image.network(
                          store.getFullImageUrl()!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildErrorContainer(),
                        )
                      : _buildErrorContainer(),
                ),
                if (isSelected)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: cButtonGreen,
                          radius: 20,
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Add this
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.location,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      store.address,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min, // Add this
                    children: [
                      const Icon(Icons.access_time, size: 12),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          store.timePeriod,
                          style: const TextStyle(fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContainer() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 40),
      ),
    );
  }
}
