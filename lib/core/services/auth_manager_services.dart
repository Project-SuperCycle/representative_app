import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:representative_app/core/services/storage_services.dart';
import 'package:representative_app/core/services/user_profile_services.dart';

/// مدير مركزي لعمليات المصادقة وتسجيل الخروج
class AuthManager {
  // Singleton pattern
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();

  // Stream لتتبع حالة تسجيل الدخول
  final ValueNotifier<bool> isLoggedInNotifier = ValueNotifier<bool>(false);

  // Stream لتحديث بيانات المستخدم
  final ValueNotifier<int> authStateChangeNotifier = ValueNotifier<int>(0);

  /// تهيئة حالة المصادقة عند بدء التطبيق
  Future<void> initialize() async {
    final user = await StorageServices.getUserData();
    isLoggedInNotifier.value = (user != null);
  }

  /// تسجيل خروج شامل ومنظم
  Future<bool> logout() async {
    try {
      // 1. تسجيل الخروج من Google
      try {
        await GoogleSignIn().signOut();
      } catch (e) {
        debugPrint('Google sign out error: $e');
      }

      try {
        await UserProfileService.deleteUserProfile();
      } catch (e) {
        debugPrint('Delete User Profile Data: $e');
      }

      // 3. مسح جميع البيانات المحلية
      await StorageServices.clearAll();

      // 4. تحديث حالة المصادقة
      isLoggedInNotifier.value = false;

      // 5. إطلاق إشعار بتغيير حالة المصادقة
      authStateChangeNotifier.value++;

      return true;
    } catch (e) {
      debugPrint('Logout error: $e');
      return false;
    }
  }

  /// تحديث حالة تسجيل الدخول بعد Login ناجح
  Future<void> onLoginSuccess() async {
    isLoggedInNotifier.value = true;
    authStateChangeNotifier.value++;
  }

  /// التخلص من الموارد
  void dispose() {
    isLoggedInNotifier.dispose();
    authStateChangeNotifier.dispose();
  }
}
