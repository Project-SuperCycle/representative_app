import 'package:flutter/material.dart';
import 'package:representative_app/core/models/shipment/single_shipment_model.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/representative_shipment_review_body.dart';

class RepresentativeShipmentReviewView extends StatelessWidget {
  final SingleShipmentModel shipment;
  const RepresentativeShipmentReviewView({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: RepresentativeShipmentReviewBody(shipment: shipment));
  }
}
