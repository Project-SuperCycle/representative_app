import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/utils/input_decorations.dart'
    show InputDecorations;

class CustomConfirmPassword extends StatefulWidget {
  const CustomConfirmPassword({
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
  State<CustomConfirmPassword> createState() => _CustomConfirmPasswordState();
}

class _CustomConfirmPasswordState extends State<CustomConfirmPassword> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: widget.controller,
        obscureText: isVisible,
        validator: widget.validator,
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
