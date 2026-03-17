import 'package:flutter/material.dart';
import 'package:representative_app/core/helpers/custom_fading_widget.dart';
import 'package:representative_app/core/utils/app_colors.dart';

class LineChartLoadingIndicator extends StatelessWidget {
  const LineChartLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ======== LEFT Y-Axis + Bars Area ========
          Expanded(
            child: Row(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // ----- Y-Axis labels (left titles) -----
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    return CustomFadingWidget.line(
                      width: 36,
                      height: 12,
                      radius: 4,
                    );
                  }),
                ),

                const SizedBox(width: 10),

                // ----- Chart area -----
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Fake horizontal grid lines
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (index) {
                          return CustomFadingWidget(
                            duration: Duration(
                              milliseconds: 900 + (index * 80),
                            ),
                            child: Container(
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey.withAlpha(40),
                            ),
                          );
                        }),
                      ),

                      // Fake line curve using CustomPaint
                      Positioned.fill(
                        child: CustomFadingWidget(
                          duration: const Duration(milliseconds: 1100),
                          child: CustomPaint(painter: _FakeLinePainter()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ======== Bottom border ========
          Container(
            height: 3,
            margin: const EdgeInsets.only(left: 46),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withAlpha(50),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(height: 10),

          // ======== X-Axis labels (bottom titles) ========
          Padding(
            padding: const EdgeInsets.only(left: 46),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return CustomFadingWidget.line(
                  width: 28,
                  height: 12,
                  radius: 4,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fake smooth line painter ──────────────────────────────────────────────────
class _FakeLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryColor.withAlpha(60)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryColor.withAlpha(40),
          AppColors.primaryColor.withAlpha(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Static fake curve points (نسب ثابتة تمثل شكل الـ chart)
    final points = [
      Offset(0, size.height * 0.65),
      Offset(size.width * 0.18, size.height * 0.45),
      Offset(size.width * 0.35, size.height * 0.55),
      Offset(size.width * 0.52, size.height * 0.30),
      Offset(size.width * 0.70, size.height * 0.40),
      Offset(size.width * 0.85, size.height * 0.20),
      Offset(size.width, size.height * 0.35),
    ];

    final linePath = Path();
    final fillPath = Path();

    linePath.moveTo(points.first.dx, points.first.dy);
    fillPath.moveTo(points.first.dx, size.height);
    fillPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final cp1 = Offset((points[i].dx + points[i + 1].dx) / 2, points[i].dy);
      final cp2 = Offset(
        (points[i].dx + points[i + 1].dx) / 2,
        points[i + 1].dy,
      );
      linePath.cubicTo(
        cp1.dx,
        cp1.dy,
        cp2.dx,
        cp2.dy,
        points[i + 1].dx,
        points[i + 1].dy,
      );
      fillPath.cubicTo(
        cp1.dx,
        cp1.dy,
        cp2.dx,
        cp2.dy,
        points[i + 1].dx,
        points[i + 1].dy,
      );
    }

    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, paint);

    // Fake dots on points
    final dotPaint = Paint()
      ..color = AppColors.primaryColor.withAlpha(80)
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
