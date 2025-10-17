import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:pdfx/pdfx.dart';
import '../../../core/config/pallet.dart';

/// Google Play Compliant PDF Viewer
/// Modern design with app theme colors and social sharing
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
  String? _localPdfPath;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  final Dio _dio = Dio();
  PdfController? _pdfController;

  @override
  void initState() {
    super.initState();
    _downloadAndViewPdf();
  }

  Future<void> _downloadAndViewPdf() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      // Get app-specific directory (no permissions needed)
      final dir = await getApplicationDocumentsDirectory();

      // Create a unique filename based on order number
      final fileName =
          'invoice_${widget.orderNumber ?? DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${dir.path}/$fileName';
      final file = File(filePath);

      // Check if file already exists
      if (await file.exists()) {
        // Initialize PDF controller for existing file
        _pdfController = PdfController(
          document: PdfDocument.openFile(filePath),
        );

        setState(() {
          _localPdfPath = filePath;
          _isDownloading = false;
        });
        return;
      }

      // Download PDF with progress tracking
      await _dio.download(
        widget.pdfUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      // Initialize PDF controller after download completes
      _pdfController = PdfController(
        document: PdfDocument.openFile(filePath),
      );

      setState(() {
        _localPdfPath = filePath;
        _isDownloading = false;
      });
    } catch (e) {
      log('Error downloading PDF: $e');
      setState(() {
        _isDownloading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Failed to download PDF. Please check your connection and retry.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: cButtonGreen,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title ?? 'Invoice',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: _shareViaGeneral,
            tooltip: 'Share',
          ),
        ],
      ),
      body: SafeArea(
        child: _isDownloading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value: _downloadProgress,
                              strokeWidth: 6,
                              backgroundColor: Colors.grey[300],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(cButtonGreen),
                            ),
                          ),
                          Text(
                            '${(_downloadProgress * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: cButtonGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Downloading PDF...',
                      style: TextStyle(
                        color: cButtonGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please wait',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            : _localPdfPath == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load PDF',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please check your connection',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _downloadAndViewPdf,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cButtonGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : _pdfController == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: cButtonGreen,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Loading PDF...',
                              style: TextStyle(
                                color: cButtonGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : PdfView(
                        controller: _pdfController!,
                        scrollDirection: Axis.vertical,
                        pageSnapping: true,
                        physics: const BouncingScrollPhysics(),
                        onDocumentError: (error) {
                          log('PDF View Error: $error');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Error viewing PDF: ${error.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        onPageChanged: (page) {
                          log('Page changed to: $page');
                        },
                      ),
      ),
    );
  }

  /// General share - shares the actual PDF file
  Future<void> _shareViaGeneral() async {
    if (_localPdfPath == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF not downloaded yet. Please wait...'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      final XFile pdfFile = XFile(_localPdfPath!);
      final String message =
          'Invoice${widget.orderNumber != null ? " for Order #${widget.orderNumber}" : ""}';

      await Share.shareXFiles(
        [pdfFile],
        text: message,
        subject: widget.title ?? 'Invoice',
      );
    } catch (e) {
      log('Error sharing PDF file: $e');
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
