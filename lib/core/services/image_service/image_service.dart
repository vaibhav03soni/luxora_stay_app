import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ImageService {
  static Widget banner({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return _buildImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      placeholder: _buildShimmer(width, height, borderRadius),
    );
  }

  static Widget hotel({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return _buildImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      placeholder: _buildShimmer(width, height, borderRadius),
      errorWidget: const Icon(Icons.hotel, size: 40, color: Colors.grey),
    );
  }

  static Widget destination({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return _buildImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      placeholder: _buildShimmer(width, height, borderRadius),
      errorWidget: const Icon(Icons.map, size: 40, color: Colors.grey),
    );
  }

  static Widget room({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return _buildImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      placeholder: _buildShimmer(width, height, borderRadius),
      errorWidget: const Icon(Icons.single_bed, size: 40, color: Colors.grey),
    );
  }

  static Widget profile({
    required String? imageUrl,
    double size = 40,
  }) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.grey[200],
        child: Icon(Icons.person, size: size * 0.6, color: Colors.grey),
      );
    }
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: CachedNetworkImageProvider(imageUrl),
    );
  }

  static Widget _buildImage({
    required String imageUrl,
    double? width,
    double? height,
    required BoxFit fit,
    BorderRadius? borderRadius,
    required Widget placeholder,
    Widget? errorWidget,
  }) {
    Widget image;

    if (imageUrl.startsWith('http')) {
      image = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => errorWidget ?? const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    } else {
      // Local asset
      image = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => errorWidget ?? const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius, child: image);
    }
    return image;
  }

  static Widget _buildShimmer(double? width, double? height, BorderRadius? borderRadius) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
      ),
    );
  }
}
