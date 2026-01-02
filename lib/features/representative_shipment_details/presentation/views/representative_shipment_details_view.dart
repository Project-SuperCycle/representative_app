import 'package:flutter/material.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_details/presentation/widgets/representative_shipment_details_view_body.dart';

class RepresentativeShipmentDetailsView extends StatelessWidget {
  const RepresentativeShipmentDetailsView({super.key, required this.shipment});
  final SingleShipmentModel shipment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepresentativeShipmentDetailsViewBody(shipment: shipment),
    );
  }
}
