import 'package:flutter/material.dart';
import 'package:representative_app/core/utils/app_styles.dart';

class TodayShipmentsInitialCard extends StatelessWidget {
  const TodayShipmentsInitialCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ======== Decorative circles ========
        Positioned(
          top: -30,
          right: -30,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(50),
            ),
          ),
        ),
        Positioned(
          bottom: -20,
          left: -20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(50),
            ),
          ),
        ),

        // ======== Content ========
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ----- Icon -----
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(80),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: Colors.white,
                  size: 36,
                ),
              ),

              const SizedBox(height: 16),

              // ----- Title -----
              Text(
                'شحنات اليوم',
                style: AppStyles.styleBold16(
                  context,
                ).copyWith(color: Colors.white),
              ),

              const SizedBox(height: 8),

              // ----- Subtitle -----
              Text(
                'لا توجد بيانات لعرضها في الوقت الحالي',
                textAlign: TextAlign.center,
                style: AppStyles.styleMedium12(
                  context,
                ).copyWith(color: Colors.white.withAlpha(400)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
