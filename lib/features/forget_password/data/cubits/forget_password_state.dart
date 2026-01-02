part of 'forget_password_cubit.dart';

sealed class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();
}

final class ForgetPasswordInitial extends ForgetPasswordState {
  @override
  List<Object> get props => [];
}

// Forget Password States
final class ForgetPasswordLoading extends ForgetPasswordState {
  @override
  List<Object> get props => [];
}

final class ForgetPasswordSuccess extends ForgetPasswordState {
  final String message;
  const ForgetPasswordSuccess({required this.message});

  @override
  List<Object> get props => [];
}

final class ForgetPasswordFailure extends ForgetPasswordState {
  final String errorMsg;
  const ForgetPasswordFailure({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

// Reset Password States
final class ResetPasswordLoading extends ForgetPasswordState {
  @override
  List<Object> get props => [];
}

final class ResetPasswordSuccess extends ForgetPasswordState {
  final String? message;
  const ResetPasswordSuccess({this.message});

  @override
  List<Object> get props => [];
}

final class ResetPasswordFailure extends ForgetPasswordState {
  final String errorMsg;
  const ResetPasswordFailure({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

// Verify Reset OTP States
final class VerifyResetOtpLoading extends ForgetPasswordState {
  const VerifyResetOtpLoading();

  @override
  List<Object> get props => [];
}

final class VerifyResetOtpSuccess extends ForgetPasswordState {
  final String? token;
  const VerifyResetOtpSuccess({this.token});

  @override
  List<Object> get props => [];
}

final class VerifyResetOtpFailure extends ForgetPasswordState {
  final String errorMsg;
  const VerifyResetOtpFailure({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
