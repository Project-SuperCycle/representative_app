import 'package:flutter/material.dart';
import 'package:supercycle/features/sign_up/presentation/widgets/sign_up_verify_view_body.dart';

class SignUpVerifyView extends StatelessWidget {
  final String credential;
  const SignUpVerifyView({super.key, required this.credential});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SignUpVerifyViewBody(credential: credential));
  }
}
