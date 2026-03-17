import 'package:flutter/material.dart';
import 'package:representative_app/core/helpers/custom_fading_widget.dart';

class DropdownLoadingIndicator extends StatelessWidget {
  const DropdownLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // ----- Icon placeholder -----
          CustomFadingWidget.circle(radius: 10),

          const SizedBox(width: 10),

          // ----- Text placeholder -----
          Expanded(child: CustomFadingWidget.line(height: 14, radius: 6)),

          const SizedBox(width: 8),

          // ----- Arrow icon placeholder -----
          CustomFadingWidget.circle(radius: 10),
        ],
      ),
    );
  }
}
