import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class CustomSnackBar {
  // SnackBar للنجاح (أخضر)
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: AppStyles.styleSemiBold14(
            context,
          ).copyWith(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF10B981),

        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // SnackBar للخطأ (أحمر)
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: AppStyles.styleSemiBold14(
            context,
          ).copyWith(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // SnackBar للتحذير (برتقالي)
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: AppStyles.styleSemiBold14(
            context,
          ).copyWith(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFF59E0B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // SnackBar للمعلومات (أزرق)
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: AppStyles.styleSemiBold14(
            context,
          ).copyWith(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // SnackBar مخصص بالكامل
  static void showCustom(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration? duration,
    double? borderRadius,
    TextAlign? textAlign,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                message,
                textAlign: textAlign ?? TextAlign.center,
                style: AppStyles.styleSemiBold14(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
        duration: duration ?? const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
