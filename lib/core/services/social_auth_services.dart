import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

/// خدمة المصادقة عبر وسائل التواصل الاجتماعي
abstract class SocialAuthService {
  /// تسجيل الدخول عبر Google
  static Future<String> signInWithGoogle() async {
    try {
      // 1. بدء عملية المصادقة
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // 2. التحقق من إلغاء المستخدم للعملية
      if (googleUser == null) {
        throw Exception('Google Sign In cancelled by user');
      }

      // 3. الحصول على تفاصيل المصادقة
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null) {
        throw Exception('Google Sign In failed');
      }

      final String accessToken = googleAuth.accessToken!;
      return accessToken;
    } catch (e) {
      rethrow;
    }
  }

  /// تسجيل الخروج من Google
  static Future<void> signOutGoogle() async {
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      Logger().e('❌ Google Sign Out error: $e');
    }
  }
}
