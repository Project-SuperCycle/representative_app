import 'package:flutter/material.dart';
import 'package:supercycle/core/services/dosh_types_manager.dart';
import 'package:supercycle/core/services/services_locator.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';

class RepresentativeShipmentProductCard extends StatelessWidget {
  final DoshItemModel item;
  final int index;

  const RepresentativeShipmentProductCard({
    super.key,
    required this.item,
    required this.index,
  });

  String _getAveragePrice(String name) {
    var price = getIt<DoshTypesManager>().typesList
        .firstWhere((type) => type.name == name)
        .price;
    num averagePrice = price * item.quantity;
    return averagePrice.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: AppStyles.styleSemiBold14(context).copyWith(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.name,
                  style: AppStyles.styleSemiBold14(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ProductDetail(
                  icon: Icons.scale,
                  label: 'الكمية',
                  value: item.quantity.toString(),
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProductDetail(
                  icon: Icons.attach_money,
                  label: 'متوسط السعر',
                  value: _getAveragePrice(item.name),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const ProductDetail({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: AppStyles.styleMedium12(context)),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppStyles.styleSemiBold12(
                context,
              ).copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
