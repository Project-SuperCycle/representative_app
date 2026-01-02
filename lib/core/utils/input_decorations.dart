import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';

class InputDecorations {
  static const focusColor = AppColors.primaryColor;
  static const errorColor = AppColors.failureColor;

  static InputBorder enabledBorder({
    Color color = Colors.transparent,
    double radius = 12.0,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color),
    );
  }

  static InputBorder focusedBorder({
    Color color = focusColor,
    double radius = 12.0,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color),
    );
  }

  static InputBorder errorBorder({
    Color color = errorColor,
    double radius = 12.0,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color),
    );
  }
}
