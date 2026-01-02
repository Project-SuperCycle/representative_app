import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class AuthMainHeader extends StatelessWidget {
  const AuthMainHeader({
    super.key,
    required this.title,
    required this.subTitle,
  });
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          title,
          style: AppStyles.styleSemiBold24(context),
        ),
        SizedBox(height: 30),
        Text(
          textAlign: TextAlign.center,
          subTitle,
          style: AppStyles.styleMedium18(context),
        ),
      ],
    );
  }
}
