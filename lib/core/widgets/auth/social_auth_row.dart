import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/core/helpers/custom_loading_indicator.dart';
import 'package:representative_app/core/helpers/custom_snack_bar.dart';
import 'package:representative_app/core/models/social_auth_request_model.dart';
import 'package:representative_app/core/services/social_auth_services.dart';
import 'package:representative_app/core/utils/app_assets.dart';
import 'package:representative_app/features/sign_in/data/cubits/sign-in-cubit/sign_in_cubit.dart';
import 'package:representative_app/features/sign_in/data/cubits/sign-in-cubit/sign_in_state.dart';

class SocialAuthRow extends StatelessWidget {
  const SocialAuthRow({super.key});

  void signInWithGoogle({required BuildContext context}) async {
    try {
      // إظهار مؤشر التحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CustomLoadingIndicator()),
      );

      final accessToken = await SocialAuthService.signInWithGoogle();

      // إغلاق مؤشر التحميل
      if (context.mounted) Navigator.of(context).pop();

      final SocialAuthRequestModel credentials = SocialAuthRequestModel(
        provider: "google",
        accessToken: accessToken,
      );

      if (context.mounted) {
        BlocProvider.of<SignInCubit>(context).socialAuth(credentials);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        CustomSnackBar.showError(context, 'فشل تسجيل الدخول: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              style: IconButton.styleFrom(padding: EdgeInsets.all(2.0)),
              onPressed: () => signInWithGoogle(context: context),
              icon: Image.asset(AppAssets.googleIcon, scale: 3.2),
            ),
          ],
        );
      },
    );
  }
}
