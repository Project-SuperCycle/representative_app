import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class SegmentDestinationSection extends StatelessWidget {
  final String destinationTitle;
  final String destinationAddress;
  const SegmentDestinationSection({
    super.key,
    required this.destinationTitle,
    required this.destinationAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDB2).withAlpha(100),
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Destination details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  bottom: 12.0,
                  right: 5.0,
                  left: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          destinationTitle,
                          style: AppStyles.styleBold12(context),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(width: 6),
                        Image.asset(AppAssets.locationIcon, width: 25),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        destinationAddress,
                        style: AppStyles.styleMedium12(
                          context,
                        ).copyWith(color: AppColors.subTextColor, fontSize: 10),

                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            SvgPicture.asset(AppAssets.rectangleBorder2, fit: BoxFit.fill),
          ],
        ),
      ),
    );
  }
}
