import 'package:flutter/material.dart';
import 'package:biotech_maali/core/network/app_end_url.dart';
import 'package:biotech_maali/src/permission_handle/pdf_viewer/pdf_viewer.dart';

class OrderActionsSheet {
  static const Color themeColor = Color(0xFF3F6331);

  /// Calculate if return is allowed (within 3 days of delivery)
  static bool canReturnOrder(String? deliveryDate) {
    if (deliveryDate == null || deliveryDate.isEmpty) return false;

    try {
      // Parse delivery date (assuming format like "2025-10-15" or "15-10-2025")
      DateTime delivery;
      if (deliveryDate.contains('-')) {
        final parts = deliveryDate.split('-');
        if (parts[0].length == 4) {
          // Format: YYYY-MM-DD
          delivery = DateTime.parse(deliveryDate);
        } else {
          // Format: DD-MM-YYYY
          delivery = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } else {
        return false;
      }

      final now = DateTime.now();
      final difference = now.difference(delivery).inDays;

      // Allow return within 3 days
      return difference <= 3 && difference >= 0;
    } catch (e) {
      return false;
    }
  }

  /// Show order actions bottom sheet
  static void show({
    required BuildContext context,
    required int orderId,
    required String orderNumber,
    required String orderStatus,
    String? deliveryDate,
  }) {
    final isDelivered = orderStatus.toUpperCase() == 'DELIVERED';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.help_outline_rounded,
                      color: themeColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Actions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                        Text(
                          'Order #$orderNumber',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Action Items
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  // Download Invoice - Always visible for delivered orders
                  if (isDelivered)
                    _buildActionTile(
                      icon: Icons.receipt_long_outlined,
                      title: 'Download Invoice',
                      subtitle: 'View and share your invoice',
                      iconColor: themeColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              pdfUrl: "${EndUrl.pdfInvoiceUrl}$orderId/",
                              title: "Invoice - $orderId",
                              orderNumber: orderNumber,
                            ),
                          ),
                        );
                      },
                    ),

                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
