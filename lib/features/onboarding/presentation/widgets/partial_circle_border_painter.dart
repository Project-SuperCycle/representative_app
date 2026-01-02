import 'package:flutter/material.dart';

class PartialCircleBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double percentage; // 0.0 to 1.0 (e.g., 0.25 = 25%)
  final double startAngle; // Starting angle in radians

  PartialCircleBorderPainter({
    required this.color,
    required this.strokeWidth,
    this.percentage = 0.25,
    this.startAngle = -90 * (3.14159 / 180), // Start from top (-90 degrees)
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Calculate sweep angle (percentage of full circle)
    final sweepAngle = 2 * 3.14159 * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
