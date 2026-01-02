import 'package:flutter/material.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/features/shipment_edit/presentation/widgets/shipment_edit_view_body.dart';

class ShipmentEditView extends StatelessWidget {
  final SingleShipmentModel shipment;
  const ShipmentEditView({super.key, required this.shipment});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: ShipmentEditViewBody(shipment: shipment));
  }
}
