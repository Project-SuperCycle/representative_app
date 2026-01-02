import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/start_segment_cubit/start_segment_cubit.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/start_segment_cubit/start_segment_state.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/shipment_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segments_parts/segment_action_button.dart';

class ShipmentSegmentStep1 extends StatelessWidget {
  final String shipmentID;
  final ShipmentSegmentModel segment;
  final bool isMoved;
  final VoidCallback onMovedPressed;

  const ShipmentSegmentStep1({
    super.key,
    required this.shipmentID,
    required this.segment,
    required this.isMoved,
    required this.onMovedPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocConsumer<StartSegmentCubit, StartSegmentState>(
            listener: (context, state) {
              if (state is StartSegmentSuccess) {
                CustomSnackBar.showSuccess(context, state.message);
              }
              if (state is StartSegmentFailure) {
                CustomSnackBar.showError(context, state.errorMessage);
              }
            },
            builder: (context, state) {
              return (state is StartSegmentLoading)
                  ? SizedBox(
                      width: 60,
                      height: 60,
                      child: Center(child: CustomLoadingIndicator()),
                    )
                  : SegmentActionButton(
                      title: "تم التحرك",
                      onPressed: onMovedPressed,
                    );
            },
          ),
        ],
      ),
    );
  }
}
