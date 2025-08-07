import '../../../../import.dart';

class InvoiceDownloadPopup {
  // Method 1: Simple AlertDialog
  static void showDeliveryInvoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invoice Download'),
          content: const Text(
            'You can download the invoice only after the delivery is completed.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Method 2: Custom SnackBar
  static void showInvoiceSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Invoice can be downloaded only after delivery',
          style: TextStyle(fontSize: 16),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Method 3: Bottom Sheet Popup
  static void showInvoiceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                color: cButtonGreen,
                size: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'Invoice Download',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'You can download the invoice only after the delivery is completed.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: cButtonGreen,
                    foregroundColor: cWhiteColor),
                child: const Text('Understood'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method 4: Conditional Download with Popup
  static Future<void> downloadInvoice(
      BuildContext context, bool isDelivered) async {
    if (!isDelivered) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cannot Download Invoice'),
            content: const Text(
              'Invoice is available only after the delivery is completed.',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
  }
}
