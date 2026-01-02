import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart' show AppColors;
import 'package:supercycle/core/utils/app_styles.dart' show AppStyles;
import 'package:supercycle/features/onboarding/presentation/widgets/partial_circle_border_painter.dart';
import 'package:supercycle/generated/l10n.dart' show S;

class ThirdOnboardingViewBody extends StatelessWidget {
  const ThirdOnboardingViewBody({super.key});

  Future<void> _skipOnboarding(BuildContext context) async {
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
                onPressed: () => _skipOnboarding(context),
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
            "خدمة",
            style: AppStyles.styleBold24(
              context,
            ).copyWith(fontSize: 36, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 30),
          Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 20,
              ),
              child: Image.asset(AppAssets.onboarding3, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "مندوبنا هيجيلك يستلم الكرتون، وتقدر تتابع العملية لحظة بلحظة مندوبنا هيجيلك يستلم الكرتون، وتقدر تتابع العملية لحظة بلحظة",
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
              percentage: 0.75,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  context.push(EndPoints.fourthOnboardingView);
                },
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
