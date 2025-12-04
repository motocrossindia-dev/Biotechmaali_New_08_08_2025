import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biotech_maali/src/payment_and_order/order_history/order_history_provider.dart';
import 'package:biotech_maali/core/network/app_end_url.dart';
import 'package:biotech_maali/src/permission_handle/pdf_viewer/pdf_viewer.dart';
import 'order_return_dialog.dart';

class OrderActionsSheet {
  static const Color themeColor = Color(0xFF749F09);

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
    final canReturn = canReturnOrder(deliveryDate);
    final isDelivered = orderStatus.toUpperCase() == 'DELIVERED';
    final canCancel = orderStatus.toLowerCase() != 'cancelled' &&
        orderStatus.toLowerCase() != 'delivered' &&
        orderStatus.toLowerCase() != 'ready_for_pickup' &&
        orderStatus.toLowerCase() != 'on_the_way';

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

                  // Return Order - Only within 3 days of delivery
                  if (isDelivered && canReturn)
                    _buildActionTile(
                      icon: Icons.assignment_return_outlined,
                      title: 'Return Order',
                      subtitle: 'Request a return for this order',
                      iconColor: Colors.orange,
                      onTap: () async {
                        Navigator.pop(context);
                        final result = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (dialogContext) => OrderReturnDialog(
                            orderId: orderId,
                            orderNumber: orderNumber,
                          ),
                        );

                        if (result == true && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),

                  // Return Not Available Message
                  if (isDelivered && !canReturn)
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Return window closed. Returns are only available within 3 days of delivery.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.orange.shade900,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Cancel Order - Only for pending/processing orders
                  if (canCancel)
                    _buildActionTile(
                      icon: Icons.cancel_outlined,
                      title: 'Cancel Order',
                      subtitle: 'Cancel this order',
                      iconColor: Colors.red,
                      onTap: () async {
                        Navigator.pop(context);
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text('Cancel Order'),
                            content: const Text(
                              'Are you sure you want to cancel this order?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, false),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Yes, Cancel'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && context.mounted) {
                          final success = await context
                              .read<OrderHistoryProvider>()
                              .cancelOrder(orderId.toString());

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Order cancelled successfully'
                                      : 'Failed to cancel order',
                                ),
                                backgroundColor:
                                    success ? Colors.green : Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                            if (success) {
                              Navigator.pop(context);
                            }
                          }
                        }
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
