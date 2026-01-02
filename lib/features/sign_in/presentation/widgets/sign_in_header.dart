import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/generated/l10n.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          child: Text(
            S.of(context).signIn_title,
            style: AppStyles.styleSemiBold24(context),
          ),
        ),
        const SizedBox(height: 30),
        FittedBox(
          child: Text(
            S.of(context).signIn_subTitle,
            style: AppStyles.styleMedium18(context),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
