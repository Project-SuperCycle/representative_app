import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';

class CalendarUtils {
  static const List<String> arabicDayNames = [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  static bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String formatDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd', 'en').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat.yMMMM('ar').format(date);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat.yMMMMEEEEd('ar').format(date);
  }

  /// يحدد لون الشحنات لليوم
  static Color getShipmentColor(List<ShipmentModel> shipments) {
    final allDelivered = shipments.every((s) => s.status == "delivered");
    final anyPending = shipments.any((s) => s.status == "pending");

    if (allDelivered) return Colors.green[600]!; // كله متسلم
    if (anyPending) return Colors.red[600]!; // لسه فيه pending
    return Colors.grey[300]!; // fallback
  }

  static CalendarInfo getCalendarInfo(DateTime currentDate) {
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final daysInMonth = DateTime(
      currentDate.year,
      currentDate.month + 1,
      0,
    ).day;
    final firstWeekday = firstDayOfMonth.weekday % 7;

    return CalendarInfo(
      firstDayOfMonth: firstDayOfMonth,
      daysInMonth: daysInMonth,
      firstWeekday: firstWeekday,
    );
  }

  static DateTime getPreviousMonth(DateTime currentDate) {
    return DateTime(currentDate.year, currentDate.month - 1, 1);
  }

  static DateTime getNextMonth(DateTime currentDate) {
    return DateTime(currentDate.year, currentDate.month + 1, 1);
  }
}

class CalendarInfo {
  final DateTime firstDayOfMonth;
  final int daysInMonth;
  final int firstWeekday;

  CalendarInfo({
    required this.firstDayOfMonth,
    required this.daysInMonth,
    required this.firstWeekday,
  });
}
