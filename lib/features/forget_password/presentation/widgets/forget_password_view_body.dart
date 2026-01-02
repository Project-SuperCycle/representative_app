import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/widgets/custom_button.dart';
import 'package:supercycle/core/widgets/custom_text_field.dart';
import 'package:supercycle/core/widgets/reset_pass/auth_header_title.dart';
import 'package:supercycle/core/widgets/reset_pass/centered_container.dart';
import 'package:supercycle/features/forget_password/data/cubits/forget_password_cubit.dart';

class ForgetPasswordViewBody extends StatelessWidget {
  ForgetPasswordViewBody({super.key});

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

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
          const AuthHeaderTitle(
            mainTitle: "استعادة كلمة المرور",
            subTitle:
                "سنرسل لك كود التحقق \n على بريدك الإلكتروني لإعادة تعيين كلمة المرور",
          ),
          const SizedBox(height: 24),
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordFailure) {
          CustomSnackBar.showError(context, state.errorMsg);
        }
        if (state is ForgetPasswordSuccess) {
          String email = emailController.text.trim();
          GoRouter.of(context).push(EndPoints.verifyResetOtpView, extra: email);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              CustomTextField(
                controller: emailController,
                label: 'البريد الإلكتروني',
                validator: _validateEmail,
                isArabic: true,
              ),
              const SizedBox(height: 20),
              state is ForgetPasswordLoading
                  ? const CustomLoadingIndicator()
                  : CustomButton(
                      onPress: () => _onSubmit(context, state),
                      title: "إرسال",
                    ),
            ],
          ),
        );
      },
      buildWhen: (previous, current) =>
          current is ForgetPasswordSuccess ||
          current is ForgetPasswordLoading ||
          current is ForgetPasswordFailure,
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void _onSubmit(BuildContext context, ForgetPasswordState state) {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();

      BlocProvider.of<ForgetPasswordCubit>(context).forgetPassword(email);
    }
  }
}
