import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class TreeInitiativeCard extends StatelessWidget {
  final num trees;
  const TreeInitiativeCard({super.key, required this.trees});

  @override
  Widget build(BuildContext context) {
    final kgNO = trees * 20;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('مبادرة 100 مليون شجرة', style: AppStyles.styleBold18(context)),
          const SizedBox(height: 12),
          Text(
            'نحن فخورون بمساهمتنا في المبادرة الوطنية لزراعة 100 مليون شجرة. كل نقطة تجمعها تساهم مباشرة في تخضير مصر وتحسين جودة الهواء للأجيال القادمة.',
            style: AppStyles.styleRegular14(
              context,
            ).copyWith(color: AppColors.subTextColor),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF6EE7B7)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'إجمالي أشجارك',
                      style: AppStyles.styleSemiBold14(context),
                    ),
                    Text(
                      ' ${trees.toString().padLeft(2, '0')} شجرة',
                      style: AppStyles.styleBold20(
                        context,
                      ).copyWith(color: Color(0xFF059669)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.park, color: Color(0xFF059669), size: 16),
                    const SizedBox(width: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'تساهم في امتصاص $kgNO كجم من CO₂ سنويًا',
                        style: AppStyles.styleSemiBold12(
                          context,
                        ).copyWith(color: AppColors.subTextColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
