import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/utils/photo_picker_util.dart';

/// Example widget showing how to use the Google Play compliant photo picker
/// This can be used in profile screens, product upload, or anywhere image selection is needed
class ExamplePhotoPickerWidget extends StatefulWidget {
  const ExamplePhotoPickerWidget({super.key});

  @override
  State<ExamplePhotoPickerWidget> createState() =>
      _ExamplePhotoPickerWidgetState();
}

class _ExamplePhotoPickerWidgetState extends State<ExamplePhotoPickerWidget> {
  File? selectedImage;
  bool isLoading = false;

  Future<void> _pickSingleImage() async {
    setState(() => isLoading = true);

    try {
      final File? image = await PhotoPickerUtil.pickSingleImage();

      if (image != null) {
        // Validate image
        if (!PhotoPickerUtil.isValidImageFile(image)) {
          _showErrorMessage('Please select a valid image file');
          return;
        }

        if (!PhotoPickerUtil.isValidFileSize(image, maxSizeMB: 5.0)) {
          _showErrorMessage('Image size should be less than 5MB');
          return;
        }

        setState(() => selectedImage = image);
        _showSuccessMessage('Image selected successfully!');
      }
    } catch (e) {
      _showErrorMessage('Error selecting image: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickMultipleImages() async {
    setState(() => isLoading = true);

    try {
      final List<File>? images =
          await PhotoPickerUtil.pickMultipleImages(maxImages: 3);

      if (images != null && images.isNotEmpty) {
        // For demo, just use the first image
        setState(() => selectedImage = images.first);
        _showSuccessMessage('${images.length} image(s) selected!');
      }
    } catch (e) {
      _showErrorMessage('Error selecting images: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Picker Example'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Selected Image Display
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No image selected',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 24),

            // Loading Indicator
            if (isLoading)
              const CircularProgressIndicator()
            else ...[
              // Pick Single Image Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickSingleImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Pick Single Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Pick Multiple Images Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickMultipleImages,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Pick Multiple Images'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Info Text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✅ Google Play Compliant',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This photo picker uses the system picker and does not require READ_MEDIA_IMAGES permission, making it fully compliant with Google Play policies.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            if (selectedImage != null) ...[
              const SizedBox(height: 16),

              // Image Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Image Info:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                        'Size: ${PhotoPickerUtil.getFileSizeInMB(selectedImage!).toStringAsFixed(2)} MB'),
                    Text('Path: ${selectedImage!.path}'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
