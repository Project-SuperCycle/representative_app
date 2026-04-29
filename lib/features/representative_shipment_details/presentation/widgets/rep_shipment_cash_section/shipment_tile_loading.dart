import 'package:flutter/material.dart';
import 'package:representative_app/core/helpers/custom_fading_widget.dart';

class ShipmentTileLoading extends StatelessWidget {
  const ShipmentTileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Checkbox placeholder
            CustomFadingWidget.box(
              width: 22,
              height: 22,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(width: 12),

            // Icon placeholder
            CustomFadingWidget.box(
              width: 28,
              height: 28,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(width: 10),

            // Shipment number placeholder
            Expanded(child: CustomFadingWidget.line(height: 14)),
            const SizedBox(width: 12),

            // Amount chip placeholder
            CustomFadingWidget.box(
              width: 80,
              height: 28,
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
      ),
    );
  }
}
