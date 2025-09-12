import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

/// PhotoPickerUtil - A Google Play compliant photo picker utility
/// This uses image_picker which doesn't require READ_MEDIA_IMAGES permission
class PhotoPickerUtil {
  static final ImagePicker _picker = ImagePicker();

  /// Pick a single image from gallery
  /// Uses system picker which doesn't require media permissions
  static Future<File?> pickSingleImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Pick multiple images from gallery
  /// Uses system picker which doesn't require media permissions
  static Future<List<File>?> pickMultipleImages({int maxImages = 5}) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        // Limit to maxImages
        final limitedImages = images.take(maxImages).toList();
        return limitedImages.map((xFile) => File(xFile.path)).toList();
      }
      return null;
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
      return null;
    }
  }

  /// Pick image from camera
  /// Camera permission is allowed by Google Play for direct camera access
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }

  /// Show a dialog to choose between camera and gallery
  static Future<File?> showImageSourceDialog(BuildContext context) async {
    return await showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await pickSingleImage();
                  if (context.mounted) {
                    Navigator.pop(context, file);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await pickImageFromCamera();
                  if (context.mounted) {
                    Navigator.pop(context, file);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Check if the picked file is a valid image
  static bool isValidImageFile(File file) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    final fileName = file.path.toLowerCase();
    return validExtensions.any((ext) => fileName.endsWith(ext));
  }

  /// Get file size in MB
  static double getFileSizeInMB(File file) {
    int fileSizeInBytes = file.lengthSync();
    return fileSizeInBytes / (1024 * 1024);
  }

  /// Validate file size (default max 5MB)
  static bool isValidFileSize(File file, {double maxSizeMB = 5.0}) {
    return getFileSizeInMB(file) <= maxSizeMB;
  }
}
