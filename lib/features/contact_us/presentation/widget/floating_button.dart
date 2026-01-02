import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';

class FloatingButton extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onPressed;

  const FloatingButton({
    super.key,
    required this.isArabic,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.primaryColor,
      tooltip: isArabic ? "إرسال" : "Submit",
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Image.asset(
          AppAssets.whatsappIcon,
          fit: BoxFit.cover,
          color: Colors.white,
        ),
      ),
    );
  }
}
