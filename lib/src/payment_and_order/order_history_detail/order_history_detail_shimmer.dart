import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OrderHistoryDetailShimmer extends StatelessWidget {
  const OrderHistoryDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            _buildShimmerCard('Order Summary', _buildOrderSummaryShimmer()),
            _buildShimmerCard(
                'Shipping Information', _buildShippingInformationShimmer()),
            _buildShimmerCard('Order Items', _buildOrderItemsShimmer()),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard(String title, Widget child) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryShimmer() {
    return Column(
      children: [
        _buildShimmerRow(),
        _buildShimmerRow(),
        _buildShimmerRow(),
        _buildShimmerRow(),
        const Divider(),
        _buildShimmerRow(),
        _buildShimmerRow(),
        _buildShimmerRow(isTotal: true),
      ],
    );
  }

  Widget _buildShippingInformationShimmer() {
    return Column(
      children: [
        _buildShimmerRow(),
        const Divider(),
        _buildShimmerRow(),
        _buildShimmerRow(),
        _buildShimmerRow(),
        _buildShimmerRow(),
      ],
    );
  }

  Widget _buildOrderItemsShimmer() {
    return Column(
      children: List.generate(
        2,
        (index) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: Colors.grey[300]!),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 120,
                        height: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerRow({bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            height: isTotal ? 18 : 14,
            color: Colors.white,
          ),
          Container(
            width: 80,
            height: isTotal ? 18 : 14,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}