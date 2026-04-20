import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../import.dart';

/// Shows the filter bottom sheet and returns true if filters were applied.
Future<bool?> showFilterBottomSheet(
  BuildContext context, {
  required String categoryId,
  required String categoryType,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) => FilterBottomSheet(
      categoryId: categoryId,
      categoryType: categoryType,
    ),
  );
}

class FilterBottomSheet extends StatefulWidget {
  final String categoryId;
  final String categoryType; // e.g. "plants", "pots", "plant-care"
  const FilterBottomSheet({
    required this.categoryId,
    required this.categoryType,
    super.key,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('Loading filters — type: ${widget.categoryType}');
      context.read<FiltersProvider>().loadFilters(widget.categoryType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FiltersProvider>(
      builder: (context, provider, _) {
        final screenH = MediaQuery.of(context).size.height;

        return Container(
          height: screenH * 0.92,
          decoration: const BoxDecoration(
            color: Color(0xFFF8F6F2),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(provider),
              const Divider(height: 1, color: Color(0xFFE0DDD6)),
              Expanded(
                child: provider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF3D6B3A)))
                    : _buildBody(provider),
              ),
              _buildApplyBar(provider),
            ],
          ),
        );
      },
    );
  }

  // ── Handle & header ────────────────────────────────────────────────────────

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFFCCC9C0),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(FiltersProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
      child: Row(
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1C),
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          if (provider.activeFilterCount > 0)
            TextButton(
              onPressed: provider.resetAllFilters,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF3D6B3A),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text(
                'CLEAR ALL',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF444444)),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody(FiltersProvider provider) {
    final r = provider.filterResponse;
    if (r == null) {
      return const Center(child: Text('No filters available'));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        // ── Type ──────────────────────────────────────────────────────────
        if (r.availableTypes != null && r.availableTypes!.isNotEmpty) ...[
          _sectionHeader('Type', null),
          const SizedBox(height: 10),
          _buildTypeChips(r.availableTypes!, provider),
          const SizedBox(height: 20),
        ],

        // ── Price Range ───────────────────────────────────────────────────
        _sectionHeader('Price Range', null),
        const SizedBox(height: 12),
        _buildPriceSection(provider),
        const SizedBox(height: 20),

        // ── Subcategories ─────────────────────────────────────────────────
        if (r.subcategories != null && r.subcategories!.isNotEmpty) ...[
          _sectionHeader('CATEGORIES', Icons.filter_list_rounded),
          const SizedBox(height: 10),
          _buildIntChips(r.subcategories!, 'subcategories', provider),
          const SizedBox(height: 20),
        ],

        // ── Size ──────────────────────────────────────────────────────────
        if (r.sizes != null && r.sizes!.isNotEmpty) ...[
          _sectionDot('SIZE'),
          const SizedBox(height: 10),
          _buildIntChips(r.sizes!, 'size', provider),
          const SizedBox(height: 20),
        ],

        // ── Color ─────────────────────────────────────────────────────────
        if (r.colors != null && r.colors!.isNotEmpty) ...[
          _sectionDot('COLOR'),
          const SizedBox(height: 10),
          _buildDropdown(
            label: 'SELECT COLOR',
            items: r.colors!
                .map((c) => _DropItem(id: c.id, name: c.name))
                .toList(),
            category: 'color',
            provider: provider,
          ),
          const SizedBox(height: 20),
        ],

        // ── Planter Size ──────────────────────────────────────────────────
        if (r.planterSizes != null && r.planterSizes!.isNotEmpty) ...[
          _sectionDot('PLANTER SIZE',
              icon: const Icon(Icons.crop_square_rounded,
                  size: 14, color: Color(0xFF9B59B6))),
          const SizedBox(height: 10),
          _buildDropdown(
            label: 'SELECT PLANTER SIZE',
            items: r.planterSizes!
                .map((p) => _DropItem(id: p.id, name: p.name))
                .toList(),
            category: 'planter_size',
            provider: provider,
          ),
          const SizedBox(height: 20),
        ],

        // ── Planter (string IDs) ──────────────────────────────────────────
        if (r.planters != null && r.planters!.isNotEmpty) ...[
          _sectionDot('PLANTER'),
          const SizedBox(height: 10),
          _buildStringChips(r.planters!, 'planter', provider),
          const SizedBox(height: 20),
        ],

        // ── Weight ────────────────────────────────────────────────────────
        if (r.weights != null && r.weights!.isNotEmpty) ...[
          _sectionDot('WEIGHT'),
          const SizedBox(height: 10),
          _buildDropdown(
            label: 'SELECT WEIGHT',
            items: r.weights!
                .map((w) => _DropItem(id: w.id, name: w.name))
                .toList(),
            category: 'weights',
            provider: provider,
          ),
          const SizedBox(height: 20),
        ],

        // ── Volume ────────────────────────────────────────────────────────
        if (r.volumes != null && r.volumes!.isNotEmpty) ...[
          _sectionDot('VOLUME'),
          const SizedBox(height: 10),
          _buildIntChips(r.volumes!, 'volume', provider),
          const SizedBox(height: 20),
        ],

        // ── Space and Light ───────────────────────────────────────────────
        if (r.spaceAndLight != null && r.spaceAndLight!.isNotEmpty) ...[
          _sectionDot('SPACE AND LIGHT',
              icon: const Icon(Icons.wb_sunny_outlined,
                  size: 16, color: Color(0xFFF39C12))),
          const SizedBox(height: 10),
          _buildIntChips(r.spaceAndLight!, 'space_and_light', provider),
          const SizedBox(height: 20),
        ],

        // ── Special Filters ───────────────────────────────────────────────
        if (r.specialFilters != null && r.specialFilters!.isNotEmpty) ...[
          _sectionDot('SPECIAL FILTERS',
              icon: const Icon(Icons.star_border_rounded,
                  size: 16, color: Color(0xFF2ECC71))),
          const SizedBox(height: 10),
          _buildSpecialFilterChips(r.specialFilters!, provider),
          const SizedBox(height: 20),
        ],

        // ── Care Guides ───────────────────────────────────────────────────
        if (r.careGuides != null && r.careGuides!.isNotEmpty) ...[
          _sectionDot('CARE GUIDES',
              icon: const Icon(Icons.water_drop_outlined,
                  size: 16, color: Color(0xFF3498DB))),
          const SizedBox(height: 10),
          _buildCareGuideChips(r.careGuides!, provider),
          const SizedBox(height: 20),
        ],

        // ── Flags ─────────────────────────────────────────────────────────
        if (r.flags != null && r.flags!.isNotEmpty) ...[
          _sectionDot('COLLECTION'),
          const SizedBox(height: 10),
          _buildFlagChips(r.flags!, provider),
          const SizedBox(height: 20),
        ],

        // ── Rating ────────────────────────────────────────────────────────
        if (r.ratingOptions != null && r.ratingOptions!.isNotEmpty) ...[
          _sectionDot('RATING OPTIONS',
              icon: const Icon(Icons.star_border_outlined,
                  size: 16, color: Color(0xFFF39C12))),
          const SizedBox(height: 10),
          _buildRatingChips(r.ratingOptions!, provider),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  // ── Section labels ─────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData? icon) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: const Color(0xFF3D6B3A)),
          const SizedBox(width: 6),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1C1C),
          ),
        ),
      ],
    );
  }

  Widget _sectionDot(String title, {Widget? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          icon,
          const SizedBox(width: 6),
        ] else ...[
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF8D9E6C),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: Color(0xFF555555),
          ),
        ),
      ],
    );
  }

  // ── Price section — slider only, no separate apply button ─────────────────

  Widget _buildPriceSection(FiltersProvider provider) {
    final pr = provider.filterResponse?.priceRange;
    if (pr == null) return const SizedBox();

    return Column(
      children: [
        RangeSlider(
          values: provider.currentRangeValues,
          min: pr.min,
          max: pr.max,
          activeColor: const Color(0xFF3D6B3A),
          inactiveColor: const Color(0xFFD4D0C6),
          labels: RangeLabels(
            '₹${provider.currentRangeValues.start.round()}',
            '₹${provider.currentRangeValues.end.round()}',
          ),
          onChanged: provider.setPriceRange,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _priceLabel('₹${provider.currentRangeValues.start.round()}',
                  isMin: true),
              _priceLabel('₹${provider.currentRangeValues.end.round()}',
                  isMin: false),
            ],
          ),
        ),
        if (provider.isPriceChanged) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 14, color: Color(0xFF3D6B3A)),
                const SizedBox(width: 4),
                Text(
                  'Price range will be applied on filter',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF3D6B3A).withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _priceLabel(String text, {required bool isMin}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD8D5CC)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  // ── Type chips — SINGLE SELECT ────────────────────────────────────────────

  Widget _buildTypeChips(List<String> types, FiltersProvider provider) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((t) {
        final selected = provider.isTypeSelected(t);
        return _chip(
          label: _capitalize(t),
          selected: selected,
          onTap: () => provider.selectType(t),
        );
      }).toList(),
    );
  }

  // ── Integer-ID chips ───────────────────────────────────────────────────────

  Widget _buildIntChips(
    List<FilterOption> options,
    String category,
    FiltersProvider provider,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final selected = provider.isFilterSelected(category, opt.id);
        return _chip(
          label: opt.name,
          selected: selected,
          onTap: () => provider.toggleFilterById(category, opt.id),
        );
      }).toList(),
    );
  }

  // ── String-ID chips ────────────────────────────────────────────────────────

  Widget _buildStringChips(
    List<FilterStringOption> options,
    String category,
    FiltersProvider provider,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final selected = provider.isStringFilterSelected(category, opt.id);
        return _chip(
          label: opt.name,
          selected: selected,
          onTap: () => provider.toggleFilterByStringId(category, opt.id),
        );
      }).toList(),
    );
  }

  // ── Special filter chips (optional icon URL) ───────────────────────────────

  Widget _buildSpecialFilterChips(
    List<SpecialFilterOption> options,
    FiltersProvider provider,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final selected = provider.isFilterSelected('special_filters', opt.id);
        return _chip(
          label: opt.name,
          selected: selected,
          iconUrl: opt.icon,
          onTap: () => provider.toggleFilterById('special_filters', opt.id),
        );
      }).toList(),
    );
  }

  // ── Care guide chips (icon URL) ────────────────────────────────────────────

  Widget _buildCareGuideChips(
    List<CareGuideOption> options,
    FiltersProvider provider,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final selected = provider.isFilterSelected('care_guides', opt.id);
        return _chip(
          label: opt.title,
          selected: selected,
          iconUrl: opt.icon,
          onTap: () => provider.toggleFilterById('care_guides', opt.id),
        );
      }).toList(),
    );
  }

  // ── Flag chips (integer IDs) ───────────────────────────────────────────────

  Widget _buildFlagChips(List<FlagOption> flags, FiltersProvider provider) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: flags.map((flag) {
        final selected = provider.isFlagSelected(flag.id);
        return _chip(
          label: flag.label,
          selected: selected,
          onTap: () => provider.toggleFlagById(flag.id),
        );
      }).toList(),
    );
  }

  // ── Rating chips ───────────────────────────────────────────────────────────

  Widget _buildRatingChips(
      List<RatingOption> options, FiltersProvider provider) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final selected = provider.selectedRating == opt.value;
        return GestureDetector(
          onTap: () => provider.selectRating(opt.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF3D6B3A) : Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: selected
                    ? const Color(0xFF3D6B3A)
                    : const Color(0xFFD8D5CC),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded,
                    size: 16,
                    color: selected
                        ? Colors.white
                        : const Color(0xFFF39C12)),
                const SizedBox(width: 4),
                Text(
                  opt.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: selected
                        ? Colors.white
                        : const Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Dropdown for large lists ───────────────────────────────────────────────

  Widget _buildDropdown({
    required String label,
    required List<_DropItem> items,
    required String category,
    required FiltersProvider provider,
  }) {
    final selectedIds = provider.selectedFilterIds[category] ?? [];
    String selectedLabel = label;
    if (selectedIds.isNotEmpty) {
      final names =
          items.where((i) => selectedIds.contains(i.id)).map((i) => i.name);
      if (names.isNotEmpty) selectedLabel = names.join(', ');
    }

    return GestureDetector(
      onTap: () => _showDropdownSheet(label, items, category, provider),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD8D5CC), width: 1.2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: selectedIds.isNotEmpty
                      ? const Color(0xFF3D6B3A)
                      : const Color(0xFF333333),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF888888)),
          ],
        ),
      ),
    );
  }

  void _showDropdownSheet(
    String label,
    List<_DropItem> items,
    String category,
    FiltersProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
              child: Row(
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: StatefulBuilder(
                builder: (ctx, localSet) => ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    final selected =
                        provider.isFilterSelected(category, item.id);
                    return CheckboxListTile(
                      title: Text(item.name,
                          style: const TextStyle(fontSize: 14)),
                      value: selected,
                      activeColor: const Color(0xFF3D6B3A),
                      onChanged: (_) {
                        provider.toggleFilterById(category, item.id);
                        localSet(() {});
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D6B3A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('DONE',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Generic chip ───────────────────────────────────────────────────────────

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    String? iconUrl,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
            horizontal: iconUrl != null ? 10 : 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF3D6B3A) : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: selected
                ? const Color(0xFF3D6B3A)
                : const Color(0xFFD8D5CC),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconUrl != null && iconUrl.isNotEmpty) ...[
              CachedNetworkImage(
                imageUrl: iconUrl,
                width: 18,
                height: 18,
                color: selected ? Colors.white : null,
                errorWidget: (_, __, ___) => const SizedBox(),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : const Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Apply / Reset bar ──────────────────────────────────────────────────────

  Widget _buildApplyBar(FiltersProvider provider) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: provider.resetAllFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: const BorderSide(color: Color(0xFF3D6B3A), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'RESET',
                style: TextStyle(
                  color: Color(0xFF3D6B3A),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  provider.resetPagination();
                  final result = await provider.applyFilters(context);
                  if (mounted) {
                    Navigator.pop(context, result.isNotEmpty);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Failed to apply filters: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: const Color(0xFF3D6B3A),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                provider.activeFilterCount > 0
                    ? 'APPLY (${provider.activeFilterCount})'
                    : 'APPLY',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s.split('-').map((w) {
      if (w.isEmpty) return w;
      return w[0].toUpperCase() + w.substring(1).toLowerCase();
    }).join('-');
  }
}

/// Internal DTO for dropdown items (integer ID)
class _DropItem {
  final int id;
  final String name;
  _DropItem({required this.id, required this.name});
}
