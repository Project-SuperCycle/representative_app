import 'package:flutter/material.dart';
import 'package:supercycle/features/forget_password/presentation/widgets/reset_password_view_body.dart';

class ResetPasswordView extends StatelessWidget {
  final String token;
  const ResetPasswordView({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ResetPasswordViewBody(token: token));
  }
}
