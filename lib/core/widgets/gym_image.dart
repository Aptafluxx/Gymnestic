import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GymImage extends StatelessWidget {
  const GymImage({
    required this.url,
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: AppColors.cardDark,
        alignment: Alignment.center,
        child: const Icon(Icons.fitness_center, color: AppColors.grayLight),
      ),
    );
    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
