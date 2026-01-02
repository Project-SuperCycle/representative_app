import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class EmptyShipmentsCard extends StatelessWidget {
  const EmptyShipmentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(25),
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
                color: Colors.white.withAlpha(25),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 45,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    'لا توجد شحنات مجدولة اليوم',
                    textAlign: TextAlign.center,
                    style: AppStyles.styleSemiBold18(
                      context,
                    ).copyWith(color: Colors.white),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'لم يتم جدولة أي شحنات لهذا اليوم',
                    textAlign: TextAlign.center,
                    style: AppStyles.styleMedium14(
                      context,
                    ).copyWith(color: Colors.white.withAlpha(400)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
