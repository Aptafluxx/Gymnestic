import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class DashedCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.grayDark
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Define the bezier curve path
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.7,
      size.width,
      size.height * 0.4,
    );

    // Apply dash effect
    const double dashWidth = 5.0;
    const double dashSpace = 5.0;
    double distance = 0.0;

    for (ui.PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final extractPath = pathMetric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }

    // Draw the glowing dot on the curve
    final dotPaint = Paint()
      ..color = AppColors.primaryRed
      ..style = PaintingStyle.fill;

    // Position of the dot (approx 20% along the width)
    final dotCenter = Offset(size.width * 0.3, size.height * 0.69);

    // Glow effect
    final glowPaint = Paint()
      ..color = AppColors.primaryRed.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    canvas.drawCircle(dotCenter, 12, glowPaint);
    canvas.drawCircle(dotCenter, 6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
