import 'package:flutter/material.dart';
import 'package:supercycle/core/models/trader_contract_model.dart';
import 'package:supercycle/core/models/user_profile_model.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/trader_main_profile/presentation/widgets/trader_uncontracted_message.dart';

class TraderProfileInfoCard3 extends StatelessWidget {
  final UserProfileModel user;

  const TraderProfileInfoCard3({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'بيانات التعاقد',
          style: AppStyles.styleSemiBold22(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        (user.role == "trader_uncontracted")
            ? TraderUncontractedMessage()
            : _buildContractInfo(context),
      ],
    );
  }

  Widget _buildContractInfo(BuildContext context) {
    TraderContractModel contact = user.contract!;

    // Format start date in Arabic
    String formattedStartDate = _formatArabicDate(contact.startDate);

    // Calculate contract duration in Arabic
    String contractDuration = _calculateContractDuration(
      contact.startDate,
      contact.endDate,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildContractSection(
              icon: Icons.calendar_today,
              title: 'مدة التعاقد',
              content: [
                'تاريخ بدء التعاقد: $formattedStartDate',
                'مدة التعاقد: $contractDuration',
              ],
              context: context,
            ),
            _divider(),
            _buildContractSection(
              icon: Icons.payment,
              title: 'طريقة الدفع',
              content: ['المتفق عليها: ${contact.paymentMethod}'],
              context: context,
            ),
            _divider(),
            _buildContractSection(
              icon: Icons.local_shipping_outlined,
              title: 'الكمية المصدرة',
              content: [
                'الاجمالي: ${contact.totalDeliveredKg} كجم ',
                'شحنات متعاقد عليها: ${contact.shipmentsInContract.toString().padLeft(2, '0')} شحنة ',
                'شحنات تمت من التعاقد: ${user.deliveredInContract.toString().padLeft(2, '0')} شحنة ',
              ],
              context: context,
            ),
            _divider(),
            _buildContractSection(
              icon: Icons.warning_amber_outlined,
              title: 'شروط خاصة',
              content: [
                'في حالة عدم الرضا عن الشحنة يتم رفضها',
                'التأخير في الشحن يترتب عليه غرامة',
              ],
              context: context,
            ),
            _divider(),
            _buildTypeUsed(context, contact.types),
          ],
        ),
      ),
    );
  }

  // Format date in Arabic (e.g., "7 يوليو 2025")
  String _formatArabicDate(DateTime date) {
    final arabicMonths = {
      1: 'يناير',
      2: 'فبراير',
      3: 'مارس',
      4: 'أبريل',
      5: 'مايو',
      6: 'يونيو',
      7: 'يوليو',
      8: 'أغسطس',
      9: 'سبتمبر',
      10: 'أكتوبر',
      11: 'نوفمبر',
      12: 'ديسمبر',
    };

    return '${date.day} ${arabicMonths[date.month]} ${date.year}';
  }

  // Calculate contract duration in Arabic
  String _calculateContractDuration(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate);

    // Calculate years, months, and days
    int years = (difference.inDays / 365).floor();
    int remainingDays = difference.inDays % 365;
    int months = (remainingDays / 30).floor();
    int days = remainingDays % 30;

    List<String> parts = [];

    if (years > 0) {
      if (years == 1) {
        parts.add('سنة');
      } else if (years == 2) {
        parts.add('سنتان');
      } else if (years >= 3 && years <= 10) {
        parts.add('$years سنوات');
      } else {
        parts.add('$years سنة');
      }
    }

    if (months > 0) {
      if (months == 1) {
        parts.add('شهر');
      } else if (months == 2) {
        parts.add('شهران');
      } else if (months >= 3 && months <= 10) {
        parts.add('$months شهور');
      } else {
        parts.add('$months شهر');
      }
    }

    if (days > 0) {
      if (days == 1) {
        parts.add('يوم');
      } else if (days == 2) {
        parts.add('يومان');
      } else if (days >= 3 && days <= 10) {
        parts.add('$days أيام');
      } else {
        parts.add('$days يوم');
      }
    }

    if (parts.isEmpty) {
      return 'يوم واحد';
    }

    return parts.join(' و ');
  }

  Widget _buildTypeUsed(BuildContext context, List<String> types) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.integration_instructions_outlined,
                color: const Color(0xFF10B981),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "الأنواع المتعامل بيها",
              style: AppStyles.styleBold16(context),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: types.map((type) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: _decorBox().copyWith(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                type,
                style: AppStyles.styleSemiBold12(
                  context,
                ).copyWith(color: AppColors.primaryColor),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  BoxDecoration _decorBox() => BoxDecoration(
    color: AppColors.primaryColor.withAlpha(25),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.primaryColor.withAlpha(100),
      width: 1.5,
    ),
  );

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Divider(color: Colors.grey[300], thickness: 0.6),
  );

  Widget _buildContractSection({
    required String title,
    required List<String> content,
    required IconData icon,
    required BuildContext context,
    bool highlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF10B981), size: 20),
            ),
            const SizedBox(width: 10),
            Text(title, style: AppStyles.styleBold16(context)),
          ],
        ),
        const SizedBox(height: 12),
        ...content.map((item) {
          final parts = item.split(':');
          final hasLabel = parts.length > 1;

          return Padding(
            padding: const EdgeInsets.only(bottom: 6, right: 48),
            child: RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                children: [
                  if (hasLabel)
                    TextSpan(
                      text: "${parts[0]}: ",
                      style: AppStyles.styleSemiBold12(context).copyWith(
                        color: highlight
                            ? const Color(0xFF059669)
                            : Colors.black,
                      ),
                    ),
                  TextSpan(
                    text: hasLabel ? parts.sublist(1).join(':') : item,
                    style: AppStyles.styleMedium12(
                      context,
                    ).copyWith(color: AppColors.subTextColor),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
