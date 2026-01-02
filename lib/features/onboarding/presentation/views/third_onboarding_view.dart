import 'package:flutter/material.dart';
import 'package:supercycle/features/onboarding/presentation/widgets/third_onboarding_view_body.dart'
    show ThirdOnboardingViewBody;

class ThirdOnboardingView extends StatelessWidget {
  const ThirdOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const ThirdOnboardingViewBody());
  }
}
