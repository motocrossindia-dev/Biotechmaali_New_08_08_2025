import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Google Play Compliant PDF Viewer
/// This implementation doesn't require any storage permissions
/// and complies with Google Play policies by using the browser for PDF viewing
class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String? title;
  final String? orderNumber;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    this.title,
    this.orderNumber,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Invoice'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _openPdfInBrowser,
            tooltip: 'Open in Browser',
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      size: 80,
                      color: Colors.green[600],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Invoice Ready',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.orderNumber != null) ...[
                      Text(
                        'Order: ${widget.orderNumber}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    const Text(
                      'Your invoice is ready to view. Tap the button below to open it in your default browser or PDF viewer.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _openPdfInBrowser,
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text('Open Invoice'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _sharePdfUrl,
                      icon: const Icon(Icons.share),
                      label: const Text('Share Invoice Link'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green[600],
                        side: BorderSide(color: Colors.green[600]!),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green[600],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Google Play Compliant - No storage permissions required',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _openPdfInBrowser() async {
    setState(() => _isLoading = true);

    try {
      final Uri pdfUri = Uri.parse(widget.pdfUrl);

      if (await canLaunchUrl(pdfUri)) {
        await launchUrl(
          pdfUri,
          mode: LaunchMode.externalApplication,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opening invoice in your default app...'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw 'Could not launch PDF URL';
      }
    } catch (e) {
      log('Error opening PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening PDF: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _sharePdfUrl() async {
    try {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Share Invoice'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Invoice URL:'),
                const SizedBox(height: 8),
                SelectableText(
                  widget.pdfUrl,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _openPdfInBrowser();
                },
                child: const Text('Open'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      log('Error sharing PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// }

//     super.key,

// class _PdfViewerScreenState extends State<PdfViewerScreen> {

//   @override    required this.pdfUrl,  final String? title;import 'package:share_plus/share_plus.dart';

//   Widget build(BuildContext context) {

//     return Scaffold(    this.title,

//       appBar: AppBar(

//         title: Text(widget.title ?? 'PDF Viewer'),    this.orderNumber,  final String? orderNumber;

//       ),

//       body: Center(  });

//         child: Column(

//           mainAxisAlignment: MainAxisAlignment.center,class PdfViewerScreen extends StatefulWidget {

//           children: [

//             const Icon(Icons.picture_as_pdf, size: 80, color: Colors.grey),  @override

//             const SizedBox(height: 16),

//             const Text(  State<PdfViewerScreen> createState() => _PdfViewerScreenState();  const PdfViewerScreen({  final String pdfUrl;

//               'PDF Viewer Temporarily Disabled',

//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),}

//             ),

//             const SizedBox(height: 8),    super.key,  final String? title;

//             const Text(

//               'Will be restored after Google Play approval',class _PdfViewerScreenState extends State<PdfViewerScreen> {

//               style: TextStyle(color: Colors.grey),

//             ),  @override    required this.pdfUrl,  final String? orderNumber;

//             const SizedBox(height: 24),

//             ElevatedButton(  Widget build(BuildContext context) {

//               onPressed: () {

//                 log('PDF URL: ${widget.pdfUrl}');    return Scaffold(    this.title,

//                 ScaffoldMessenger.of(context).showSnackBar(

//                   const SnackBar(      appBar: AppBar(

//                     content: Text('PDF viewing temporarily disabled for compliance'),

//                   ),        title: Text(widget.title ?? 'PDF Viewer'),    this.orderNumber,  const PdfViewerScreen({

//                 );

//               },      ),

//               child: const Text('View PDF Online'),

//             ),      body: Center(  });    super.key,

//           ],

//         ),        child: Column(

//       ),

//     );          mainAxisAlignment: MainAxisAlignment.center,    required this.pdfUrl,

//   }

// }          children: [

//             const Icon(Icons.picture_as_pdf, size: 80, color: Colors.grey),  @override    this.title,

//             const SizedBox(height: 16),

//             const Text(  _PdfViewerScreenState createState() => _PdfViewerScreenState();    this.orderNumber,

//               'PDF Viewer Temporarily Disabled',

//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),}  });

//             ),

//             const SizedBox(height: 8),

//             const Text(

//               'Will be restored after Google Play approval',class _PdfViewerScreenState extends State<PdfViewerScreen> {  @override

//               style: TextStyle(color: Colors.grey),

//             ),  @override  _PdfViewerScreenState createState() => _PdfViewerScreenState();

//             const SizedBox(height: 24),

//             ElevatedButton(  Widget build(BuildContext context) {}

//               onPressed: () {

//                 log('PDF URL: ${widget.pdfUrl}');    return Scaffold(

//                 ScaffoldMessenger.of(context).showSnackBar(

//                   const SnackBar(      appBar: AppBar(class _PdfViewerScreenState extends State<PdfViewerScreen> {

//                     content: Text('PDF viewing temporarily disabled for compliance'),

//                   ),        title: Text(widget.title ?? 'PDF Viewer'),  String? localFilePath;

//                 );

//               },      ),  bool isLoading = true;

//               child: const Text('View PDF Online'),

//             ),      body: Center(  double downloadProgress = 0.0;

//           ],

//         ),        child: Column(  final Dio _dio = Dio();

//       ),

//     );          mainAxisAlignment: MainAxisAlignment.center,  PdfController? pdfController;

//   }

// }          children: [

//             const Icon(Icons.picture_as_pdf, size: 80, color: Colors.grey),  @override

//             const SizedBox(height: 16),  void initState() {

//             const Text(    super.initState();

//               'PDF Viewer Temporarily Disabled',    _downloadPdfFile();

//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),  }

//             ),

//             const SizedBox(height: 8),  @override

//             const Text(  void dispose() {

//               'Will be restored after Google Play approval',    pdfController?.dispose();

//               style: TextStyle(color: Colors.grey),    super.dispose();

//             ),  }

//             const SizedBox(height: 24),

//             ElevatedButton(  Future<void> _downloadPdfFile() async {

//               onPressed: () {    try {

//                 // Open PDF URL in browser or download      // Get the temporary directory - no permissions needed for temp files

//                 log('PDF URL: ${widget.pdfUrl}');      final directory = await getTemporaryDirectory();

//                 ScaffoldMessenger.of(context).showSnackBar(      final filePath = '${directory.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';

//                   const SnackBar(

//                     content: Text('PDF viewing temporarily disabled for compliance'),      // Download the PDF

//                   ),      await _dio.download(

//                 );        widget.pdfUrl,

//               },        filePath,

//               child: const Text('Download PDF'),        onReceiveProgress: (received, total) {

//             ),          if (total != -1) {

//           ],            setState(() {

//         ),              downloadProgress = received / total;

//       ),            });

//     );          }

//   }        },

// }      );

//       // Initialize PDF controller
//       pdfController = PdfController(
//         document: PdfDocument.openFile(filePath),
//       );

//       setState(() {
//         localFilePath = filePath;
//         isLoading = false;
//       });
//     } catch (e) {
//       log('Download error: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to download PDF: ${e.toString()}')),
//         );
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _sharePdfFile() async {
//     if (localFilePath == null) return;

//     try {
//       // Share the PDF file
//       final xFile = XFile(localFilePath!);
//       await Share.shareXFiles(
//         [xFile],
//         text: widget.title ?? 'Check out this invoice',
//         subject: widget.title ?? 'Invoice',
//       );
//     } catch (e) {
//       log('Share error: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to share PDF: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title ?? 'Invoice'),
//         actions: [
//           if (localFilePath != null) ...[
//             // Share Button
//             IconButton(
//               icon: const Icon(Icons.share),
//               onPressed: _sharePdfFile,
//               tooltip: 'Share PDF',
//             ),
//           ],
//         ],
//       ),
//       body: isLoading
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     value: downloadProgress,
//                     backgroundColor: Colors.grey[200],
//                     valueColor:
//                         const AlwaysStoppedAnimation<Color>(Colors.blue),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                       'Downloading PDF... ${(downloadProgress * 100).toStringAsFixed(0)}%'),
//                 ],
//               ),
//             )
//           : localFilePath == null || pdfController == null
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.error_outline,
//                           color: Colors.red, size: 60),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Failed to download PDF',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       const SizedBox(height: 8),
//                       ElevatedButton(
//                         onPressed: _downloadPdfFile,
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : PdfView(
//                   controller: pdfController!,
//                   onDocumentError: (error) {
//                     log('PDF Error: $error');
//                     if (mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Error displaying PDF')),
//                       );
//                     }
//                   },
//                 ),
//     );
//   }
// }
