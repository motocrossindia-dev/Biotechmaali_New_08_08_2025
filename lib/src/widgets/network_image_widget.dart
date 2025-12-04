import 'package:flutter/material.dart';

/// Ultra-fast network image widget with instant display
/// Uses Flutter's built-in Image.network with aggressive caching
class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Widget Function(BuildContext, ImageProvider)? imageBuilder;
  final Duration? fadeInDuration;
  final Duration? fadeOutDuration;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final String? cacheKey;
  final BoxFit? fit;
  final double? width;
  final double? height;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.placeholder,
    this.errorWidget,
    this.imageBuilder,
    this.fadeInDuration,
    this.fadeOutDuration,
    this.memCacheWidth,
    this.memCacheHeight,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.cacheKey,
    this.fit,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (imageBuilder != null) {
      return imageBuilder!(context, NetworkImage(imageUrl));
    }

    return Image.network(
      imageUrl,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      // Instant display - no fade animation
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        if (placeholder != null) {
          return placeholder!(context, imageUrl);
        }
        // Minimal placeholder for fast loading
        return Container(
          width: width,
          height: height,
          color: Colors.grey[100],
        );
      },
      errorBuilder: (context, error, stackTrace) {
        if (errorWidget != null) {
          return errorWidget!(context, imageUrl, error);
        }
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(
            Icons.broken_image_outlined,
            color: Colors.grey,
            size: 24,
          ),
        );
      },
      // Enable caching with specified dimensions
      cacheWidth: memCacheWidth,
      cacheHeight: memCacheHeight,
      // Use medium quality for balance between speed and quality
      filterQuality: FilterQuality.medium,
      // Enable anti-aliasing for smoother images
      isAntiAlias: true,
      // Load images as soon as possible
      loadingBuilder: null, // Don't use loading builder for faster display
    );
  }
}
