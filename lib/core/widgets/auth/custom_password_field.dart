import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/utils/input_decorations.dart'
    show InputDecorations;
import 'package:supercycle/generated/l10n.dart' show S;

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,
    required this.labelText,
    this.controller,
    this.validator,
    this.onChanged,
    this.activeValidator = true,
  });
  final bool activeValidator;
  final String labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: widget.controller,
        obscureText: isVisible,
        validator: (value) {
          return widget.activeValidator
              ? validatePassword(context, value!)
              : null;
        },
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: AppStyles.styleRegular14(
            context,
          ).copyWith(color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              size: 20,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
          ),
          enabledBorder: InputDecorations.enabledBorder(),
          focusedBorder: InputDecorations.focusedBorder(),
          errorBorder: InputDecorations.errorBorder(),
          focusedErrorBorder: InputDecorations.errorBorder(),
        ),
      ),
    );
  }
}

String? validatePassword(BuildContext context, String password) {
  if (password.isEmpty) {
    return S.of(context).password_required;
  }
  if (password.length < 8) {
    return S.of(context).password_length_error;
  }
  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return S.of(context).password_uppercase_error;
  }
  if (!RegExp(r'[a-z]').hasMatch(password)) {
    return S.of(context).password_lowercase_error;
  }
  if (!RegExp(r'\d').hasMatch(password)) {
    return S.of(context).password_number_error;
  }
  if (!RegExp(r'[#!@$%^&*_]').hasMatch(password)) {
    return S.of(context).password_specialChar_error;
  }
  return null;
}
