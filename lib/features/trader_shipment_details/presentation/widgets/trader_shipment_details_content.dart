import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';
import 'package:supercycle/features/trader_shipment_details/presentation/widgets/trader_shipment_details_summary.dart';
import 'product_card.dart';

class TraderShipmentDetailsContent extends StatelessWidget {
  final List<DoshItemModel> items;

  const TraderShipmentDetailsContent({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.inventory_2, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                'منتجات الشحنة (${items.length} أصناف)',
                style: AppStyles.styleSemiBold14(
                  context,
                ).copyWith(color: Colors.blue.shade700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        ...items.asMap().entries.map((entry) {
          int index = entry.key;
          DoshItemModel item = entry.value;
          return ProductCard(item: item, index: index + 1);
        }),
        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 16),
        TraderShipmentDetailsSummary(items: items),
        const SizedBox(height: 16),
      ],
    );
  }
}
