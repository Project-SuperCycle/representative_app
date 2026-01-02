import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class BadgeItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String sublabel;
  final bool isUnlocked;
  const BadgeItem({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.sublabel,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.5,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: isUnlocked
                  ? LinearGradient(
                      colors: [color, color.withAlpha(250)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isUnlocked ? null : Colors.grey[300],
              shape: BoxShape.circle,
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: color.withAlpha(100),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: isUnlocked ? Colors.white : Colors.grey[500],
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppStyles.styleSemiBold12(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            sublabel,
            style: AppStyles.styleSemiBold12(
              context,
            ).copyWith(color: AppColors.subTextColor, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
