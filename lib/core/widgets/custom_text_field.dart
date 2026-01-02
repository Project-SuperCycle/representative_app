import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final IconData? icon;
  final String? Function(String?)? validator;
  final bool isArabic;
  final bool enabled;
  final Widget? child;
  final Color? borderColor;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.icon,
    this.validator,
    required this.isArabic,
    this.enabled = true,
    this.child,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.styleSemiBold14(context)),
        const SizedBox(height: 12),
        if (child != null) ...[child!, const SizedBox(height: 10)],
        TextFormField(
          style: AppStyles.styleRegular14(context),
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          enabled: enabled,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null
                ? Icon(icon, color: const Color(0xFF3BC577))
                : null,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor ?? Colors.grey.shade300,
                width: (borderColor == null) ? 1 : 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green.shade300, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
