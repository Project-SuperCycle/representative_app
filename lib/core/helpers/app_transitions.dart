import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Professional smooth transitions for the app
class AppTransitions {
  // ============================================================
  // SMOOTH FADE TRANSITION - الانتقال الأساسي الاحترافي
  // ============================================================

  /// Ultra smooth fade transition - الأنعم والأكثر احترافية
  /// يستخدم fade مع scale خفيف جداً
  static Page<dynamic> smoothFade(
    LocalKey key,
    Widget child, {
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade animation
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
        var fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );

        // Subtle scale animation (0.97 to 1.0 - barely noticeable but smooth)
        var scaleTween = Tween<double>(begin: 0.97, end: 1.0);
        var scaleAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
        );

        return FadeTransition(
          opacity: fadeTween.animate(fadeAnimation),
          child: ScaleTransition(
            scale: scaleTween.animate(scaleAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  /// Smooth fade with secondary animation
  /// للصفحات التي تحتاج انتقال أكثر وضوحاً
  static Page<dynamic> smoothFadeWithScale(
    LocalKey key,
    Widget child, {
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Primary animation (incoming page)
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
        var scaleTween = Tween<double>(begin: 0.95, end: 1.0);

        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        // Secondary animation (outgoing page)
        var secondaryFadeTween = Tween<double>(begin: 1.0, end: 0.0);
        var secondaryScaleTween = Tween<double>(begin: 1.0, end: 1.05);

        var secondaryCurved = CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeInCubic,
        );

        return Stack(
          children: [
            // Outgoing page
            FadeTransition(
              opacity: secondaryFadeTween.animate(secondaryCurved),
              child: ScaleTransition(
                scale: secondaryScaleTween.animate(secondaryCurved),
                child: const SizedBox.expand(),
              ),
            ),
            // Incoming page
            FadeTransition(
              opacity: fadeTween.animate(curvedAnimation),
              child: ScaleTransition(
                scale: scaleTween.animate(curvedAnimation),
                child: child,
              ),
            ),
          ],
        );
      },
      transitionDuration: duration,
    );
  }

  // ============================================================
  // SPECIALIZED TRANSITIONS
  // ============================================================

  /// للصفحات الرئيسية والـ Home
  static Page<dynamic> fadeForMain(LocalKey key, Widget child) {
    return smoothFade(key, child, duration: const Duration(milliseconds: 300));
  }

  /// للصفحات الفرعية مثل التفاصيل
  static Page<dynamic> fadeForDetails(LocalKey key, Widget child) {
    return smoothFadeWithScale(
      key,
      child,
      duration: const Duration(milliseconds: 350),
    );
  }

  /// لصفحات Authentication
  static Page<dynamic> fadeForAuth(LocalKey key, Widget child) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
        var slideTween = Tween<Offset>(
          begin: const Offset(0.0, 0.03), // Subtle vertical slide
          end: Offset.zero,
        );

        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
        );

        return FadeTransition(
          opacity: fadeTween.animate(curvedAnimation),
          child: SlideTransition(
            position: slideTween.animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  /// للـ Modals والـ Bottom Sheets
  static Page<dynamic> fadeForModal(LocalKey key, Widget child) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
        var scaleTween = Tween<double>(begin: 0.92, end: 1.0);

        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuint,
        );

        return FadeTransition(
          opacity: fadeTween.animate(curvedAnimation),
          child: ScaleTransition(
            scale: scaleTween.animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Ultra fast fade - للانتقالات السريعة
  static Page<dynamic> quickFade(LocalKey key, Widget child) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );

        return FadeTransition(
          opacity: fadeTween.animate(curvedAnimation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  // ============================================================
  // LEGACY SUPPORT (للتوافق مع الكود القديم)
  // ============================================================

  /// Fade Through - يستخدم smoothFade الجديد
  @Deprecated('Use smoothFade or fadeForMain instead')
  static Page<dynamic> fadeThrough(LocalKey key, Widget child) {
    return smoothFade(key, child);
  }

  /// Shared Axis Horizontal - يستخدم smoothFadeWithScale
  @Deprecated('Use smoothFadeWithScale or fadeForDetails instead')
  static Page<dynamic> sharedAxisHorizontal(LocalKey key, Widget child) {
    return smoothFadeWithScale(key, child);
  }

  /// Shared Axis Vertical - يستخدم smoothFadeWithScale
  @Deprecated('Use smoothFadeWithScale or fadeForDetails instead')
  static Page<dynamic> sharedAxisVertical(LocalKey key, Widget child) {
    return smoothFadeWithScale(key, child);
  }

  /// Shared Axis Scaled - يستخدم smoothFadeWithScale
  @Deprecated('Use smoothFadeWithScale or fadeForDetails instead')
  static Page<dynamic> sharedAxisScaled(LocalKey key, Widget child) {
    return smoothFadeWithScale(key, child);
  }
}
