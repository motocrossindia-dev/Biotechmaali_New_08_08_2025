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
      log("Loading filters for category: ${widget.type}");
      context.read<FiltersProvider>().loadFilters(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FiltersProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(
              child: ProductListShimmer(),
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
    // Get dynamic categories based on API response
    final categories = provider.getDisplayCategories(widget.type);

    if (categories.isEmpty) {
      return const Center(child: Text('No filters available'));
    }

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = provider.selectedCategory == category["title"];

        return ListTile(
          title: Text(
            category["title"]!,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Theme.of(context).primaryColor : Colors.black,
            ),
          ),
          tileColor: isSelected ? Colors.grey[100] : null,
          onTap: () => provider.setSelectedCategory(category["title"]!),
        );
      },
    );
  }

  Widget _buildFilterContent(FiltersProvider provider) {
    final response = provider.filterResponse;
    if (response == null) return const SizedBox();

    // Map selected category title to the filter type
    String filterType = "";
    final categories = provider.getDisplayCategories(widget.type);

    for (var category in categories) {
      if (category["title"] == provider.selectedCategory) {
        filterType = category["id"]!;
        break;
      }
    }

    switch (filterType) {
      case "subcategories":
        if (response.subcategories != null) {
          return _buildFilterOptionsSection(
            provider.selectedCategory,
            response.subcategories!,
            "subcategories",
            provider,
          );
        }
        break;

      case "size":
        if (response.sizes != null) {
          return _buildFilterOptionsSection(
            "Size",
            response.sizes!,
            "size",
            provider,
          );
        }
        break;

      case "planter_size":
        if (response.planterSizes != null) {
          return _buildFilterOptionsSection(
            widget.type == "POTS" ? "Pot Size" : "Planter Size",
            response.planterSizes!,
            "planter_size",
            provider,
          );
        }
        break;

      case "planter":
        if (response.planters != null) {
          return _buildFilterOptionsSection(
            "Planter",
            response.planters!,
            "planter",
            provider,
          );
        }
        break;

      case "color":
        if (response.colors != null) {
          return _buildFilterOptionsSection(
            "Color",
            response.colors!,
            "color",
            provider,
          );
        }
        break;

      case "weights":
        if (response.weights != null) {
          return _buildFilterOptionsSection(
            "Weights",
            response.weights!,
            "weights",
            provider,
          );
        }
        break;

      case "litre_size":
        if (response.litreSizes != null) {
          return _buildFilterOptionsSection(
            "Litre Size",
            response.litreSizes!,
            "litre_size",
            provider,
          );
        }
        break;

      case "price":
        return _buildPriceFilter(provider);

      default:
        return const Center(child: Text("Select a category"));
    }

    return const Center(child: Text("No options available"));
  }

  Widget _buildFilterOptionsSection(
    String title,
    List<FilterOption> options,
    String category,
    FiltersProvider provider,
  ) {
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
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected =
                    provider.isFilterSelected(category, option.id);

                return CheckboxListTile(
                  title: Text(option.name),
                  value: isSelected,
                  activeColor: Theme.of(context).primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  onChanged: (bool? checked) {
                    if (checked != null) {
                      provider.toggleFilterById(category, option.id);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
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
          Text(
            "Price Range",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          RangeSlider(
            values: provider.currentRangeValues,
            min: min,
            max: max,
            divisions: ((max - min) / 100).ceil().clamp(1, 100),
            labels: RangeLabels(
              "₹${provider.currentRangeValues.start.round()}",
              "₹${provider.currentRangeValues.end.round()}",
            ),
            onChanged: provider.setPriceRange,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹${provider.currentRangeValues.start.round()}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "₹${provider.currentRangeValues.end.round()}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
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
                  provider.resetPagination();
                  final result =
                      await provider.applyFilters(widget.type, context);
                  if (mounted) {
                    Navigator.pop(context, result);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to apply filters: $e')),
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
