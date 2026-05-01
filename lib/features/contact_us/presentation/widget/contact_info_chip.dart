import 'package:flutter/material.dart';
import 'package:representative_app/core/utils/app_colors.dart';
import 'package:representative_app/core/utils/app_styles.dart';

class ContactInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfoChip({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 16),
            const SizedBox(width: 8),
            Text(
              text,
              style: AppStyles.styleSemiBold14(
                context,
              ).copyWith(color: AppColors.subTextColor),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
