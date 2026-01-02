import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer, BlocProvider;
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/routes/end_points.dart' show EndPoints;
import 'package:supercycle/core/widgets/auth/auth_main_header.dart';
import 'package:supercycle/core/widgets/auth/auth_main_layout.dart';
import 'package:supercycle/core/widgets/auth/custom_confirm_password.dart';
import 'package:supercycle/core/widgets/auth/custom_password_field.dart';
import 'package:supercycle/core/widgets/auth/social_auth_row.dart';
import 'package:supercycle/core/widgets/custom_text_form_field.dart';
import 'package:supercycle/core/widgets/rounded_container.dart';
import 'package:supercycle/features/sign_in/presentation/widgets/horizontal_labeled_divider.dart';
import 'package:supercycle/features/sign_up/data/managers/sign_up_cubit/sign_up_cubit.dart'
    show
        SignUpCubit,
        SignUpState,
        InitialSignUpSuccess,
        InitialSignUpFailure,
        InitialSignUpLoading;
import 'package:supercycle/features/sign_up/data/models/signup_credentials_model.dart';
import 'package:supercycle/features/sign_up/presentation/widgets/sign_up_action_row.dart';
import 'package:supercycle/generated/l10n.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
  };

  String checkInputType(String input) {
    String trimmedInput = input.trim();
    if (trimmedInput.isEmpty) {
      return S.of(context).field_required;
    }

    if (isValidEmail(trimmedInput)) {
      return 'email';
    }
    if (isValidPhone(trimmedInput)) {
      return 'phone';
    }
    return S.of(context).invalid_email_or_phone;
  }

  bool isValidEmail(String email) {
    String trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      return false;
    }
    RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );
    return emailRegex.hasMatch(trimmedEmail);
  }

  bool isValidPhone(String phone) {
    String trimmedPhone = phone.trim();
    if (trimmedPhone.isEmpty) {
      return false;
    }
    String cleanedPhone = trimmedPhone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    RegExp egyptianPhoneRegex = RegExp(r'^(2)?01[0-9]{9}$');
    RegExp internationalPhoneRegex = RegExp(r'^[1-9]\d{7,14}$');

    if (egyptianPhoneRegex.hasMatch(cleanedPhone)) {
      return true;
    }
    if (internationalPhoneRegex.hasMatch(cleanedPhone)) {
      return true;
    }
    return false;
  }

  String? validatePasswordConfirmation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).field_required;
    }

    String originalPassword = _controllers['password']?.text ?? '';

    if (value != originalPassword) {
      return S.of(context).passwords_do_not_match;
    }

    return null;
  }

  String? validateEmailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).field_required;
    }

    String inputType = checkInputType(value);

    switch (inputType) {
      case 'email':
        if (!isValidEmail(value)) {
          return S.of(context).invalid_email;
        }
        return null;

      case 'phone':
        if (!isValidPhone(value)) {
          return S.of(context).invalid_phone;
        }
        return null;

      case 'غير محدد':
      default:
        return S.of(context).invalid_email_or_phone;
    }
  }

  void handleSignUp() {
    if (_formKey.currentState!.validate()) {
      String inputType = checkInputType(_controllers['email']!.text);
      final credentials = SignupCredentialsModel(
        password: _controllers['password']!.text,
        email: inputType == 'email' ? _controllers['email']!.text : null,
        phone: inputType == 'phone' ? _controllers['email']!.text : null,
      );
      BlocProvider.of<SignUpCubit>(context).initiateSignup(credentials);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is InitialSignUpSuccess) {
          GoRouter.of(context).push(
            EndPoints.signUpVerifyView,
            extra: _controllers['email']!.text,
          );
        }
        if (state is InitialSignUpFailure) {
          CustomSnackBar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        return AuthMainLayout(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.20),
              Expanded(
                child: RoundedContainer(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      AuthMainHeader(
                        title: S.of(context).signUp_title,
                        subTitle: S.of(context).signUp_subTitle,
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: _controllers['email'],
                              validator: validateEmailOrPhone,
                              labelText: S.of(context).email_phone,
                            ),
                            const SizedBox(height: 20),
                            CustomPasswordField(
                              controller: _controllers['password'],
                              labelText: S.of(context).password,
                            ),
                            const SizedBox(height: 20),
                            CustomConfirmPassword(
                              controller: _controllers['confirmPassword'],
                              validator: validatePasswordConfirmation,
                              labelText: S.of(context).confirm_password,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      HorizontalLabeledDivider(),
                      const SizedBox(height: 24),
                      SocialAuthRow(),
                      const SizedBox(height: 30),
                      (state is InitialSignUpLoading)
                          ? const CustomLoadingIndicator()
                          : SignUpActionRow(onSignUp: handleSignUp),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
