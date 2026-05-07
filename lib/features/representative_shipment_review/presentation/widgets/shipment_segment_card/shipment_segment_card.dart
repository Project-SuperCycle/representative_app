import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/features/representative_shipment_review/data/cubits/start_segment_cubit/start_segment_cubit.dart';
import 'package:representative_app/features/representative_shipment_review/data/cubits/start_segment_cubit/start_segment_state.dart';
import 'package:representative_app/features/representative_shipment_review/data/models/shipment_segment_model.dart';
import 'package:representative_app/features/representative_shipment_review/data/models/weigh_segment_model.dart';
import 'package:representative_app/features/representative_shipment_review/data/models/weight_report_model.dart'; // ✅ Import
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/shipment_segment_card/shipment_segment_step1.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/shipment_segment_card/shipment_segment_step2.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/shipment_segment_card/shipment_segment_step3.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_card_header.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_card_progress.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_truck_info.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_destination_section.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_products_details.dart';

enum SegmentStep { initial, moved, weighted, delivered, failed }

class ShipmentSegmentCard extends StatefulWidget {
  final String shipmentID;
  final ShipmentSegmentModel segment;
  final Function(ShipmentSegmentModel updatedSegment)? onSegmentUpdated;

  const ShipmentSegmentCard({
    super.key,
    required this.segment,
    required this.shipmentID,
    this.onSegmentUpdated,
  });

  @override
  State<ShipmentSegmentCard> createState() => _ShipmentSegmentCardState();
}

class _ShipmentSegmentCardState extends State<ShipmentSegmentCard> {
  late ShipmentSegmentModel _currentSegment;
  WeighSegmentModel? _localWeightReport;

  @override
  void initState() {
    super.initState();
    _currentSegment = widget.segment;
  }

  // ✅ CRITICAL FIX: Preserve local state during rebuilds
  @override
  void didUpdateWidget(covariant ShipmentSegmentCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ Only update if this is a DIFFERENT segment (by ID)
    // This preserves local state changes while allowing external updates
    if (oldWidget.segment.id != widget.segment.id) {
      _currentSegment = widget.segment;
      _localWeightReport = null;
    }
    // ✅ If same segment ID, keep our local _currentSegment state
    // This prevents reverting to old status from parent
  }

  // 🔑 Single Source of Truth
  SegmentStep get segmentStep {
    switch (_currentSegment.status) {
      case 'in_transit_to_scale':
        return SegmentStep.moved;
      case 'in_transit_to_destination':
        return SegmentStep.weighted;
      case 'delivered':
        return SegmentStep.delivered;
      case 'failed':
        return SegmentStep.failed;
      default:
        return SegmentStep.initial;
    }
  }

  int get currentStep {
    switch (segmentStep) {
      case SegmentStep.moved:
        return 1;
      case SegmentStep.weighted:
        return 2;
      case SegmentStep.delivered:
      case SegmentStep.failed:
        return 3;
      default:
        return 0;
    }
  }

  void onMovedPressed(String segmentId) {
    if (segmentId != _currentSegment.id) return;

    setState(() {
      _currentSegment = _currentSegment.copyWith(status: 'in_transit_to_scale');
    });

    // ✅ Notify parent with full segment
    widget.onSegmentUpdated?.call(_currentSegment);
  }

  void onWeightedPressed(WeighSegmentModel model) {
    setState(() {
      _localWeightReport = model;

      // ✅ تحويل WeighSegmentModel إلى WeightReportModel
      final weightReport = WeightReportModel(
        actualWeightKg: model.actualWeightKg,
        images: model.images
            .map((file) => file.path)
            .toList(), // ✅ File paths as strings
      );

      _currentSegment = _currentSegment.copyWith(
        status: 'in_transit_to_destination',
        weightReport: weightReport, // ✅ استخدم WeightReportModel
      );
    });

    // ✅ Notify parent with full segment including weight report
    widget.onSegmentUpdated?.call(_currentSegment);
  }

  void onDeliveredPressed() {
    setState(() {
      _currentSegment = _currentSegment.copyWith(status: 'delivered');
    });

    // ✅ Notify parent with full segment
    widget.onSegmentUpdated?.call(_currentSegment);
  }

  void onFailedPressed() {
    setState(() {
      _currentSegment = _currentSegment.copyWith(status: 'failed');
    });

    // ✅ Notify parent with full segment
    widget.onSegmentUpdated?.call(_currentSegment);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartSegmentCubit, StartSegmentState>(
      listenWhen: (_, current) =>
          current is StartSegmentSuccess &&
          current.segmentId == _currentSegment.id,
      listener: (_, state) {
        final success = state as StartSegmentSuccess;
        onMovedPressed(success.segmentId);
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                SegmentCardHeader(
                  driverName: _currentSegment.driverName ?? '',
                  phoneNumber: _currentSegment.driverPhone ?? '',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                        child: SegmentCardProgress(
                          currentStep: currentStep,
                          segmentStatus: _currentSegment.status!,
                        ),
                      ),
                      SegmentTruckInfo(
                        truckNumber: _currentSegment.vehicleNumber!,
                      ),
                      SegmentDestinationSection(
                        destinationTitle: _currentSegment.destName ?? '',
                        destinationAddress: _currentSegment.destAddress ?? '',
                      ),
                      ..._currentSegment.items.map(
                        (item) => SegmentProductsDetails(
                          quantity: item.quantity,
                          productType: item.name,
                        ),
                      ),
                      _buildCurrentStep(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (segmentStep) {
      case SegmentStep.moved:
        return ShipmentSegmentStep2(
          shipmentID: widget.shipmentID,
          segment: _currentSegment,
          isWeighted: false,
          onWeightedPressed: onWeightedPressed,
        );

      case SegmentStep.weighted:
      case SegmentStep.delivered:
      case SegmentStep.failed:
        return ShipmentSegmentStep3(
          segment: _currentSegment,
          isDelivered:
              segmentStep == SegmentStep.delivered ||
              segmentStep == SegmentStep.failed,
          onDeliveredPressed: onDeliveredPressed,
          onFailedPressed: onFailedPressed,
          onImagesSelected: (List<File>? _) {},
          shipmentID: widget.shipmentID,
          segmentID: _currentSegment.id,
          localWeightReport: _localWeightReport,
        );

      case SegmentStep.initial:
        return ShipmentSegmentStep1(
          shipmentID: widget.shipmentID,
          segment: _currentSegment,
          isMoved: false,
        );
    }
  }
}
