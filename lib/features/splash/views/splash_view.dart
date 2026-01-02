import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Create scale animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Start animation
    _animationController.forward();

    // Navigate after animation
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNextScreen() async {
    // انتظر الـ animation
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // اقرأ البيانات
    final hasSeenOnboarding = await StorageServices.readData(
      "hasSeenOnboarding",
    );
    final userAuth = await StorageServices.readData("isUser");
    final user = await StorageServices.getUserData();

    // حدد الصفحة المناسبة
    String targetRoute;

    if (hasSeenOnboarding == "true" || userAuth == "true" || user != null) {
      // المستخدم شاف الـ onboarding قبل كده أو مسجل دخول
      targetRoute = EndPoints.homeView;
    } else {
      // أول مرة يفتح التطبيق
      targetRoute = EndPoints.firstOnboardingView;
    }

    if (mounted) {
      context.go(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "أهلا بيك",
              style: AppStyles.styleBold24(
                context,
              ).copyWith(fontSize: 36, color: AppColors.primaryColor),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: screenSize.width * 0.5,
                      height: screenSize.width * 0.5,
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppAssets.logo),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Text(
              "حوّل الكرتون المستهلك لفلوس",
              style: AppStyles.styleMedium18(
                context,
              ).copyWith(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              "بطريقة سهلة وآمنة",
              style: AppStyles.styleMedium18(
                context,
              ).copyWith(color: AppColors.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
