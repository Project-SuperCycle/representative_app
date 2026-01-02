import 'package:flutter/material.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/representative_shipment_edit_body.dart';

class RepresentativeShipmentEditView extends StatelessWidget {
  final SingleShipmentModel shipment;
  const RepresentativeShipmentEditView({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: RepresentativeShipmentEditBody(shipment: shipment));
  }
}
