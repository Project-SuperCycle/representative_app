import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/core/services/auth_manager_services.dart';
import 'package:supercycle/features/sign_in/data/cubits/sign-in-cubit/sign_in_state.dart';
import 'package:supercycle/features/sign_in/data/models/signin_credentials_model.dart';
import 'package:supercycle/features/sign_in/data/repos/signin_repo_imp.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInRepoImp signInRepo;
  final AuthManager _authManager = AuthManager();

  SignInCubit({required this.signInRepo}) : super(SignInInitial());

  /// تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
  Future<void> signIn(SigninCredentialsModel credentials) async {
    emit(SignInLoading());

    try {
      var result = await signInRepo.userSignin(credentials: credentials);

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
          // 🎯 تحديث حالة المصادقة
          // ملحوظة: الـ Repo بالفعل استدعى onLoginSuccess()
          // لكن نضيفها هنا كـ safety measure
          await _authManager.onLoginSuccess();

          emit(SignInSuccess(user: user));
        },
      );
    } catch (error) {
      emit(SignInFailure(message: error.toString(), statusCode: 520));
    }
  }

  /// تسجيل الدخول عبر Google
  Future<void> signInWithGoogle() async {
    emit(SignInLoading());

    try {
      var result = await signInRepo.signInWithGoogle();

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
          // 🎯 تحديث حالة المصادقة
          await _authManager.onLoginSuccess();

          emit(SignInSuccess(user: user));
        },
      );
    } catch (error) {
      emit(
        SignInFailure(
          message: 'حدث خطأ أثناء تسجيل الدخول بـ Google',
          statusCode: 520,
        ),
      );
    }
  }

  /// تسجيل الدخول عبر Facebook
  Future<void> signInWithFacebook() async {
    emit(SignInLoading());

    try {
      var result = await signInRepo.signInWithFacebook();

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
          // 🎯 تحديث حالة المصادقة
          await _authManager.onLoginSuccess();

          emit(SignInSuccess(user: user));
        },
      );
    } catch (error) {
      emit(
        SignInFailure(
          message: 'حدث خطأ أثناء تسجيل الدخول بـ Facebook',
          statusCode: 520,
        ),
      );
    }
  }

  /// إعادة تعيين الحالة
  void resetState() {
    emit(SignInInitial());
  }
}
