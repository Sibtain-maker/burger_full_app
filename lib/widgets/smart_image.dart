import 'package:flutter/material.dart';

/// A smart image widget that automatically determines whether to load from network or assets
/// based on the image path provided
class SmartImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const SmartImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit,
    this.errorWidget,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the image path is a URL (network image)
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: loadingWidget != null 
            ? (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return loadingWidget!;
              }
            : null,
        errorBuilder: errorWidget != null
            ? (context, error, stackTrace) => errorWidget!
            : (context, error, stackTrace) => Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey[600],
                  size: (height != null && height! < 50) ? height! * 0.5 : 24,
                ),
              ),
      );
    } else {
      // Local asset image
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorWidget != null
            ? (context, error, stackTrace) => errorWidget!
            : (context, error, stackTrace) => Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey[600],
                  size: (height != null && height! < 50) ? height! * 0.5 : 24,
                ),
              ),
      );
    }
  }
}