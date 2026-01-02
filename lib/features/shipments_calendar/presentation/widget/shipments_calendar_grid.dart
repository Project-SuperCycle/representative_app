import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/calendar_utils.dart';
import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';
import 'package:supercycle/features/shipments_calendar/presentation/widget/shipments_calendar_day.dart';

class ShipmentsCalendarGrid extends StatelessWidget {
  final DateTime currentDate;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final List<ShipmentModel> shipments;

  const ShipmentsCalendarGrid({
    super.key,
    required this.currentDate,
    this.selectedDate,
    required this.onDateSelected,
    required this.shipments,
  });

  @override
  Widget build(BuildContext context) {
    final calendarInfo = CalendarUtils.getCalendarInfo(currentDate);
    final List<Widget> dayWidgets = [];

    for (int i = 0; i < calendarInfo.firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= calendarInfo.daysInMonth; day++) {
      final date = DateTime(currentDate.year, currentDate.month, day);
      final isToday = CalendarUtils.isSameDate(date, DateTime.now());
      final isSelected =
          selectedDate != null && CalendarUtils.isSameDate(date, selectedDate!);

      dayWidgets.add(
        ShipmentCalendarDay(
          shipments: shipments,
          date: date,
          isToday: isToday,
          isSelected: isSelected,
          onTap: () => onDateSelected(date),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: dayWidgets,
    );
  }
}
