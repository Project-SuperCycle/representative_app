import 'package:flutter/material.dart';
import 'package:representative_app/core/utils/app_styles.dart';

class FinancesTransactionsEmpty extends StatelessWidget {
  const FinancesTransactionsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 50,
                color: Color(0xFF3BC577),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'لا توجد معاملات',
              textDirection: TextDirection.rtl,
              style: AppStyles.styleBold24(
                context,
              ).copyWith(color: Colors.white),
            ),

            const SizedBox(height: 8),

            Text(
              'لم يتم تسجيل أي معاملات مالية حتى الآن',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: AppStyles.styleMedium16(
                context,
              ).copyWith(color: Colors.grey.withValues(alpha: 0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
