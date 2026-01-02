import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';

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
            "قيد التنفيذ",
            style: AppStyles.styleBold16(
              context,
            ).copyWith(color: Color(0xffE04133)),
          ),
        ],
      ),
    );
  }
}
