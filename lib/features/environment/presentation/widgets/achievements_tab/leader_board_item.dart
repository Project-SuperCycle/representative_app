import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class LeaderBoardItem extends StatelessWidget {
  final String rank;
  final String name;
  final String points;
  final Color color;
  final bool isHighlighted;
  const LeaderBoardItem({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    required this.color,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFFD1FAE5) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted
            ? Border.all(color: AppColors.primaryColor, width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                rank,
                style: AppStyles.styleBold14(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppStyles.styleSemiBold14(context)),
                SizedBox(height: 4),
                Text(
                  points,
                  style: AppStyles.styleMedium12(
                    context,
                  ).copyWith(color: AppColors.subTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
