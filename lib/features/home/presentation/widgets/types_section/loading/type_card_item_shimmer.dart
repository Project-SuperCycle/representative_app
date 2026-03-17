import 'package:flutter/material.dart';
import 'package:representative_app/core/helpers/custom_fading_widget.dart';

class TypeCardItemShimmer extends StatelessWidget {
  const TypeCardItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(100),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ======== IMAGE SECTION SHIMMER ========
          Stack(
            children: [
              // Main image placeholder
              CustomFadingWidget.box(
                height: 120,
                width: double.infinity,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              // Icon badge placeholder (top-right)
              Positioned(
                top: 10,
                right: 10,
                child: CustomFadingWidget.circle(radius: 16),
              ),
            ],
          ),

          // ======== CONTENT SECTION SHIMMER ========
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // ----- Title placeholder -----
                CustomFadingWidget.line(
                  width: double.infinity,
                  height: 18,
                  radius: 6,
                ),
                const SizedBox(height: 6),
                CustomFadingWidget.line(width: 120, height: 14, radius: 6),

                // ----- Price container placeholder -----
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(30),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                // ----- Button placeholder -----
                CustomFadingWidget.box(
                  height: 44,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
