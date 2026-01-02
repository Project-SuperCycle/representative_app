import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class SegmentTruckInfo extends StatelessWidget {
  final String truckNumber;
  const SegmentTruckInfo({super.key, required this.truckNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            truckNumber,
            style: AppStyles.styleSemiBold16(
              context,
            ).copyWith(color: AppColors.subTextColor),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(width: 10),
          Text(
            'رقم السيارة :',
            style: AppStyles.styleBold16(context),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(AppAssets.deliveryIcon),
        ],
      ),
    );
  }
}
