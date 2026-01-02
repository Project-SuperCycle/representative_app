import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class ShipmentStateInfoRow extends StatelessWidget {
  final String title;
  final num value;
  final Color valColor;

  const ShipmentStateInfoRow({
    super.key,
    required this.title,
    required this.value,
    required this.valColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: AppStyles.styleBold14(
                context,
              ).copyWith(color: AppColors.subTextColor),
            ),
          ),
          SizedBox(width: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value.toString(),
              style: AppStyles.styleBold14(context).copyWith(color: valColor),
            ),
          ),
        ],
      ),
    );
  }
}
