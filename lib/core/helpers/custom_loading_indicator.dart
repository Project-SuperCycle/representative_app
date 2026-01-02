import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:supercycle/core/utils/app_colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60.0,
        width: 60.0,
        child: LoadingIndicator(
          indicatorType: Indicator.ballRotateChase,
          colors: [color ?? AppColors.primaryColor],
          strokeWidth: 1,
        ),
      ),
    );
  }
}
