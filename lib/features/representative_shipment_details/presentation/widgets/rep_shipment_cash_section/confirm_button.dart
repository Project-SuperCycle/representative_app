import 'dart:io';

import 'package:flutter/material.dart';
import 'package:representative_app/core/utils/app_colors.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/rep_shipment_cash_section/rep_shipment_cash_section.dart';

class ConfirmButton extends StatefulWidget {
  final AnimationController pulseController;
  final Animation<double> pulseAnim;
  final bool enabled;
  final List<ShipmentCashItem> shipments;
  final Function(List<ShipmentCashItem>, File?)? onConfirm;

  final double totalSelected;

  final File? receiptImage;
  const ConfirmButton({
    super.key,
    required this.pulseController,
    required this.pulseAnim,
    required this.enabled,
    required this.shipments,
    required this.receiptImage,
    required this.totalSelected,
    this.onConfirm,
  });

  @override
  State<ConfirmButton> createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends State<ConfirmButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      child: AnimatedBuilder(
        animation: widget.pulseAnim,
        builder: (_, child) => Transform.scale(
          scale: widget.enabled ? widget.pulseAnim.value : 1.0,
          child: child,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: widget.enabled
                ? () {
                    final selected = widget.shipments
                        .where((s) => s.isSelected)
                        .toList();
                    widget.onConfirm?.call(selected, widget.receiptImage);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              disabledBackgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.white,
              disabledForegroundColor: AppColors.subTextColor,
              elevation: widget.enabled ? 4 : 0,
              shadowColor: AppColors.primaryColor.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 20,
                  color: widget.enabled ? Colors.white : AppColors.subTextColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'تأكيد التحصيل',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: widget.enabled
                        ? Colors.white
                        : AppColors.subTextColor,
                  ),
                ),
                if (widget.enabled) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${widget.totalSelected.toStringAsFixed(2)} ج.م',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
