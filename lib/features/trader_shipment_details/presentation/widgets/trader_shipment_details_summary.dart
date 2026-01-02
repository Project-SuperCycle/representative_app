import 'package:flutter/material.dart';
import 'package:supercycle/core/services/dosh_types_manager.dart';
import 'package:supercycle/core/services/services_locator.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';

class TraderShipmentDetailsSummary extends StatelessWidget {
  final List<DoshItemModel> items;

  num _getPrice(String name) {
    try {
      var price = getIt<DoshTypesManager>().typesList
          .firstWhere((type) => type.name == name)
          .price;
      return price;
    } catch (e) {
      return 0;
    }
  }

  const TraderShipmentDetailsSummary({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    num totalQuantity = 0;
    num totalValue = 0;

    for (var product in items) {
      num qty = product.quantity;
      num price = _getPrice(product.name);

      totalQuantity += qty;
      totalValue += qty * price;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.green.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate_rounded,
                color: Colors.green.shade600,
                size: 25,
              ),
              const SizedBox(width: 8),
              Text(
                'إجمالي الشحنة',
                style: AppStyles.styleSemiBold14(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إجمالي الكمية',
                      style: AppStyles.styleSemiBold14(
                        context,
                      ).copyWith(color: Colors.green.shade600),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${totalQuantity.toString()} كجم',
                      style: AppStyles.styleSemiBold14(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'إجمالي القيمة التقديرية',
                        style: AppStyles.styleSemiBold14(
                          context,
                        ).copyWith(color: Colors.green.shade600),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${totalValue.toStringAsFixed(0)} جنيه',
                      style: AppStyles.styleSemiBold14(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
