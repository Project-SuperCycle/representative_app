import 'package:flutter/material.dart';
import 'package:supercycle/core/widgets/navbar/custom_curved_navigation_bar.dart';
import 'package:supercycle/features/calculator/presentation/widget/calculator_view_body.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalculatorViewBody(),
      bottomNavigationBar: CustomCurvedNavigationBar(currentIndex: 0),
    );
  }
}
