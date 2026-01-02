import 'package:flutter/material.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_states_row/shipment_state_info_row.dart';

class RepresentativeShipmentStates extends StatefulWidget {
  final SingleShipmentModel shipment;
  const RepresentativeShipmentStates({super.key, required this.shipment});

  @override
  State<RepresentativeShipmentStates> createState() =>
      _RepresentativeShipmentStatesState();
}

class _RepresentativeShipmentStatesState
    extends State<RepresentativeShipmentStates> {
  int totalSegments = 0;
  int movedSegments = 0;
  int deliveredSegments = 0;
  double percentage = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      totalSegments = widget.shipment.segments.length;
      movedSegments = widget.shipment.segments
          .where(
            (segment) =>
                segment.status == 'in_transit_to_scale' ||
                segment.status == 'in_transit_to_destination',
          )
          .length;
      deliveredSegments = widget.shipment.segments
          .where((segment) => segment.status == 'delivered')
          .length;
      percentage = (deliveredSegments / totalSegments) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ShipmentStateInfoRow(
                title: "الأجمالى:",
                value: totalSegments,
                valColor: AppColors.mainTextColor,
              ),
              ShipmentStateInfoRow(
                title: "قيد التنفيذ:",
                value: movedSegments,
                valColor: Color(0xffE04133),
              ),
              ShipmentStateInfoRow(
                title: "تم التسليم:",
                value: deliveredSegments,
                valColor: Color(0xff078531),
              ),
            ],
          ),
          SizedBox(width: 30),
          Text(
            "${percentage.toStringAsFixed(1)}%",
            style: AppStyles.styleBold24(context).copyWith(
              color: AppColors.primaryColor,
              fontSize: 36,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
