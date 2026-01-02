import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/representative_shipment_details/data/cubits/accept_shipment_cubit/accept_shipment_cubit.dart';
import 'package:supercycle/features/representative_shipment_details/data/cubits/accept_shipment_cubit/accept_shipment_state.dart';
import 'package:supercycle/features/representative_shipment_details/data/cubits/reject_shipment_cubit/reject_shipment_cubit.dart';
import 'package:supercycle/features/representative_shipment_details/data/cubits/reject_shipment_cubit/reject_shipment_state.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/accept_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/reject_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_details/presentation/widgets/rep_shipment_action_modal/representative_shipment_modal.dart';

class RepresentativeShipmentActionsRow extends StatelessWidget {
  final SingleShipmentModel shipment;
  final VoidCallback onActionTaken;

  const RepresentativeShipmentActionsRow({
    super.key,
    required this.shipment,
    required this.onActionTaken,
  });

  void _showConfirmModal(BuildContext context) {
    RepresentativeShipmentModal.show(
      context,
      actionType: ShipmentActionType.confirm,
      shipment: shipment,
      onSubmit: (List<File> images, String notes, double rating) {
        AcceptShipmentModel acceptShipmentModel = AcceptShipmentModel(
          shipmentID: shipment.id,
          notes: notes,
          images: images,
          rank: rating,
        );

        BlocProvider.of<AcceptShipmentCubit>(
          context,
        ).acceptShipment(acceptModel: acceptShipmentModel);

        onActionTaken();
        GoRouter.of(context).pop();

        CustomSnackBar.showSuccess(context, 'تم تأكيد الشحنة بنجاح');
      },
    );
  }

  void _showRejectModal(BuildContext context) {
    RepresentativeShipmentModal.show(
      context,
      actionType: ShipmentActionType.reject,
      shipment: shipment,
      onSubmit: (List<File> images, String reason, double rating) {
        RejectShipmentModel rejectShipmentModel = RejectShipmentModel(
          shipmentID: shipment.id,
          reason: reason,
          images: images,
          rank: rating,
        );

        BlocProvider.of<RejectShipmentCubit>(
          context,
        ).rejectShipment(rejectModel: rejectShipmentModel);

        // Mark action as taken
        onActionTaken();
        CustomSnackBar.showSuccess(context, 'تم رفض الشحنة بنجاح');
      },
    );
  }

  Future<void> _handleEdit(BuildContext context) async {
    // Navigate to edit page and wait for result
    final result = await GoRouter.of(
      context,
    ).push(EndPoints.representativeShipmentEditView, extra: shipment);

    // If edit was successful, mark action as taken
    if (result == true) {
      onActionTaken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: BlocConsumer<AcceptShipmentCubit, AcceptShipmentState>(
              listener: (context, state) {
                if (state is AcceptRepShipmentFailure) {
                  CustomSnackBar.showError(context, state.errorMessage);
                }
              },
              builder: (context, state) {
                return (state is AcceptRepShipmentLoading)
                    ? SizedBox(
                        width: 60,
                        height: 60,
                        child: const CustomLoadingIndicator(),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _showConfirmModal(context),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'تأكيد الشحنة',
                            style: AppStyles.styleBold14(
                              context,
                            ).copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _handleEdit(context),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'تعديل',
                  style: AppStyles.styleBold14(
                    context,
                  ).copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: BlocConsumer<RejectShipmentCubit, RejectShipmentState>(
              listener: (context, state) {
                if (state is RejectRepShipmentFailure) {
                  CustomSnackBar.showError(context, state.errorMessage);
                }
              },
              builder: (context, state) {
                return (state is RejectRepShipmentLoading)
                    ? SizedBox(
                        width: 60,
                        height: 60,
                        child: const CustomLoadingIndicator(),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.failureColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _showRejectModal(context),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'رفض الشحنة',
                            style: AppStyles.styleBold14(
                              context,
                            ).copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
