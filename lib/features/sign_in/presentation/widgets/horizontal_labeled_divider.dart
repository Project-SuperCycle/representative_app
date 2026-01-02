import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/generated/l10n.dart';

class HorizontalLabeledDivider extends StatelessWidget {
  const HorizontalLabeledDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              S.of(context).or_register_via,
              style: AppStyles.styleMedium16(
                context,
              ).copyWith(color: AppColors.mainTextColor),
            ),
          ),
          Expanded(child: Container(height: 1, color: AppColors.primaryColor)),
        ],
      ),
    );
  }
}
