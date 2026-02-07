import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/core/helpers/custom_confirm_dialog.dart';
import 'package:representative_app/core/helpers/custom_loading_indicator.dart';
import 'package:representative_app/core/helpers/custom_snack_bar.dart';
import 'package:representative_app/features/representative_shipment_review/data/cubits/start_segment_cubit/start_segment_cubit.dart';
import 'package:representative_app/features/representative_shipment_review/data/cubits/start_segment_cubit/start_segment_state.dart';
import 'package:representative_app/features/representative_shipment_review/data/models/shipment_segment_model.dart';
import 'package:representative_app/features/representative_shipment_review/data/models/start_segment_model.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_action_button.dart';

class ShipmentSegmentStep1 extends StatelessWidget {
  final String shipmentID;
  final ShipmentSegmentModel segment;
  final bool isMoved;

  const ShipmentSegmentStep1({
    super.key,
    required this.shipmentID,
    required this.segment,
    required this.isMoved,
  });

  void _handleMoveAction(BuildContext context) {
    StartSegmentModel startModel = StartSegmentModel(
      shipmentID: shipmentID,
      segmentID: segment.id,
    );

    showCustomConfirmationDialog(
      context: context,
      title: 'هل أنت متأكد؟',
      message: 'من تحريك العربية',
      onConfirmed: () {
        BlocProvider.of<StartSegmentCubit>(context).startSegment(
          startModel: startModel,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocConsumer<StartSegmentCubit, StartSegmentState>(
            // ✅ Only listen/build for THIS segment
            listenWhen: (previous, current) {
              if (current is StartSegmentSuccess) {
                return current.segmentId == segment.id;
              }
              if (current is StartSegmentFailure) {
                return current.segmentId == segment.id;
              }
              return false;
            },
            listener: (context, state) {
              // ✅ Show snackbars for THIS segment only
              if (state is StartSegmentSuccess &&
                  state.segmentId == segment.id) {
                CustomSnackBar.showSuccess(context, state.message);
              }

              if (state is StartSegmentFailure &&
                  state.segmentId == segment.id) {
                CustomSnackBar.showError(context, state.errorMessage);
              }
            },
            buildWhen: (previous, current) {
              if (current is StartSegmentLoading) {
                return current.segmentId == segment.id;
              }
              if (current is StartSegmentSuccess) {
                return current.segmentId == segment.id;
              }
              if (current is StartSegmentFailure) {
                return current.segmentId == segment.id;
              }
              return false;
            },
            builder: (context, state) {
              // ✅ Check if loading is for THIS segment
              final isLoading = state is StartSegmentLoading &&
                  state.segmentId == segment.id;

              return isLoading
                  ? SizedBox(
                width: 60,
                height: 60,
                child: Center(child: CustomLoadingIndicator()),
              )
                  : SegmentActionButton(
                title: "تم التحرك",
                onPressed: () => _handleMoveAction(context),
              );
            },
          ),
        ],
      ),
    );
  }
}