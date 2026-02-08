import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/core/services/auth_manager_services.dart';
import 'package:representative_app/features/sign_in/data/cubits/sign-in-cubit/sign_in_state.dart';
import 'package:representative_app/features/sign_in/data/models/signin_credentials_model.dart';
import 'package:representative_app/features/sign_in/data/repos/signin_repo_imp.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInRepoImp signInRepo;
  final AuthManager _authManager = AuthManager();

  SignInCubit({required this.signInRepo}) : super(SignInInitial());

  /// تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
  Future<void> signIn(SigninCredentialsModel credentials) async {
    emit(SignInLoading());

    try {
      var result = await signInRepo.userSignIn(credentials: credentials);

      result.fold(
        (failure) {
          emit(
            SignInFailure(
              message: failure.errMessage,
              statusCode: failure.statusCode,
            ),
          );
        },
        (user) async {
          await _authManager.onLoginSuccess();
          emit(SignInSuccess(user: user));
        },
      );
    } catch (error) {
      emit(SignInFailure(message: error.toString(), statusCode: 520));
    }
  }

    /// إعادة تعيين الحالة
  void resetState() {
    emit(SignInInitial());
  }
}
