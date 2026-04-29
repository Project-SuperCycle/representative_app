import 'package:flutter/material.dart';
import 'package:representative_app/core/widgets/shipment/expandable_section.dart';

class ExpandableCard extends StatelessWidget {
  final String title;
  final String icon;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget content;
  final double maxHeight;
  const ExpandableCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isExpanded,
    required this.onTap,
    required this.content,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? Colors.green.shade200 : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? Colors.green.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpandableSection(
        title: title,
        iconPath: icon,
        isExpanded: isExpanded,
        maxHeight: maxHeight,
        onTap: onTap,
        content: content,
      ),
    );
  }
}
