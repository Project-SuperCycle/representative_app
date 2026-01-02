import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class SegmentActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Color? backgroundColor;

  const SegmentActionButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: AppStyles.styleBold16(context).copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
