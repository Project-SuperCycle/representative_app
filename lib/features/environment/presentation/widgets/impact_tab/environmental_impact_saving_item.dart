import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class EnvironmentalImpactSavingItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String description;
  final double progress;
  final Color progressColor;

  const EnvironmentalImpactSavingItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.description,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 25),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(value, style: AppStyles.styleSemiBold14(context)),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  description,
                  style: AppStyles.styleMedium12(
                    context,
                  ).copyWith(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: progressColor.withAlpha(50),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                borderRadius: BorderRadius.circular(10),
                minHeight: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
