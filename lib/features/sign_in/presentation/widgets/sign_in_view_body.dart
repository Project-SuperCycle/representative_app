import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:representative_app/core/helpers/custom_loading_indicator.dart';
import 'package:representative_app/core/helpers/custom_snack_bar.dart';
import 'package:representative_app/core/routes/end_points.dart';
import 'package:representative_app/core/utils/app_colors.dart';
import 'package:representative_app/core/utils/app_styles.dart';
import 'package:representative_app/core/widgets/auth/auth_main_header.dart';
import 'package:representative_app/core/widgets/auth/auth_main_layout.dart';
import 'package:representative_app/core/widgets/auth/custom_password_field.dart';
import 'package:representative_app/core/widgets/custom_button.dart';
import 'package:representative_app/core/widgets/custom_text_form_field.dart';
import 'package:representative_app/core/widgets/rounded_container.dart';
import 'package:representative_app/features/sign_in/data/cubits/sign-in-cubit/sign_in_cubit.dart';
import 'package:representative_app/features/sign_in/data/cubits/sign-in-cubit/sign_in_state.dart';
import 'package:representative_app/features/sign_in/data/models/signin_credentials_model.dart';
import 'package:representative_app/generated/l10n.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  // ═══════════════════════════════════════════════════════════
  // Constants & Static Members
  // ═══════════════════════════════════════════════════════════
  static const Set<String> _traderRoles = {
    'trader_uncontracted',
    'trader_contracted',
  };

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
  );

  static final _egyptianPhoneRegex = RegExp(r'^(2)?01[0-9]{9}$');
  static final _internationalPhoneRegex = RegExp(r'^[1-9]\d{7,14}$');
  static final _phoneCleanupRegex = RegExp(r'[\s\-()+]');

  // ═══════════════════════════════════════════════════════════
  // Instance Variables
  // ═══════════════════════════════════════════════════════════
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final Logger _logger;

  // ═══════════════════════════════════════════════════════════
  // Lifecycle Methods
  // ═══════════════════════════════════════════════════════════
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _logger = Logger();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════
  // Validation Methods
  // ═══════════════════════════════════════════════════════════
  String? validateEmailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).field_required;
    }

    final trimmed = value.trim();
    if (_isValidEmail(trimmed) || _isValidPhone(trimmed)) {
      return null;
    }

    return S.of(context).invalid_email_or_phone;
  }

  bool _isValidEmail(String email) =>
      email.isNotEmpty && _emailRegex.hasMatch(email);

  bool _isValidPhone(String phone) {
    if (phone.isEmpty) return false;

    final cleaned = phone.replaceAll(_phoneCleanupRegex, '');
    return _egyptianPhoneRegex.hasMatch(cleaned) ||
        _internationalPhoneRegex.hasMatch(cleaned);
  }

  // ═══════════════════════════════════════════════════════════
  // Business Logic Methods
  // ═══════════════════════════════════════════════════════════
  bool _isTrader(String? role) => role != null && _traderRoles.contains(role);

  void _handleSignIn() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final input = _emailController.text.trim();
    final isEmail = _isValidEmail(input);

    final credentials = SigninCredentialsModel(
      password: _passwordController.text,
      email: isEmail ? input : null,
      phone: isEmail ? null : input,
    );

    context.read<SignInCubit>().signIn(credentials);
  }

  void _handleSignInSuccess(SignInSuccess state) {
    final role = state.user.role;
    _logger.i('✅ Sign in success - Role: $role');

    if (_isTrader(role)) {
      _logger.w('⚠️ Trader detected - Access denied');
      CustomSnackBar.showWarning(context, 'غير مصرح بتسجيل دخول التاجر');
      context.read<SignInCubit>().resetState();
      return;
    }

    _logger.i('✅ Navigating to home view');
    context.pushReplacement(EndPoints.homeView);
  }

  void _handleSocialAuthSuccess(SocialAuthSuccess state) {
    final user = state.socialAuth.user;
    final role = user?.role;

    _logger.w('Social Auth - Role: $role');

    if (_isTrader(role)) {
      _logger.w('Trader role detected in social auth');
      CustomSnackBar.showWarning(context, 'غير مصرح بتسجيل دخول التاجر');
      return;
    }

    if (state.socialAuth.status == 201) {
      context.push(EndPoints.signInView);
      return;
    }

    context.pushReplacement(EndPoints.homeView);
  }

  void _navigateToForgetPassword() {
    context.push(EndPoints.forgetPasswordView);
  }

  // ═══════════════════════════════════════════════════════════
  // BLoC Listener
  // ═══════════════════════════════════════════════════════════
  void _handleStateChange(BuildContext context, SignInState state) {
    switch (state) {
      case SignInSuccess():
        _handleSignInSuccess(state);
      case SignInFailure():
        CustomSnackBar.showError(context, state.message);
      case SocialAuthSuccess():
        _handleSocialAuthSuccess(state);
      case SocialAuthFailure():
        CustomSnackBar.showError(context, state.message);
      default:
        break;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // UI Build Methods
  // ═══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: _handleStateChange,
      child: AuthMainLayout(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.20),
            Expanded(
              child: RoundedContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    AuthMainHeader(
                      title: S.of(context).signIn_title,
                      subTitle: S.of(context).signIn_subTitle,
                    ),
                    const SizedBox(height: 30),
                    _SignInForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      onValidateEmailOrPhone: validateEmailOrPhone,
                      onSignIn: _handleSignIn,
                      onForgetPassword: _navigateToForgetPassword,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Extracted Widget for Better Performance
// ═══════════════════════════════════════════════════════════
class _SignInForm extends StatelessWidget {
  const _SignInForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onValidateEmailOrPhone,
    required this.onSignIn,
    required this.onForgetPassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? Function(String?) onValidateEmailOrPhone;
  final VoidCallback onSignIn;
  final VoidCallback onForgetPassword;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        final isLoading = state is SignInLoading;

        return Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: emailController,
                labelText: S.of(context).email_phone,
                validator: onValidateEmailOrPhone,
                enabled: !isLoading,
              ),
              const SizedBox(height: 20),
              CustomPasswordField(
                controller: passwordController,
                activeValidator: false,
                labelText: S.of(context).password,
              ),
              const SizedBox(height: 5),
              _ForgotPasswordButton(
                isLoading: isLoading,
                onTap: onForgetPassword,
              ),
              const SizedBox(height: 25),
              isLoading
                  ? const CustomLoadingIndicator()
                  : CustomButton(
                      title: S.of(context).signIn_button,
                      onPress: onSignIn,
                    ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Extracted Widget for Forgot Password
// ═══════════════════════════════════════════════════════════
class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton({required this.isLoading, required this.onTap});

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Text(
          '${S.of(context).forgot_password}؟',
          style: AppStyles.styleMedium16(context).copyWith(
            color: isLoading
                ? AppColors.failureColor.withValues(alpha: 0.5)
                : AppColors.failureColor,
          ),
        ),
      ),
    );
  }
}
