// import '../../../import.dart';

// class ScanScreen extends StatefulWidget {
//   const ScanScreen({super.key});

//   @override
//   State<ScanScreen> createState() => _ScanScreenState();
// }

// class _ScanScreenState extends State<ScanScreen> {
//   MobileScannerController cameraController = MobileScannerController();
//   bool isScanning = true;
//   bool isFlashOn = true; // Manually track torch state
//   bool isBackCamera = true; // Manually track camera state

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'QR Scanner',
//           style: GoogleFonts.poppins(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         actions: [
//           // Toggle flash
//           IconButton(
//             icon: Icon(isFlashOn
//                 ? Icons.flash_on
//                 : Icons.flash_off), // Track flash state manually
//             onPressed: () {
//               cameraController.toggleTorch();
//               setState(() {
//                 isFlashOn = !isFlashOn; // Toggle the state manually
//               });
//             },
//           ),
//           // Switch camera
//           IconButton(
//             icon: Icon(isBackCamera
//                 ? Icons.camera_rear
//                 : Icons.camera_front), // Track camera state manually
//             onPressed: () {
//               cameraController.switchCamera();
//               setState(() {
//                 isBackCamera = !isBackCamera; // Toggle the state manually
//               });
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Stack(
//               children: [
//                 // Scanner
//                 MobileScanner(
//                   controller: cameraController,
//                   onDetect: (capture) {
//                     final List<Barcode> barcodes = capture.barcodes;
//                     for (final barcode in barcodes) {
//                       if (isScanning) {
//                         isScanning = false; // Prevent multiple scans
//                         _handleBarcode(barcode.rawValue ?? '');
//                       }
//                     }
//                   },
//                 ),
//                 // Overlay
//                 CustomPaint(
//                   painter: ScannerOverlayPainter(),
//                   child: const SizedBox(
//                     width: double.infinity,
//                     height: double.infinity,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Bottom info section
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Point your camera at a QR code',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'QR code will be scanned automatically',
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleBarcode(String value) async {
//     String productId = value; // Extract product ID from QR code

//     // Simulate fetching product details from an API or Firebase
//     final productDetails = await fetchProductDetails(productId);

//     // ignore: unnecessary_null_comparison
//     if (productDetails != null) {
//       // Navigate to the ProductScreen and pass the fetched details
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => ProductScreen(productDetails: productDetails),
//       //   ),
//       // );
//     }

//     setState(() {
//       isScanning = true;
//     });
//   }

//   Future<ProductSampleDetails> fetchProductDetails(String productId) async {
//     // Implement your API call or Firebase query to get product details
//     // This is just a placeholder function
//     return ProductSampleDetails(
//         id: productId, name: 'Example Product', price: 100);
//   }

//   @override
//   void dispose() {
//     cameraController.dispose();
//     super.dispose();
//   }
// }

// // Custom painter for scanner overlay
// class ScannerOverlayPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black54
//       ..style = PaintingStyle.fill;

//     final scanAreaSize = size.width * 0.7;
//     final scanAreaLeft = (size.width - scanAreaSize) / 2;
//     final scanAreaTop = (size.height - scanAreaSize) / 2;

//     // Draw overlay
//     Path path = Path()
//       ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
//       ..addRect(Rect.fromLTWH(
//         scanAreaLeft,
//         scanAreaTop,
//         scanAreaSize,
//         scanAreaSize,
//       ));

//     canvas.drawPath(path, paint);

//     // Draw scan area border
//     final borderPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;

//     canvas.drawRect(
//       Rect.fromLTWH(
//         scanAreaLeft,
//         scanAreaTop,
//         scanAreaSize,
//         scanAreaSize,
//       ),
//       borderPaint,
//     );

//     // Draw corner indicators
//     final cornerLength = scanAreaSize * 0.1;
//     final cornerPaint = Paint()
//       ..color = cButtonGreen
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4;

//     // Top left corner
//     canvas.drawLine(
//       Offset(scanAreaLeft, scanAreaTop),
//       Offset(scanAreaLeft + cornerLength, scanAreaTop),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(scanAreaLeft, scanAreaTop),
//       Offset(scanAreaLeft, scanAreaTop + cornerLength),
//       cornerPaint,
//     );

//     // Top right corner
//     canvas.drawLine(
//       Offset(scanAreaLeft + scanAreaSize, scanAreaTop),
//       Offset(scanAreaLeft + scanAreaSize - cornerLength, scanAreaTop),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(scanAreaLeft + scanAreaSize, scanAreaTop),
//       Offset(scanAreaLeft + scanAreaSize, scanAreaTop + cornerLength),
//       cornerPaint,
//     );

//     // Bottom left corner
//     canvas.drawLine(
//       Offset(scanAreaLeft, scanAreaTop + scanAreaSize),
//       Offset(scanAreaLeft + cornerLength, scanAreaTop + scanAreaSize),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(scanAreaLeft, scanAreaTop + scanAreaSize),
//       Offset(scanAreaLeft, scanAreaTop + scanAreaSize - cornerLength),
//       cornerPaint,
//     );

//     // Bottom right corner
//     canvas.drawLine(
//       Offset(scanAreaLeft + scanAreaSize, scanAreaTop + scanAreaSize),
//       Offset(scanAreaLeft + scanAreaSize - cornerLength,
//           scanAreaTop + scanAreaSize),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(scanAreaLeft + scanAreaSize, scanAreaTop + scanAreaSize),
//       Offset(scanAreaLeft + scanAreaSize,
//           scanAreaTop + scanAreaSize - cornerLength),
//       cornerPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
