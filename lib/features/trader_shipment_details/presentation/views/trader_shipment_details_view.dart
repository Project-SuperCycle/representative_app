import 'package:flutter/material.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/features/trader_shipment_details/presentation/widgets/trader_shipment_details_view_body.dart';

class TraderShipmentDetailsView extends StatelessWidget {
  const TraderShipmentDetailsView({super.key, required this.shipment});
  final SingleShipmentModel shipment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TraderShipmentDetailsViewBody(shipment: shipment));
  }
}
