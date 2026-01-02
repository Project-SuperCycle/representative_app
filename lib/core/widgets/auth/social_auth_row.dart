import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/cubits/social_auth/social_auth_cubit.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/models/social_auth_request_model.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/services/social_auth_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';

class SocialAuthRow extends StatelessWidget {
  const SocialAuthRow({super.key});

  void signInWithGoogle({required BuildContext context}) async {
    try {
      // إظهار مؤشر التحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final accessToken = await SocialAuthService.signInWithGoogle();

      // إغلاق مؤشر التحميل
      if (context.mounted) Navigator.of(context).pop();

      final SocialAuthRequestModel credentials = SocialAuthRequestModel(
        provider: "google",
        accessToken: accessToken,
      );

      if (context.mounted) {
        BlocProvider.of<SocialAuthCubit>(context).socialAuth(credentials);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        CustomSnackBar.showError(context, 'فشل تسجيل الدخول: ${e.toString()}');
      }
    }
  }

  void signInWithFacebook({required BuildContext context}) async {
    try {
      // إظهار مؤشر التحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final accessToken = await SocialAuthService.signInWithFacebook();

      // إغلاق مؤشر التحميل
      if (context.mounted) Navigator.of(context).pop();

      final SocialAuthRequestModel credentials = SocialAuthRequestModel(
        provider: "facebook",
        accessToken: accessToken,
      );

      if (context.mounted) {
        BlocProvider.of<SocialAuthCubit>(context).socialAuth(credentials);
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
    return BlocConsumer<SocialAuthCubit, SocialAuthState>(
      listener: (context, state) {
        if (state is SocialAuthSuccess) {
          CustomSnackBar.showSuccess(
            context,
            state.socialAuth.message ?? "NO MESSAGE",
          );

          if (state.socialAuth.status == 201) {
            GoRouter.of(context).push(EndPoints.signUpDetailsView);
          } else if (state.socialAuth.status == 200) {
            GoRouter.of(context).pushReplacement(EndPoints.homeView);
          }
        }
        if (state is SocialAuthFailure) {
          CustomSnackBar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              style: IconButton.styleFrom(padding: EdgeInsets.all(2.0)),
              onPressed: () => signInWithGoogle(context: context),
              icon: Image.asset(AppAssets.googleIcon, scale: 3.2),
            ),
            SizedBox(width: 30),
            IconButton(
              style: IconButton.styleFrom(padding: EdgeInsets.all(2.0)),
              onPressed: () => signInWithFacebook(context: context),
              icon: Image.asset(AppAssets.facebookIcon, scale: 3.5),
            ),
          ],
        );
      },
    );
  }
}
