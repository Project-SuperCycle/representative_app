import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/routes/end_points.dart' show EndPoints;
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/generated/l10n.dart';

class SignUpActionRow extends StatelessWidget {
  final VoidCallback onSignUp;
  const SignUpActionRow({super.key, required this.onSignUp});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: kGradientButton,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(150),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 12,
                ),
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
              onPressed: onSignUp,
              child: Icon(Icons.arrow_back, size: 20, color: Colors.white),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              GoRouter.of(context).push(EndPoints.signInView);
            },
            child: Text(
              S.of(context).already_have_an_account,
              style: AppStyles.styleMedium16(
                context,
              ).copyWith(color: AppColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
