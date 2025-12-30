import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// High-performance network image widget with disk and memory caching
/// Uses cached_network_image for superior performance and reliability
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
    // Calculate safe cache dimensions
    int? safeCacheWidth = memCacheWidth;
    int? safeCacheHeight = memCacheHeight;

    // Only auto-calculate if width/height are finite and valid
    if (safeCacheWidth == null &&
        width != null &&
        width!.isFinite &&
        width! > 0) {
      safeCacheWidth = (width! * 2).toInt();
    }
    if (safeCacheHeight == null &&
        height != null &&
        height!.isFinite &&
        height! > 0) {
      safeCacheHeight = (height! * 2).toInt();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      cacheKey: cacheKey,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,

      // Memory cache settings
      memCacheWidth: safeCacheWidth,
      memCacheHeight: safeCacheHeight,

      // Disk cache settings
      maxWidthDiskCache: maxWidthDiskCache ?? 1000,
      maxHeightDiskCache: maxHeightDiskCache ?? 1000,

      // Fade animations for smooth transitions
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 200),
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 100),

      // Custom image builder if provided
      imageBuilder: imageBuilder,

      // Minimal placeholder for fast display
      placeholder: placeholder ??
          (context, url) => Container(
                width: width,
                height: height,
                color: Colors.grey[50],
                child: const SizedBox.shrink(),
              ),

      // Error widget
      errorWidget: errorWidget ??
          (context, url, error) => Container(
                width: width,
                height: height,
                color: Colors.grey[100],
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ),

      // Performance optimizations
      filterQuality: FilterQuality.high,
      useOldImageOnUrlChange: false, // Show new image immediately
      fadeInCurve: Curves.easeIn,
      fadeOutCurve: Curves.easeOut,
    );
  }
}
