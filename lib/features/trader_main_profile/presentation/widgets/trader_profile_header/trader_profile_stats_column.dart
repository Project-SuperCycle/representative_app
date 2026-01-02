import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class TraderProfileStatsColumn extends StatelessWidget {
  const TraderProfileStatsColumn({
    super.key,
    required this.number,
    required this.label,
  });

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number,
          style: AppStyles.styleSemiBold24(context).copyWith(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppStyles.styleSemiBold12(context).copyWith(
            fontWeight: FontWeight.bold,
            height: 1.6,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
