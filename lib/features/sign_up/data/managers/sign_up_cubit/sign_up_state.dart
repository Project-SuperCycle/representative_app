part of 'sign_up_cubit.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
}

class SignUpInitial extends SignUpState {
  @override
  List<Object> get props => [];
}

// SignUp STEP 1
class InitialSignUpLoading extends SignUpState {
  @override
  List<Object> get props => [];
}

class InitialSignUpSuccess extends SignUpState {
  final String message;
  const InitialSignUpSuccess({required this.message});
  @override
  List<Object> get props => [];
}

class InitialSignUpFailure extends SignUpState {
  final String message;
  const InitialSignUpFailure({required this.message});
  @override
  List<Object> get props => [];
}

// SignUp STEP 2
class VerifyOtpLoading extends SignUpState {
  @override
  List<Object> get props => [];
}

class VerifyOtpSuccess extends SignUpState {
  final String message;
  const VerifyOtpSuccess({required this.message});
  @override
  List<Object> get props => [];
}

class VerifyOtpFailure extends SignUpState {
  final String message;
  const VerifyOtpFailure({required this.message});
  @override
  List<Object> get props => [];
}

// SignUp STEP 3
class CompleteSignUpLoading extends SignUpState {
  @override
  List<Object> get props => [];
}

class CompleteSignUpSuccess extends SignUpState {
  final String message;
  const CompleteSignUpSuccess({required this.message});
  @override
  List<Object> get props => [];
}

class CompleteSignUpFailure extends SignUpState {
  final String message;
  const CompleteSignUpFailure({required this.message});
  @override
  List<Object> get props => [];
}

