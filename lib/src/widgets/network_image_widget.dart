import 'package:flutter/material.dart';

/// A replacement for CachedNetworkImage that uses simple Image.network
/// This ensures no media permissions are required
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
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        if (placeholder != null) {
          return placeholder!(context, imageUrl);
        }

        // Default loading indicator
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        if (errorWidget != null) {
          return errorWidget!(context, imageUrl, error);
        }

        // Default error widget
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(
            Icons.error,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
