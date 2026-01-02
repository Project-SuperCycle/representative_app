import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/utils/calendar_utils.dart';

class ShipmentsCalendarHeader extends StatelessWidget {
  final DateTime currentDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const ShipmentsCalendarHeader({
    super.key,
    required this.currentDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final monthYear = CalendarUtils.formatMonthYear(currentDate);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onPreviousMonth,
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.greenColor,
              ),
            ),
            Text(
              monthYear,
              style: AppStyles.styleSemiBold20(context).copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.greenColor,
              ),
            ),
            IconButton(
              onPressed: onNextMonth,
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.greenColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: CalendarUtils.arabicDayNames
              .map(
                (day) => FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    day,
                    style: AppStyles.styleSemiBold12(context).copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenColor,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
