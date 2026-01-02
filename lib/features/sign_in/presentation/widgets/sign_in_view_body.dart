import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/widgets/auth/auth_main_header.dart';
import 'package:supercycle/core/widgets/auth/auth_main_layout.dart';
import 'package:supercycle/core/widgets/auth/custom_password_field.dart';
import 'package:supercycle/core/widgets/custom_button.dart';
import 'package:supercycle/core/widgets/custom_text_form_field.dart';
import 'package:supercycle/core/widgets/rounded_container.dart';
import 'package:supercycle/features/sign_in/data/cubits/sign-in-cubit/sign_in_cubit.dart';
import 'package:supercycle/features/sign_in/data/cubits/sign-in-cubit/sign_in_state.dart';
import 'package:supercycle/features/sign_in/data/models/signin_credentials_model.dart';
import 'package:supercycle/features/sign_in/presentation/widgets/horizontal_labeled_divider.dart';
import 'package:supercycle/generated/l10n.dart';
import 'package:supercycle/core/widgets/auth/social_auth_row.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

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

  void handleSignIn() {
    if (_formKey.currentState!.validate()) {
      String inputType = checkInputType(_controllers['email']!.text);
      final credentials = SigninCredentialsModel(
        password: _controllers['password']!.text,
        email: inputType == 'email' ? _controllers['email']!.text : null,
        phone: inputType == 'phone' ? _controllers['email']!.text : null,
      );
      BlocProvider.of<SignInCubit>(context).signIn(credentials);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          GoRouter.of(context).pushReplacement(EndPoints.homeView);
        }
        if (state is SignInFailure) {
          CustomSnackBar.showError(context, state.message);

          if (state.statusCode == 200) {
            GoRouter.of(context).pushReplacement(EndPoints.signUpDetailsView);
          } else if (state.statusCode == 403) {
            GoRouter.of(context).pushReplacement(
              EndPoints.signUpVerifyView,
              extra: _controllers['email']!.text,
            );
          }
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
                        title: S.of(context).signIn_title,
                        subTitle: S.of(context).signIn_subTitle,
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: _controllers['email'],
                              labelText: S.of(context).email_phone,
                              validator:
                                  validateEmailOrPhone, // إضافة الـ validator هنا
                            ),
                            const SizedBox(height: 20),
                            CustomPasswordField(
                              controller: _controllers['password'],
                              activeValidator: false,
                              labelText: S.of(context).password,
                            ),
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => GoRouter.of(
                                  context,
                                ).push(EndPoints.forgetPasswordView),
                                child: Text(
                                  "${S.of(context).forgot_password}؟",
                                  style: AppStyles.styleMedium16(
                                    context,
                                  ).copyWith(color: AppColors.failureColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            (state is SignInLoading)
                                ? CustomLoadingIndicator()
                                : CustomButton(
                                    title: S.of(context).signIn_button,
                                    onPress: handleSignIn,
                                  ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  GoRouter.of(
                                    context,
                                  ).push(EndPoints.signUpView);
                                },
                                child: Text(
                                  S.of(context).create_account,
                                  style: AppStyles.styleMedium16(
                                    context,
                                  ).copyWith(color: AppColors.primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      HorizontalLabeledDivider(),
                      const SizedBox(height: 24),
                      SocialAuthRow(),
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
