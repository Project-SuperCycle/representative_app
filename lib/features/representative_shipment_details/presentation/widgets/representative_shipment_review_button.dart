import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/widgets/custom_button.dart';

class RepresentativeShipmentReviewButton extends StatelessWidget {
  final SingleShipmentModel shipment;
  const RepresentativeShipmentReviewButton({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPress: () => _showShipmentReview(context),
      title: "مراجعة الشحنة",
    );
  }

  void _showShipmentReview(BuildContext context) {
    GoRouter.of(
      context,
    ).push(EndPoints.representativeShipmentReviewView, extra: shipment);
  }
}
