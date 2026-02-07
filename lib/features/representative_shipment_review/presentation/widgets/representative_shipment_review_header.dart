import 'package:flutter/material.dart';
import 'package:representative_app/core/utils/app_assets.dart';
import 'package:representative_app/core/utils/app_colors.dart';
import 'package:representative_app/core/utils/app_styles.dart';
import 'package:representative_app/core/models/shipment/single_shipment_model.dart';

class RepresentativeShipmentReviewHeader extends StatelessWidget {
  final SingleShipmentModel shipment;
  const RepresentativeShipmentReviewHeader({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  child: Image.asset(
                    AppAssets.boxPerspective,
                    width: 25,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.orange,
                        size: 20,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    shipment.shipmentNumber,
                    style: AppStyles.styleBold18(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            shipment.statusDisplay,
            style: AppStyles.styleBold16(
              context,
            ).copyWith(color: _getStatusColor()),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (shipment.status) {
      case 'قيد المراجعة':
      case 'بانتظار المعاينة':
        return Color(0xff1624A2);
      case 'تمت الموافقة':
        return Color(0xff3BC567);
      case 'تمت المعاينة':
      case 'في طريق التسليم':
      case 'جار الاستلام':
        return Color(0xffE04133);
      case 'تم الاستلام':
      case 'تم التسليم':
      case 'تسليم جزئي':
        return Color(0xff3BC567);
      case 'تم الرفض':
        return AppColors.failureColor;
      default:
        return Color(0xff1624A2);
    }
  }
}
