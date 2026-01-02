import 'package:flutter/material.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.backgroundColor,
    this.textColor,
    required this.onPress,
    this.enabled = true,
    required this.title,
  });

  final VoidCallback? onPress;
  final Color? backgroundColor, textColor;
  final bool enabled;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: enabled ? kGradientButton : null,
        color: enabled ? null : Colors.grey[300],
        borderRadius: BorderRadius.circular(50),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: Colors.grey.withAlpha(150),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: enabled ? 4 : 0,
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
        ),
        onPressed: enabled ? onPress : null,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: AppStyles.styleBold16(context).copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
