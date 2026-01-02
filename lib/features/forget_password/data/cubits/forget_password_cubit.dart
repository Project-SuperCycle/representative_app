import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/forget_password/data/model/reset_password_model.dart';
import 'package:supercycle/features/forget_password/data/model/verify_reset_otp_model.dart';
import 'package:supercycle/features/forget_password/data/repos/forget_password_repo_imp.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordRepoImp forgetPasswordRepoImp;

  ForgetPasswordCubit({required this.forgetPasswordRepoImp})
    : super(ForgetPasswordInitial());

  Future<void> forgetPassword(String email) async {
    emit(ForgetPasswordLoading());
    try {
      var result = await forgetPasswordRepoImp.forgetPassword(email);
      result.fold(
        (failure) {
          emit(ForgetPasswordFailure(errorMsg: failure.errMessage));
        },
        (message) {
          emit(ForgetPasswordSuccess(message: message));
          // Store user globally
        },
      );
    } catch (error) {
      emit(ForgetPasswordFailure(errorMsg: error.toString()));
    }
  }

  Future<void> verifyResetOtp(VerifyResetOtpModel verifyModel) async {
    emit(VerifyResetOtpLoading());
    try {
      var result = await forgetPasswordRepoImp.verifyResetOtp(verifyModel);
      result.fold(
        (failure) {
          emit(VerifyResetOtpFailure(errorMsg: failure.errMessage));
        },
        (token) {
          emit(VerifyResetOtpSuccess(token: token));
        },
      );
    } catch (error) {
      emit(VerifyResetOtpFailure(errorMsg: error.toString()));
    }
  }

  Future<void> resetPassword(ResetPasswordModel resetModel) async {
    emit(ResetPasswordLoading());
    try {
      var result = await forgetPasswordRepoImp.resetPassword(resetModel);
      result.fold(
        (failure) {
          emit(ResetPasswordFailure(errorMsg: failure.errMessage));
        },
        (message) {
          emit(ResetPasswordSuccess(message: message));
        },
      );
    } catch (error) {
      emit(ResetPasswordFailure(errorMsg: error.toString()));
    }
  }
}
