import 'package:flutter/material.dart';
import 'package:representative_app/core/utils/app_colors.dart';

class TotalRow extends StatelessWidget {
  final bool hasSelection;
  final double totalSelected;
  const TotalRow({
    super.key,
    required this.hasSelection,
    required this.totalSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasSelection
              ? [const Color(0xFFE8F9F0), const Color(0xFFD0F2E3)]
              : [Colors.grey.shade50, Colors.grey.shade100],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasSelection
              ? AppColors.primaryColor.withValues(alpha: 0.4)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate_rounded,
                color: hasSelection
                    ? AppColors.primaryColor
                    : AppColors.subTextColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'إجمالي التحصيل',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: hasSelection
                      ? AppColors.mainTextColor
                      : AppColors.subTextColor,
                ),
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: Text(
              '${totalSelected.toStringAsFixed(2)} ج.م',
              key: ValueKey(totalSelected),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: hasSelection
                    ? AppColors.primaryColor
                    : AppColors.subTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
