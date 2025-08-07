import 'dart:developer';

import 'package:biotech_maali/src/module/product_list/product_list_shimmer.dart';

import '../../../import.dart';

class FilterScreen extends StatefulWidget {
  final String type;
  const FilterScreen({required this.type, super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<FiltersProvider>().resetAllFilters();
      log("category name : ${widget.type}");
      context.read<FiltersProvider>().loadFilters(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FiltersProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: Scaffold(
              body: Center(
                child: ProductListShimmer(),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Filters'),
            actions: [
              TextButton(
                onPressed: provider.resetAllFilters,
                child: const Text('Clear'),
              ),
            ],
          ),
          body: Row(
            children: [
              // Left Categories Panel
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: _buildCategoriesList(provider),
              ),
              // Right Content Panel
              Expanded(
                child: _buildFilterContent(provider),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(provider),
        );
      },
    );
  }

  Widget _buildCategoriesList(FiltersProvider provider) {
    List<Map<String, String>> categories = [];

    switch (widget.type) {
      case "PLANTS":
        categories = [
          {"id": "subcategories", "title": "Type of Plants"},
          {"id": "price", "title": "Price"},
          {"id": "size", "title": "Size"},
          {"id": "planter_size", "title": "Planter Size"},
          {"id": "planter", "title": "Planter"},
          {"id": "color", "title": "Color"},
        ];
        break;

      case "POTS":
        categories = [
          {"id": "subcategories", "title": "Type of Pots"},
          {"id": "price", "title": "Price"},
          {"id": "planter_size", "title": "Pot Size"},
          {"id": "litre_size", "title": "Litre Size"},
          {"id": "color", "title": "Color"},
        ];
        break;

      case "SEEDS":
        categories = [
          {"id": "subcategories", "title": "Type of Seeds"},
          {"id": "price", "title": "Price"},
          {"id": "weights", "title": "Weights"},
        ];
        break;

      case "TOOLS":
        categories = [
          {"id": "subcategories", "title": "Type of Tools"},
          {"id": "price", "title": "Price"},
          {"id": "size", "title": "Size"},
          {"id": "color", "title": "Color"},
        ];
        break;
    }

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          title: Text(
            category["title"]!,
            style: TextStyle(
              fontWeight: provider.selectedCategory == category["title"]
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: provider.selectedCategory == category["title"]
                  ? Theme.of(context).primaryColor
                  : Colors.black,
            ),
          ),
          tileColor: provider.selectedCategory == category["title"]
              ? Colors.grey[100]
              : null,
          onTap: () => provider.setSelectedCategory(category["title"]!),
        );
      },
    );
  }

  Widget _buildFilterContent(FiltersProvider provider) {
    final response = provider.filterResponse;
    if (response == null) return const SizedBox();

    switch (provider.selectedCategory) {
      case "Type of Plants":
      case "Type of Pots":
      case "Type of Seeds":
      case "Type of Tools":
        return _buildFilterSection(
          provider.selectedCategory,
          response.subcategories ?? [],
          "subcategories",
        );

      case "Size":
        return _buildFilterSection(
          "Size",
          response.sizes ?? [],
          "size",
        );

      case "Planter Size":
      case "Pot Size":
        return _buildFilterSection(
          "Size",
          response.planterSizes ?? [],
          "planter_size",
        );

      case "Planter":
        return _buildFilterSection(
          "Planter",
          response.planters ?? [],
          "planter",
        );

      case "Color":
        return _buildFilterSection(
          "Color",
          response.colors ?? [],
          "color",
        );

      case "Weights":
        return _buildFilterSection(
          "Weights",
          response.weights ?? [],
          "weights",
        );

      case "Litre Size":
        return _buildFilterSection(
          "Litre Size",
          response.litreSizes ?? [],
          "litre_size",
        );

      case "Price":
        return _buildPriceFilter(provider);

      default:
        return const Center(child: Text("Select a category"));
    }
  }

  Widget _buildFilterSection(
      String title, List<String> values, String category) {
    return Consumer<FiltersProvider>(
      builder: (context, provider, _) {
        final selectedValues = provider.selectedFilters[category] ?? [];

        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: values.length,
                  itemBuilder: (context, index) {
                    final value = values[index];
                    return CheckboxListTile(
                      title: Text(value),
                      value: selectedValues.contains(value),
                      activeColor: Theme.of(context).primaryColor,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      onChanged: (bool? checked) {
                        if (checked != null) {
                          provider.toggleFilter(category, value);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceFilter(FiltersProvider provider) {
    final min = provider.filterResponse?.priceRange.min ?? 0;
    final max = provider.filterResponse?.priceRange.max ?? 9999;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Price Range", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          RangeSlider(
            values: provider.currentRangeValues,
            min: min,
            max: max,
            divisions:
                ((max - min) / 100).ceil(), // Dynamic divisions based on range
            labels: RangeLabels(
              "₹${provider.currentRangeValues.start.round()}",
              "₹${provider.currentRangeValues.end.round()}",
            ),
            onChanged: provider.setPriceRange,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₹${provider.currentRangeValues.start.round()}"),
              Text("₹${provider.currentRangeValues.end.round()}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(FiltersProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: provider.resetAllFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Clear All',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                try {
                  provider
                      .resetPagination(); // Reset pagination before applying new filters
                  final result =
                      await provider.applyFilters(widget.type, context);
                  if (mounted) {
                    Navigator.pop(context, result);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to apply filters')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
