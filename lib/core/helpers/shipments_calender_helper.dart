import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';

class ShipmentsCalendarHelper {
  final List<ShipmentModel> shipments;
  ShipmentsCalendarHelper({required this.shipments});

  bool areAllShipmentsDeliveredWithTime(String dateKey) {
    final shipmentsForDate = getShipmentsForDate(dateKey);
    return shipmentsForDate.isNotEmpty &&
        shipmentsForDate.every((s) => s.status == "delivered");
  }

  bool hasAnyPendingShipmentsWithTime(String dateKey) {
    final shipmentsForDate = getShipmentsForDate(dateKey);
    return shipmentsForDate.any((s) => s.status != "delivered");
  }

  List<ShipmentModel> getShipmentsForDate(String dateKey) {
    try {
      final targetDate = DateTime.parse(dateKey);
      return shipments
          .where((s) => _isSameDate(s.requestedPickupAt, targetDate))
          .toList();
    } catch (e) {
      // Handle invalid date format
      return [];
    }
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
