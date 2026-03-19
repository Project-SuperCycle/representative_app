import 'package:flutter/material.dart';
import 'package:representative_app/core/helpers/custom_fading_widget.dart';
import 'package:representative_app/core/utils/app_colors.dart';

class ShipmentsHistoryLoadingIndicator extends StatelessWidget {
  const ShipmentsHistoryLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 12),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _ShipmentCardShimmer(index: index),
      ),
    );
  }
}

// ── Single shimmer card ───────────────────────────────────────────────────────
class _ShipmentCardShimmer extends StatelessWidget {
  const _ShipmentCardShimmer({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ======== Row 1: shipment number + time badge ========
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // رقم الشحنة
                    CustomFadingWidget(
                      duration: Duration(milliseconds: 900 + (index * 80)),
                      child: CustomFadingWidget.line(
                        width: 160,
                        height: 16,
                        radius: 5,
                      ),
                    ),

                    // Time badge
                    CustomFadingWidget(
                      duration: Duration(milliseconds: 920 + (index * 80)),
                      child: CustomFadingWidget.box(
                        width: 70,
                        height: 30,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // ======== Divider ========
                Divider(
                  color: Colors.grey.shade200,
                  thickness: 1.5,
                  indent: 10,
                  endIndent: 10,
                ),

                const SizedBox(height: 5),

                // ======== Row 2: الكمية ========
                CustomFadingWidget(
                  duration: Duration(milliseconds: 940 + (index * 80)),
                  child: CustomFadingWidget.line(
                    width: 120,
                    height: 14,
                    radius: 4,
                  ),
                ),

                const SizedBox(height: 12),

                // ======== Row 3: العنوان ========
                CustomFadingWidget(
                  duration: Duration(milliseconds: 960 + (index * 80)),
                  child: CustomFadingWidget.line(
                    width: double.infinity,
                    height: 14,
                    radius: 4,
                  ),
                ),

                const SizedBox(height: 12),

                // ======== Row 4: الحالة ========
                CustomFadingWidget(
                  duration: Duration(milliseconds: 980 + (index * 80)),
                  child: CustomFadingWidget.line(
                    width: 100,
                    height: 14,
                    radius: 4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ======== Bottom button placeholder ========
          CustomFadingWidget(
            duration: Duration(milliseconds: 1000 + (index * 80)),
            child: Container(
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withAlpha(80),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
