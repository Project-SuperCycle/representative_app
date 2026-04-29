import 'package:flutter/material.dart';
import 'package:representative_app/features/representative_shipment_details/data/models/shipment_cash_item.dart';

class ShipmentTile extends StatelessWidget {
  final ShipmentCashItem item;
  final Color green;
  final Color greenLight;
  final ValueChanged<bool?> onChanged;

  const ShipmentTile({
    super.key,
    required this.item,
    required this.green,
    required this.greenLight,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: item.isSelected ? greenLight : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      duration: const Duration(milliseconds: 250),
      child: InkWell(
        onTap: () => onChanged(!item.isSelected),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Custom checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: item.isSelected ? green : Colors.transparent,
                  border: Border.all(
                    color: item.isSelected ? green : Colors.grey.shade400,
                    width: 1.8,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: item.isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Shipment icon
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: item.isSelected
                      ? green.withValues(alpha: 0.15)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  size: 16,
                  color: item.isSelected ? green : Colors.grey.shade500,
                ),
              ),
              const SizedBox(width: 10),

              // Shipment number
              Expanded(
                child: Text(
                  item.shipmentNumber,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: item.isSelected
                        ? const Color(0xFF1A1A2E)
                        : Colors.grey.shade700,
                  ),
                ),
              ),

              // Amount chip
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: item.isSelected ? green : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${item.amount.toStringAsFixed(2)} ج.م',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: item.isSelected
                        ? Colors.white
                        : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
