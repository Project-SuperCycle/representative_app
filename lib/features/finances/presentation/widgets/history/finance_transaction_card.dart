import 'package:flutter/material.dart';
import 'package:representative_app/core/constants.dart';
import 'package:representative_app/core/utils/app_styles.dart';
import 'package:representative_app/features/finances/data/models/finance_payment_model.dart';

class FinanceTransactionCard extends StatelessWidget {
  const FinanceTransactionCard({super.key, required this.transaction});

  final FinancePaymentModel transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3BC577).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // ── Row 1: Status + ID + Icon ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3BC577).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: const Color(0xFF3BC577),
                    size: 22,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.traderName + 'الاسم الكامل',
                        style: AppStyles.styleBold16(
                          context,
                        ).copyWith(color: Color(0xFF10B981)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        transaction.getFormattedPaidAt(),
                        textDirection: TextDirection.rtl,
                        style: AppStyles.styleMedium12(
                          context,
                        ).copyWith(color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3BC577).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'محصل',
                    textDirection: TextDirection.rtl,
                    style: AppStyles.styleBold12(
                      context,
                    ).copyWith(color: const Color(0xFF10B981)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200, thickness: 0.5),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Payment Method
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'طريقة التحصيل',
                        textDirection: TextDirection.rtl,
                        style: AppStyles.styleMedium12(
                          context,
                        ).copyWith(color: Colors.grey.shade400),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            getPaymentIcon(transaction.paymentType),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            getPaymentType(transaction.paymentType),
                            textDirection: TextDirection.rtl,
                            style: AppStyles.styleBold16(
                              context,
                            ).copyWith(color: Color(0xFF10B981)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Total Weight
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'عدد الشحنات',
                      textDirection: TextDirection.rtl,
                      style: AppStyles.styleMedium12(
                        context,
                      ).copyWith(color: Colors.grey.shade400),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          transaction.relatedShipmentCount.toString(),
                          style: AppStyles.styleBold18(
                            context,
                          ).copyWith(color: Color(0xFF10B981)),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'شحنة',
                          textDirection: TextDirection.rtl,
                          style: AppStyles.styleMedium12(
                            context,
                          ).copyWith(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Row 3: Total Amount ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF3BC577).withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF3BC577).withValues(alpha: 0.15),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        transaction.amount
                            .toStringAsFixed(0)
                            .replaceAllMapped(
                              RegExp(r'\B(?=(\d{3})+(?!\d))'),
                              (m) => ',',
                            ),
                        style: AppStyles.styleBold20(
                          context,
                        ).copyWith(color: Color(0xFF10B981)),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'جنيه',
                        style: AppStyles.styleMedium12(
                          context,
                        ).copyWith(color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                  Text(
                    'إجمالي المبلغ',
                    textDirection: TextDirection.rtl,
                    style: AppStyles.styleSemiBold12(
                      context,
                    ).copyWith(color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getPaymentIcon(String paymentMethod) {
  switch (paymentMethod) {
    case 'cash':
      return '💵';
    case 'bankTransfer':
      return '🏦';
    case 'wallet':
      return '💳';
    default:
      return '💵';
  }
}

String getPaymentType(String paymentMethod) {
  switch (paymentMethod) {
    case 'cash':
      return 'نقدي';
    case 'bankTransfer':
      return 'بنكي';
    case 'wallet':
      return 'محفظة';
    default:
      return 'نقدي';
  }
}
