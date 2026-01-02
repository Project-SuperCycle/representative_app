import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/widgets/auth/custom_password_field.dart';
import 'package:supercycle/core/widgets/custom_button.dart';
import 'package:supercycle/core/widgets/reset_pass/auth_header_title.dart';
import 'package:supercycle/core/widgets/reset_pass/centered_container.dart';
import 'package:supercycle/features/forget_password/data/cubits/forget_password_cubit.dart';
import 'package:supercycle/features/forget_password/data/model/reset_password_model.dart';

class ResetPasswordViewBody extends StatelessWidget {
  final String token;
  ResetPasswordViewBody({super.key, required this.token});

  final _formKey = GlobalKey<FormState>();
  final newPassController = TextEditingController();

  void _updatePassword(BuildContext context) {
    final resetModel = ResetPasswordModel(
      resetToken: token,
      newPassword: newPassController.text.trim(),
    );
    BlocProvider.of<ForgetPasswordCubit>(context).resetPassword(resetModel);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: kGradientBackground),
      width: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.logoName, height: 60),
                  Image.asset(AppAssets.logoIcon, height: 70),
                ],
              ),
              const SizedBox(height: 12),
              _buildFormCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return CenteredContainer(
      children: Column(
        children: [
          SizedBox(height: 10.0),
          AuthHeaderTitle(
            mainTitle: "تغيير كلمة المرور",
            subTitle:
                "أعد تعيين كلمة المرور بكلمة مرور قوية جديدة لحماية حسابك",
          ),
          SizedBox(height: 24),
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          CustomSnackBar.showSuccess(
            context,
            'تم إعادة تعيين كلمة المرور بنجاح',
          );

          GoRouter.of(context).pushReplacement(EndPoints.signInView);
        }
        if (state is ResetPasswordFailure) {
          CustomSnackBar.showError(context, state.errorMsg);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              CustomPasswordField(
                labelText: 'كلمة مرور جديدة',
                controller: newPassController,
                activeValidator: true,
              ),
              (state is ResetPasswordLoading)
                  ? const CustomLoadingIndicator()
                  : CustomButton(
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          _updatePassword(context);
                        }
                      },
                      title: "تغيير كلمة المرور",
                    ),
            ],
          ),
        );
      },
    );
  }
}
