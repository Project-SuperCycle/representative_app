import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/utils/input_decorations.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.bottomMargin = 12,
    this.keyboardType = TextInputType.text,
  });

  final String labelText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final double bottomMargin;
  final bool enabled;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: TextFormField(
        style: AppStyles.styleRegular14(context),
        enabled: enabled,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        autofocus: false,
        focusNode: FocusNode(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        minLines: 1,
        maxLines: null,
        controller: controller,
        validator: (value) => validateField(value, fieldName: labelText),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: AppStyles.styleRegular14(
            context,
          ).copyWith(color: Colors.grey),
          suffixIcon: suffixIcon,
          enabledBorder: InputDecorations.enabledBorder(),
          disabledBorder: InputDecorations.enabledBorder(),
          focusedBorder: InputDecorations.focusedBorder(),
          errorBorder: InputDecorations.errorBorder(),
          focusedErrorBorder: InputDecorations.errorBorder(),
        ),
      ),
    );
  }

  String? validateField(String? value, {String fieldName = 'الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب ';
    }
    return null;
  }
}
