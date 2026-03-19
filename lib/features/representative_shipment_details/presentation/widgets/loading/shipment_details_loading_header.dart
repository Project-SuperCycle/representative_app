import 'package:flutter/material.dart';
import 'package:representative_app/core/helpers/custom_fading_widget.dart';

class ShipmentDetailsLoadingHeader extends StatelessWidget {
  const ShipmentDetailsLoadingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ======== Left column: shipment number + status + date ========
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----- Shipment number row: icon + number -----
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Box icon placeholder
                  CustomFadingWidget.box(
                    width: 25,
                    height: 25,
                    borderRadius: BorderRadius.circular(4),
                  ),

                  const SizedBox(width: 10),

                  // Shipment number placeholder
                  CustomFadingWidget.line(width: 120, height: 18, radius: 6),
                ],
              ),

              const SizedBox(height: 12),

              // ----- Status placeholder -----
              Align(
                alignment: Alignment.center,
                child: CustomFadingWidget(
                  duration: const Duration(milliseconds: 950),
                  child: CustomFadingWidget.line(
                    width: 120,
                    height: 15,
                    radius: 5,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ----- Date row: label + value -----
              Row(
                children: [
                  CustomFadingWidget(
                    duration: const Duration(milliseconds: 980),
                    child: CustomFadingWidget.line(
                      width: 60,
                      height: 15,
                      radius: 5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  CustomFadingWidget(
                    duration: const Duration(milliseconds: 1010),
                    child: CustomFadingWidget.line(
                      width: 120,
                      height: 15,
                      radius: 5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Spacer(),

        // ======== Right: image gallery placeholder ========
        CustomFadingWidget(
          duration: const Duration(milliseconds: 920),
          child: CustomFadingWidget.box(
            width: 80,
            height: 100,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}
