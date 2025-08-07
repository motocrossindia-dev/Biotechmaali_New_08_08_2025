import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

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
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localFilePath;
  bool isLoading = true;
  double downloadProgress = 0.0;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _downloadPdfFile();
  }

  Future<void> _downloadPdfFile() async {
    try {
      // Request storage permission
      if (Platform.isAndroid || Platform.isIOS) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission is required')),
          );
          Navigator.of(context).pop();
          return;
        }
      }

      // Get the temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/invoice.pdf';

      // Download the PDF
      await _dio.download(
        widget.pdfUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              downloadProgress = received / total;
            });
          }
        },
      );

      setState(() {
        localFilePath = filePath;
        isLoading = false;
      });
    } catch (e) {
      log('Download error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download PDF: ${e.toString()}')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _savePdfFile() async {
    if (localFilePath == null) return;

    try {
      // Request storage permission
      if (Platform.isAndroid || Platform.isIOS) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission is required')),
          );
          return;
        }
      }

      // Get the downloads directory
      final Directory? downloadsDir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      if (downloadsDir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not access download directory')),
        );
        return;
      }

      // Create a unique filename
      final String fileName =
          'Invoice_${widget.orderNumber ?? DateTime.now().millisecondsSinceEpoch}.pdf';
      final String newPath = '${downloadsDir.path}/$fileName';

      // Copy the file
      await File(localFilePath!).copy(newPath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to $newPath')),
      );
    } catch (e) {
      log('Save error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save PDF: ${e.toString()}')),
      );
    }
  }

  Future<void> _sharePdfFile() async {
    if (localFilePath == null) return;

    try {
      // Share the PDF file
      final xFile = XFile(localFilePath!);
      await Share.shareXFiles(
        [xFile],
        text: widget.title ?? 'Check out this invoice',
        subject: widget.title ?? 'Invoice',
      );
    } catch (e) {
      log('Share error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share PDF: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Invoice'),
        actions: [
          if (localFilePath != null) ...[
            // Share Button
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _sharePdfFile,
              tooltip: 'Share PDF',
            ),
            // Download Button
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _savePdfFile,
              tooltip: 'Save PDF',
            ),
          ],
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: downloadProgress,
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  const SizedBox(height: 16),
                  Text(
                      'Downloading PDF... ${(downloadProgress * 100).toStringAsFixed(0)}%'),
                ],
              ),
            )
          : localFilePath == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 60),
                      const SizedBox(height: 16),
                      const Text(
                        'Failed to download PDF',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _downloadPdfFile,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : PDFView(
                  filePath: localFilePath!,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: false,
                  onError: (error) {
                    log('PDF Error: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error displaying PDF')),
                    );
                  },
                  onPageError: (page, error) {
                    log('PDF Page Error on page $page: $error');
                  },
                ),
    );
  }
}
