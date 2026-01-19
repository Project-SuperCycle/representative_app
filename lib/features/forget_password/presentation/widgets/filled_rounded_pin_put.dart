import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class FilledRoundedPinPut extends StatefulWidget {
  final TextEditingController controller;
  const FilledRoundedPinPut({super.key, required this.controller});

  @override
  FilledRoundedPinPutState createState() => FilledRoundedPinPutState();
}

class FilledRoundedPinPutState extends State<FilledRoundedPinPut> {
  final focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    const length = 6;
    const borderColor = AppColors.primaryColor;
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, 0.75);

    final defaultPinTheme = PinTheme(
      width: 55,
      height: 60,
      textStyle: AppStyles.styleBold16(context),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return SizedBox(
      height: 68,
      child: Directionality(
        textDirection: TextDirection.ltr, // Force LTR for pin input
        child: Pinput(
          length: length,
          controller: widget.controller,
          focusNode: focusNode,
          defaultPinTheme: defaultPinTheme,
          onCompleted: (pin) {
            setState(() => showError = pin != '5555');
          },
          focusedPinTheme: defaultPinTheme.copyWith(
            height: 68,
            width: 64,
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(color: borderColor),
            ),
          ),
          errorPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              color: errorColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
