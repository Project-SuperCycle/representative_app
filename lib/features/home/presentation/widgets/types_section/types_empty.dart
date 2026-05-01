import 'package:flutter/material.dart';
import 'package:representative_app/core/utils/app_colors.dart';
import 'package:representative_app/core/utils/app_styles.dart';

class TypesEmpty extends StatelessWidget {
  const TypesEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Icon(
                Icons.category_outlined,
                size: 24,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'لا توجد أنواع متاحة',
              style: AppStyles.styleSemiBold18(
                context,
              ).copyWith(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 4),
            Text(
              'سيتم عرض الأنواع هنا عند إضافتها',
              style: AppStyles.styleMedium14(
                context,
              ).copyWith(color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}
