import 'package:flutter/material.dart';
import 'package:representative_app/core/helpers/custom_fading_widget.dart';

class ShipmentsCalendarGridLoadingIndicator extends StatelessWidget {
  final DateTime currentDate;

  const ShipmentsCalendarGridLoadingIndicator({
    super.key,
    required this.currentDate,
  });

  int get _firstWeekday {
    final firstDay = DateTime(currentDate.year, currentDate.month, 1);
    // الـ grid بيبدأ من الأحد (0) — نفس CalendarUtils
    return firstDay.weekday % 7;
  }

  int get _daysInMonth {
    return DateTime(currentDate.year, currentDate.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> dayWidgets = [];

    // ----- Empty cells قبل أول يوم -----
    for (int i = 0; i < _firstWeekday; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }

    // ----- Shimmer day cells -----
    for (int day = 1; day <= _daysInMonth; day++) {
      dayWidgets.add(_CalendarDayShimmer(index: day));
    }

    return GridView.count(
      crossAxisCount: 7,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: dayWidgets,
    );
  }
}

// ── Single shimmer day cell ───────────────────────────────────────────────────
class _CalendarDayShimmer extends StatelessWidget {
  const _CalendarDayShimmer({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: const CircleBorder(),
      child: CustomFadingWidget(
        duration: Duration(milliseconds: 800 + ((index % 7) * 60)),
        child: CustomFadingWidget.circle(radius: 20),
      ),
    );
  }
}
