import 'package:flutter/material.dart';
import 'package:supercycle/features/onboarding/presentation/widgets/first_onboarding_view_body.dart'
    show FirstOnboardingViewBody;

class FirstOnboardingView extends StatelessWidget {
  const FirstOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const FirstOnboardingViewBody());
  }
}
