import 'package:flutter/material.dart';
import 'package:supercycle/features/forget_password/presentation/widgets/verify_reset_otp_view_body.dart';

class VerifyResetOtpView extends StatelessWidget {
  const VerifyResetOtpView({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: VerifyResetOtpViewBody(email: email));
  }
}
