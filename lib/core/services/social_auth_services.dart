import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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
        Logger().e('❌ Failed to get Google authentication details');
        throw Exception('Google Sign In failed');
      }

      final String accessToken = googleAuth.accessToken!;
      return accessToken;
    } catch (e) {
      Logger().e('❌ Google Sign In error: $e');
      rethrow;
    }
  }

  /// تسجيل الدخول عبر Facebook
  static Future<String> signInWithFacebook() async {
    try {
      // 1. بدء عملية تسجيل الدخول
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      // 2. التحقق من حالة تسجيل الدخول
      if (loginResult.status != LoginStatus.success) {
        if (loginResult.status == LoginStatus.cancelled) {
          throw Exception('Facebook Sign In cancelled by user');
        } else if (loginResult.status == LoginStatus.failed) {
          throw Exception('Facebook Sign In failed: ${loginResult.message}');
        } else {
          throw Exception('Facebook Sign In failed with unknown status');
        }
      }

      // 3. الحصول على access token
      final AccessToken? accessToken = loginResult.accessToken;

      if (accessToken == null) {
        Logger().e('❌ Failed to get Facebook access token');
        throw Exception('Facebook Sign In failed');
      }

      return accessToken.tokenString;
    } catch (e) {
      Logger().e('❌ Facebook Sign In error: $e');
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

  /// تسجيل الخروج من Facebook
  static Future<void> signOutFacebook() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      Logger().e('❌ Facebook Sign Out error: $e');
    }
  }
}
