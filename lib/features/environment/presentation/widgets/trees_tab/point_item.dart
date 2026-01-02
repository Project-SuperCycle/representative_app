import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class PointItem extends StatelessWidget {
  final String points;
  final String description;
  const PointItem({super.key, required this.points, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            width: 45,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF059669),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  points,
                  style: AppStyles.styleBold12(
                    context,
                  ).copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            description,
            style: AppStyles.styleSemiBold14(
              context,
            ).copyWith(color: AppColors.subTextColor),
          ),
        ],
      ),
    );
  }
}
