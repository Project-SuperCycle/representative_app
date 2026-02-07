import 'package:flutter/material.dart';
import 'package:representative_app/core/models/shipment/single_shipment_model.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/representative_shipment_edit_body.dart';

class RepresentativeShipmentEditView extends StatelessWidget {
  final SingleShipmentModel shipment;
  const RepresentativeShipmentEditView({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: RepresentativeShipmentEditBody(shipment: shipment));
  }
}
