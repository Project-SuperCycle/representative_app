import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercycle/core/helpers/custom_confirm_dialog.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/start_segment_cubit/start_segment_cubit.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/shipment_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/start_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/weigh_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segment_card/shipment_segment_step1.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segment_card/shipment_segment_step2.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segment_card/shipment_segment_step3.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_card_header.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_card_progress.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_truck_info.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_destination_section.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_products_details.dart';

class ShipmentSegmentCard extends StatefulWidget {
  final String shipmentID;
  final ShipmentSegmentModel segment;

  const ShipmentSegmentCard({
    super.key,
    required this.segment,
    required this.shipmentID,
  });

  @override
  State<ShipmentSegmentCard> createState() => _ShipmentSegmentCardState();
}

class _ShipmentSegmentCardState extends State<ShipmentSegmentCard> {
  bool isMoved = false;
  bool isWeighted = false;
  bool isDelivered = false;
  bool _isLoading = true;

  // Store local weight report from Step2
  WeighSegmentModel? _localWeightReport;

  // Keys for SharedPreferences
  String get _movedKey => 'segment_${widget.segment.id}_isMoved';
  String get _weightedKey => 'segment_${widget.segment.id}_isWeighted';
  String get _deliveredKey => 'segment_${widget.segment.id}_isDelivered';

  @override
  void initState() {
    super.initState();
    _loadSavedStates();
  }

  /// Load saved states from SharedPreferences
  Future<void> _loadSavedStates() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Check saved values first, if not found use status from API
      isMoved =
          prefs.getBool(_movedKey) ??
          (widget.segment.status == "in_transit_to_scale");

      isWeighted =
          prefs.getBool(_weightedKey) ??
          (widget.segment.status == "in_transit_to_destination");

      isDelivered =
          prefs.getBool(_deliveredKey) ??
          (widget.segment.status == "delivered" ||
              widget.segment.status == "failed");

      _isLoading = false;
    });
  }

  /// Save states to SharedPreferences
  Future<void> _saveState(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void onMovedPressed() {
    StartSegmentModel startModel = StartSegmentModel(
      shipmentID: widget.shipmentID,
      segmentID: widget.segment.id,
    );

    showCustomConfirmationDialog(
      context: context,
      title: 'هل أنت متأكد؟',
      message: 'من تحريك العربية',
      onConfirmed: () {
        BlocProvider.of<StartSegmentCubit>(
          context,
        ).startSegment(startModel: startModel);

        setState(() {
          isMoved = true;
        });
        _saveState(_movedKey, true);
      },
    );
  }

  void onWeightedPressed(WeighSegmentModel weighModel) {
    setState(() {
      isWeighted = true;
      _localWeightReport = weighModel; // Store the weight report
    });
    _saveState(_weightedKey, true);
  }

  void onDeliveredPressed() {
    setState(() {
      isDelivered = true;
    });
    _saveState(_deliveredKey, true);
  }

  int get currentStep {
    if (isDelivered) return 3;
    if (isWeighted) return 2;
    if (isMoved) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            SegmentCardHeader(
              driverName: widget.segment.driverName ?? "",
              phoneNumber: widget.segment.driverPhone ?? "",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                children: [
                  // Common Progress Indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    child: SegmentCardProgress(
                      currentStep: currentStep,
                      segmentStatus: widget.segment.status!,
                    ),
                  ),

                  // Common Truck Info
                  SegmentTruckInfo(truckNumber: widget.segment.vehicleNumber!),

                  const SizedBox(height: 4),

                  // Common Destination Section
                  SegmentDestinationSection(
                    destinationTitle: widget.segment.destName ?? "",
                    destinationAddress: widget.segment.destAddress ?? "",
                  ),

                  // Common Products Details
                  if (widget.segment.items.isNotEmpty)
                    ...widget.segment.items.map((item) {
                      return SegmentProductsDetails(
                        quantity: item.quantity,
                        productType: item.name,
                      );
                    }),

                  // Step-specific content
                  _buildCurrentStep(),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Determines which step to display based on current state
  Widget _buildCurrentStep() {
    // Step 3: Show if weight is uploaded (isWeighted = true)
    if (isWeighted || isDelivered) {
      return ShipmentSegmentStep3(
        segment: widget.segment,
        isDelivered: isDelivered,
        onDeliveredPressed: onDeliveredPressed,
        onImagesSelected: (List<File>? image) {},
        shipmentID: widget.shipmentID,
        segmentID: widget.segment.id,
        localWeightReport: _localWeightReport, // Pass local weight report
      );
    }

    // Step 2: Show if moved to warehouse (isMoved = true)
    if (isMoved) {
      return ShipmentSegmentStep2(
        shipmentID: widget.shipmentID,
        segment: widget.segment,
        isWeighted: isWeighted,
        onWeightedPressed: onWeightedPressed, // Updated signature
      );
    }

    // Step 1: Default initial step
    return ShipmentSegmentStep1(
      shipmentID: widget.shipmentID,
      segment: widget.segment,
      isMoved: isMoved,
      onMovedPressed: onMovedPressed,
    );
  }
}
