import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart' show AppColors;
import 'package:supercycle/core/utils/app_styles.dart' show AppStyles;
import 'package:supercycle/features/onboarding/presentation/widgets/partial_circle_border_painter.dart';
import 'package:supercycle/generated/l10n.dart' show S;

class FourthOnboardingViewBody extends StatelessWidget {
  const FourthOnboardingViewBody({super.key});

  Future<void> _completeOnboarding(BuildContext context) async {
    // خزن إن المستخدم شاف الـ onboarding
    await StorageServices.storeData("hasSeenOnboarding", "true");
    await StorageServices.storeData("isUser", "true");

    if (context.mounted) {
      context.go(EndPoints.homeView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () => _completeOnboarding(context),
                child: Text(
                  S.of(context).skip,
                  style: AppStyles.styleSemiBold18(
                    context,
                  ).copyWith(color: AppColors.primaryColor),
                ),
              ),
            ),
          ),
          Text(
            "فلوس",
            style: AppStyles.styleBold24(
              context,
            ).copyWith(fontSize: 36, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 30),
          Flexible(
            fit: FlexFit.tight,
            child: Image.asset(AppAssets.onboarding4, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "استلم فلوسك بعد البيع للمصنع مباشرة بكل سهولة",
              style: AppStyles.styleSemiBold18(
                context,
              ).copyWith(color: AppColors.primaryColor, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          CustomPaint(
            painter: PartialCircleBorderPainter(
              color: AppColors.primaryColor,
              strokeWidth: 4,
              percentage: 1.0,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () => _completeOnboarding(context),
                child: Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
