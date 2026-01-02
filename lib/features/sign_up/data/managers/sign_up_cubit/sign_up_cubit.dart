import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:supercycle/features/sign_up/data/models/business_information_model.dart'
    show BusinessInformationModel;
import 'package:supercycle/features/sign_up/data/models/otp_verification_model.dart'
    show OtpVerificationModel;
import 'package:supercycle/features/sign_up/data/models/signup_credentials_model.dart';
import 'package:supercycle/features/sign_up/data/repos/signup_repo_imp.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpRepoImp signUpRepo;

  SignUpCubit({required this.signUpRepo}) : super(SignUpInitial());

  Future<void> initiateSignup(SignupCredentialsModel credentials) async {
    emit(InitialSignUpLoading());
    try {
      var result = await signUpRepo.initiateSignup(credentials: credentials);
      result.fold(
        (failure) {
          emit(InitialSignUpFailure(message: failure.errMessage));
        },
        (message) {
          emit(InitialSignUpSuccess(message: message));
        },
      );
    } catch (error) {
      emit(InitialSignUpFailure(message: error.toString()));
    }
  }

  Future<void> verifyOtp(OtpVerificationModel credentials) async {
    emit(VerifyOtpLoading());
    try {
      var result = await signUpRepo.verifyOtp(credentials: credentials);
      result.fold(
        (failure) {
          emit(VerifyOtpFailure(message: failure.errMessage));
        },
        (message) {
          emit(VerifyOtpSuccess(message: message));
        },
      );
    } catch (error) {
      emit(VerifyOtpFailure(message: error.toString()));
    }
  }

  Future<void> completeSignup(BusinessInformationModel businessInfo) async {
    emit(CompleteSignUpLoading());
    try {
      var result = await signUpRepo.completeSignup(businessInfo: businessInfo);
      result.fold(
        (failure) {
          emit(CompleteSignUpFailure(message: failure.errMessage));
        },
        (message) {
          emit(CompleteSignUpSuccess(message: message));
        },
      );
    } catch (error) {
      emit(CompleteSignUpFailure(message: error.toString()));
    }
  }
}
