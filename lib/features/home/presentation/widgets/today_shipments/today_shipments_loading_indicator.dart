import 'package:flutter/material.dart';
import 'package:representative_app/core/helpers/custom_fading_widget.dart';

class TodayShipmentsLoadingIndicator extends StatelessWidget {
  const TodayShipmentsLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ======== Decorative circles (نفس الـ real widget) ========
        Positioned(
          top: -30,
          right: -30,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(50),
            ),
          ),
        ),
        Positioned(
          bottom: -20,
          left: -20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(50),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======== Header Shimmer ========
              Row(
                children: [
                  // Icon container placeholder
                  CustomFadingWidget.box(
                    width: 44,
                    height: 44,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  const SizedBox(width: 12),

                  // Title + subtitle placeholders
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFadingWidget.line(
                          width: 100,
                          height: 16,
                          radius: 6,
                        ),
                        const SizedBox(height: 6),
                        CustomFadingWidget.line(
                          width: 140,
                          height: 12,
                          radius: 5,
                        ),
                      ],
                    ),
                  ),

                  // "اليوم" badge placeholder
                  CustomFadingWidget.box(
                    width: 52,
                    height: 30,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ======== Shipment Items Shimmer ========
              ...List.generate(
                2,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _ShipmentItemShimmer(index: index),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Single shimmer shipment item ─────────────────────────────────────────────
class _ShipmentItemShimmer extends StatelessWidget {
  const _ShipmentItemShimmer({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(150), width: 1),
      ),
      child: Row(
        children: [
          // ----- Shipment icon placeholder -----
          CustomFadingWidget(
            duration: Duration(milliseconds: 900 + (index * 120)),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(180),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ----- Shipment info placeholder -----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipment number
                CustomFadingWidget(
                  duration: Duration(milliseconds: 950 + (index * 120)),
                  child: CustomFadingWidget.line(
                    width: 120,
                    height: 14,
                    radius: 5,
                  ),
                ),

                const SizedBox(height: 6),

                // Time + Location row
                Row(
                  children: [
                    // Clock icon placeholder
                    CustomFadingWidget(
                      duration: Duration(milliseconds: 1000 + (index * 120)),
                      child: CustomFadingWidget.circle(radius: 7),
                    ),
                    const SizedBox(width: 4),

                    // Time placeholder
                    CustomFadingWidget(
                      duration: Duration(milliseconds: 1000 + (index * 120)),
                      child: CustomFadingWidget.line(
                        width: 55,
                        height: 11,
                        radius: 4,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Location icon placeholder
                    CustomFadingWidget(
                      duration: Duration(milliseconds: 1050 + (index * 120)),
                      child: CustomFadingWidget.circle(radius: 7),
                    ),
                    const SizedBox(width: 4),

                    // Address placeholder
                    Expanded(
                      child: CustomFadingWidget(
                        duration: Duration(milliseconds: 1050 + (index * 120)),
                        child: CustomFadingWidget.line(height: 11, radius: 4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ----- Arrow icon placeholder -----
          CustomFadingWidget(
            duration: Duration(milliseconds: 1100 + (index * 120)),
            child: CustomFadingWidget.circle(radius: 14),
          ),
        ],
      ),
    );
  }
}
