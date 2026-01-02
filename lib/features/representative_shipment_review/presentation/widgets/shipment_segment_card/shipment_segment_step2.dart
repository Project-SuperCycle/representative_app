import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/weigh_segment_cubit/weigh_segment_cubit.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/shipment_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/weigh_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_deliverd_section.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_weight_section.dart';

class ShipmentSegmentStep2 extends StatefulWidget {
  final String shipmentID;
  final ShipmentSegmentModel segment;
  final bool isWeighted;
  final Function(WeighSegmentModel) onWeightedPressed; // Updated signature

  const ShipmentSegmentStep2({
    super.key,
    required this.shipmentID,
    required this.segment,
    required this.isWeighted,
    required this.onWeightedPressed,
  });

  @override
  State<ShipmentSegmentStep2> createState() => _ShipmentSegmentStep2State();
}

class _ShipmentSegmentStep2State extends State<ShipmentSegmentStep2> {
  List<File> images = [];
  TextEditingController weightController = TextEditingController();

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  void onWeightedPressed() {
    // Create the weight model
    WeighSegmentModel weighModel = WeighSegmentModel(
      shipmentID: widget.shipmentID,
      segmentID: widget.segment.id,
      images: images,
      actualWeightKg: double.tryParse(weightController.text) ?? 0.0,
    );

    // Call the API
    BlocProvider.of<WeighSegmentCubit>(
      context,
    ).weighSegment(weighModel: weighModel);

    // Pass the weight model to parent
    widget.onWeightedPressed(weighModel);
  }

  @override
  Widget build(BuildContext context) {
    return widget.segment.status == "failed"
        ? SegmentStateInfo(
            title: "حدث مشكلة",
            icon: FontAwesomeIcons.xmark,
            mainColor: AppColors.failureColor,
          )
        : SegmentWeightSection(
            weightController: weightController,
            onImagesSelected: (List<File>? weightImages) {
              setState(() {
                images = weightImages ?? [];
              });
            },
            onWeightedPressed: onWeightedPressed,
            shipmentID: widget.shipmentID,
            segmentID: widget.segment.id,
          );
  }
}
