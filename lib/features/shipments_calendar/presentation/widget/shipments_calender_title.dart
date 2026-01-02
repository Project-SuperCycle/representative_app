import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/generated/l10n.dart';

class ShipmentsCalenderTitle extends StatelessWidget {
  const ShipmentsCalenderTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).table_of_shipments,
          style: AppStyles.styleSemiBold20(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          S.of(context).follow_up_shipments,
          style: AppStyles.styleMedium16(
            context,
          ).copyWith(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
