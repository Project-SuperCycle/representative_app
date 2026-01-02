import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_confirm_dialog.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/trader_shipment_details/data/cubits/shipment_cubit/shipment_cubit.dart';

class TraderShipmentDetailsSettingsIcon extends StatelessWidget {
  final SingleShipmentModel shipment;

  const TraderShipmentDetailsSettingsIcon({super.key, required this.shipment});

  void onEdit(BuildContext context) {
    GoRouter.of(context).push(EndPoints.shipmentEditView, extra: shipment);
  }

  void onCancel(BuildContext context) {
    showCustomConfirmationDialog(
      context: context,
      title: "إلغاء الشحنة",
      message: "هل أنت متأكد؟",
      onConfirmed: () {
        BlocProvider.of<ShipmentCubit>(
          context,
        ).cancelShipment(shipmentId: shipment.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit(context);
            break;
          case 'cancel':
            onCancel(context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text('Edit', style: AppStyles.styleMedium14(context)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'cancel',
          child: Row(
            children: [
              Icon(Icons.cancel, size: 20, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('Cancel', style: AppStyles.styleMedium14(context)),
            ],
          ),
        ),
      ],
      child: SizedBox(
        width: 24,
        height: 24,
        child: ClipRRect(
          child: Image.asset(
            'assets/images/settings icon.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.settings, color: Colors.grey, size: 24);
            },
          ),
        ),
      ),
    );
  }
}
