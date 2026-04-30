import 'package:flutter/material.dart';
import 'package:representative_app/core/constants.dart';
import 'package:representative_app/core/helpers/custom_fading_widget.dart';

class FinanceTransactionLoadingCard extends StatelessWidget {
  const FinanceTransactionLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3BC577).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // ── Row 1: Icon + ID + Status ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomFadingWidget.box(
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.circular(10),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFadingWidget.line(width: 120, height: 14),
                      const SizedBox(height: 6),
                      CustomFadingWidget.line(width: 80, height: 11),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                CustomFadingWidget.box(
                  width: 64,
                  height: 26,
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200, thickness: 0.5),
            const SizedBox(height: 10),

            // ── Row 2: Payment Method + Total Weight ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFadingWidget.line(width: 80, height: 11),
                      const SizedBox(height: 6),
                      CustomFadingWidget.line(width: 96, height: 16),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomFadingWidget.line(width: 80, height: 11),
                    const SizedBox(height: 6),
                    CustomFadingWidget.line(width: 64, height: 18),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Row 3: Total Amount ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF3BC577).withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF3BC577).withValues(alpha: 0.15),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomFadingWidget.line(width: 110, height: 20),
                  CustomFadingWidget.line(width: 80, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
