import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/widgets/shipment/expandable_section.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/deliver_segment_cubit/deliver_segment_cubit.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/fail_segment_cubit/fail_segment_cubit.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/deliver_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/fail_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/shipment_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/weigh_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/segment_deliver_modal/segment_deliver_modal.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/segment_fail_modal/segment_fail_modal.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_action_button.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_deliverd_section.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_weight_info.dart';

class ShipmentSegmentStep3 extends StatefulWidget {
  final ShipmentSegmentModel segment;
  final bool isDelivered;
  final VoidCallback onDeliveredPressed;
  final Function(List<File>?)? onImagesSelected;
  final String shipmentID;
  final String segmentID;
  final WeighSegmentModel? localWeightReport; // Added

  const ShipmentSegmentStep3({
    super.key,
    required this.segment,
    required this.isDelivered,
    required this.onDeliveredPressed,
    required this.onImagesSelected,
    required this.shipmentID,
    required this.segmentID,
    this.localWeightReport, // Added
  });

  @override
  State<ShipmentSegmentStep3> createState() => _ShipmentSegmentStep3State();
}

class _ShipmentSegmentStep3State extends State<ShipmentSegmentStep3> {
  bool isWeightDataExpanded = false;

  void _toggleWeightData() {
    setState(() {
      isWeightDataExpanded = !isWeightDataExpanded;
    });
  }

  // Check if we have weight data (either from API or local)
  bool get _hasWeightData {
    return widget.segment.weightReport != null ||
        widget.localWeightReport != null;
  }

  void _showDeliverModal(BuildContext context) {
    SegmentDeliverModal.show(
      context,
      shipmentID: widget.shipmentID,
      onSubmit: (List<File> images, String name) {
        DeliverSegmentModel deliverModel = DeliverSegmentModel(
          shipmentID: widget.shipmentID,
          segmentID: widget.segmentID,
          receivedByName: name,
          images: images,
        );

        BlocProvider.of<DeliverSegmentCubit>(
          context,
        ).deliverSegment(deliverModel: deliverModel);

        widget.onDeliveredPressed();

        CustomSnackBar.showError(context, 'تم تأكيد الشحنة بنجاح');
      },
    );
  }

  void _showFailModal(BuildContext context) {
    SegmentFailModal.show(
      context,
      shipmentID: widget.shipmentID,
      onSubmit: (List<File> images, String reason) {
        FailSegmentModel failModel = FailSegmentModel(
          shipmentID: widget.shipmentID,
          segmentID: widget.segmentID,
          reason: reason,
          images: images,
        );

        BlocProvider.of<FailSegmentCubit>(
          context,
        ).failSegment(failModel: failModel);

        widget.onDeliveredPressed();

        CustomSnackBar.showWarning(context, 'تم تسجيل العطلة');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        // Show weight data section only if we have data
        if (_hasWeightData)
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ExpandableSection(
              title: 'بيانات الوزنة',
              iconPath: AppAssets.boxPerspective,
              isExpanded: isWeightDataExpanded,
              maxHeight: 280,
              onTap: _toggleWeightData,
              content: SegmentWeightInfo(
                imagePath: AppAssets.miniature,
                segment: widget.segment,
                localWeightReport: widget.localWeightReport, // Pass local data
              ),
            ),
          ),

        // Show message if no weight data available
        if (!_hasWeightData)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange[700], size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'لا توجد بيانات وزنة متاحة حاليًا',
                    style: TextStyle(
                      color: Colors.orange[900],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 20),

        // Action buttons or status
        widget.segment.status == "failed"
            ? SegmentStateInfo(
                title: "حدث مشكلة",
                icon: FontAwesomeIcons.xmark,
                mainColor: AppColors.failureColor,
              )
            : widget.isDelivered
            ? SegmentStateInfo(
                title: "تم التسليم",
                icon: Icons.check_circle_outline_rounded,
                mainColor: AppColors.primaryColor,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SegmentActionButton(
                        title: "تم التوصيل",
                        onPressed: () => _showDeliverModal(context),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: SegmentActionButton(
                        backgroundColor: AppColors.failureColor,
                        title: "عطلة",
                        onPressed: () => _showFailModal(context),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
