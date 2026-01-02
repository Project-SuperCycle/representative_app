import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/widgets/custom_button.dart';
import 'package:supercycle/core/widgets/reset_pass/auth_header_title.dart';
import 'package:supercycle/core/widgets/reset_pass/centered_container.dart';
import 'package:supercycle/features/forget_password/data/cubits/forget_password_cubit.dart';
import 'package:supercycle/features/forget_password/data/model/verify_reset_otp_model.dart';
import 'package:supercycle/features/sign_up/presentation/widgets/alternate_action_link.dart';
import 'package:supercycle/features/sign_up/presentation/widgets/filled_rounded_pin_put.dart';

class VerifyResetOtpViewBody extends StatefulWidget {
  final String email;

  const VerifyResetOtpViewBody({super.key, required this.email});

  @override
  State<VerifyResetOtpViewBody> createState() => _VerifyResetOtpViewBodyState();
}

class _VerifyResetOtpViewBodyState extends State<VerifyResetOtpViewBody> {
  final controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitVerify(BuildContext context) {
    final verifyModel = VerifyResetOtpModel(
      email: widget.email.trim(),
      otp: controller.text,
    );

    BlocProvider.of<ForgetPasswordCubit>(context).verifyResetOtp(verifyModel);
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
          AuthHeaderTitle(
            mainTitle: "تأكيد البريد الإلكتروني",
            subTitle:
                "لقد أرسلنا رمزًا مكوّنًا من 6 أرقام إلى ${widget.email}، برجاء إدخاله أدناه:",
          ),
          const SizedBox(height: 24.0),
          _buildForm(context),
          const SizedBox(height: 10.0),
          const AlternateActionLink(),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is VerifyResetOtpSuccess) {
          CustomSnackBar.showSuccess(context, 'تم التحقق من الرمز بنجاح');

          GoRouter.of(
            context,
          ).pushReplacement(EndPoints.resetPasswordView, extra: state.token);
        } else if (state is VerifyResetOtpFailure) {
          CustomSnackBar.showError(context, 'فشل التحقق من الرمز');
        }
      },
      builder: (context, state) => Form(
        key: _formKey,
        child: Column(
          children: [
            FilledRoundedPinPut(controller: controller),
            const SizedBox(height: 24.0),
            state is VerifyResetOtpLoading
                ? const CustomLoadingIndicator()
                : CustomButton(
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        _submitVerify(context);
                      }
                    },
                    title: "تحقق",
                  ),
          ],
        ),
      ),
      buildWhen: (previous, current) =>
          current is VerifyResetOtpSuccess ||
          current is VerifyResetOtpLoading ||
          current is VerifyResetOtpFailure,
    );
  }
}
