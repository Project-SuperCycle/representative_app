import 'package:flutter/material.dart';
import 'package:supercycle/core/helpers/shipments_calender_helper.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/utils/calendar_utils.dart';
import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';

class ShipmentCalendarDay extends StatefulWidget {
  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;
  final List<ShipmentModel> shipments;

  const ShipmentCalendarDay({
    super.key,
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
    required this.shipments,
  });

  @override
  State<ShipmentCalendarDay> createState() => _ShipmentCalendarDayState();
}

class _ShipmentCalendarDayState extends State<ShipmentCalendarDay> {
  Color _determineFillColor() {
    final dateKey = CalendarUtils.formatDateKey(widget.date);
    final shipmentsHelper = ShipmentsCalendarHelper(
      shipments: widget.shipments,
    );

    if (widget.isSelected) {
      return Colors.blueAccent;
    }

    if (widget.isToday) {
      return Colors.blueAccent;
    }

    if (shipmentsHelper.hasAnyPendingShipmentsWithTime(dateKey)) {
      return Colors.deepOrange.shade500;
    }

    if (shipmentsHelper.areAllShipmentsDeliveredWithTime(dateKey)) {
      return Color(0xff3BC567);
    }

    return Colors.grey.shade200;
  }

  @override
  Widget build(BuildContext context) {
    final fillColor = _determineFillColor();
    final isHighlight = fillColor != Colors.grey.shade200;

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Container(
          decoration: BoxDecoration(color: fillColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          height: 40,
          width: 40,
          child: Text(
            '${widget.date.day}',
            style: AppStyles.styleRegular16(context).copyWith(
              color: isHighlight ? Colors.white : Colors.black,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
