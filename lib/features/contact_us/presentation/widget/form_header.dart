import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/utils/contact_strings.dart';

class FormHeader extends StatelessWidget {
  final bool isArabic;

  const FormHeader({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.green.shade50),
          child: Icon(
            Icons.contact_support,
            size: 30,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            ContactStrings.get('headerTitle', isArabic),
            style: AppStyles.styleSemiBold24(context),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            ContactStrings.get('headerSubtitle', isArabic),
            style: AppStyles.styleMedium16(
              context,
            ).copyWith(color: AppColors.subTextColor),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
