import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class AuthHeaderTitle extends StatelessWidget {
  const AuthHeaderTitle({
    super.key,
    required this.mainTitle,
    required this.subTitle,
  });

  final String mainTitle;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          mainTitle,
          style: AppStyles.styleSemiBold22(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12.0),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: AppStyles.styleRegular14(
            context,
          ).copyWith(color: AppColors.subTextColor, height: 1.8),
        ),
      ],
    );
  }
}
