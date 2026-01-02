import 'package:flutter/material.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/helpers/custom_back_button.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/environment/data/models/trader_eco_info_model.dart';

class EnvironmentalImpactHeader extends StatelessWidget {
  final TraderEcoInfoModel ecoInfoModel;
  const EnvironmentalImpactHeader({super.key, required this.ecoInfoModel});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: kGradientContainer,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.eco,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'أثرك البيئي',
                              style: AppStyles.styleBold24(
                                context,
                              ).copyWith(color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'كل خطوة تصنع فرقًا',
                              style: AppStyles.styleMedium14(
                                context,
                              ).copyWith(color: Color(0xFFD1FAE5)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    CustomBackButton(color: Colors.white, size: 25),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value: ecoInfoModel.stats.totalRecycledKg
                              .toString()
                              .padLeft(2, '0'),
                          label: 'كجم تم تدويرها',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          value: ecoInfoModel.stats.treesPlanted
                              .toString()
                              .padLeft(2, '0'),
                          label: 'شجرة تم زراعتها',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppStyles.styleBold24(context).copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppStyles.styleSemiBold12(
            context,
          ).copyWith(color: Color(0xFFD1FAE5)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
