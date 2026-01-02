import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/environment/presentation/widgets/impact_tab/environmental_impact_saving_item.dart';

class EnvironmentalImpactSavingCard extends StatelessWidget {
  final num fullWeight;
  const EnvironmentalImpactSavingCard({super.key, required this.fullWeight});

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Icon(Icons.air, color: AppColors.greenColor, size: 25),
              SizedBox(width: 8),
              Text(
                'توفيراتك البيئية',
                style: AppStyles.styleSemiBold18(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          EnvironmentalImpactSavingItem(
            icon: Icons.water_drop,
            iconColor: const Color(0xFF3B82F6),
            value: ' ${_calcWaterValue()}  لتر ماء ',
            description: 'وفرت من خلال إعادة التدوير بدلاً من الإنتاج الجديد',
            progress: 0.78,
            progressColor: const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 16),
          EnvironmentalImpactSavingItem(
            icon: Icons.cloud,
            iconColor: const Color(0xFF6B7280),
            value: ' ${_calcCarbonValue()} طن CO₂ ',
            description: 'انبعاثات كربونية تم تجنبها لحماية الغلاف الجوي',
            progress: 0.65,
            progressColor: const Color(0xFF6B7280),
          ),
          const SizedBox(height: 16),
          EnvironmentalImpactSavingItem(
            icon: Icons.bolt,
            iconColor: const Color(0xFFF59E0B),
            value: ' ${_calcEnergyValue()} كيلووات طاقة ',
            description: 'طاقة كهربائية تم توفيرها من عملية التدوير',
            progress: 0.82,
            progressColor: const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  String _calcWaterValue() {
    final double value = (26.5 * fullWeight);

    // Create number formatter with thousand separators
    final formatter = NumberFormat('#,##0.00', 'en_US');
    String formattedValue = formatter.format(value);

    // Add leading zero if value < 10
    if (value < 10) {
      return '0$formattedValue';
    }

    return formattedValue;
  }

  String _calcCarbonValue() {
    final double value = (1.0 * fullWeight);

    // Create number formatter with thousand separators
    final formatter = NumberFormat('#,##0.00', 'en_US');
    String formattedValue = formatter.format(value);

    // Add leading zero if value < 10
    if (value < 10) {
      return '0$formattedValue';
    }

    return formattedValue;
  }

  String _calcEnergyValue() {
    final double value = (4.0 * fullWeight);

    // Create number formatter with thousand separators
    final formatter = NumberFormat('#,##0.00', 'en_US');
    String formattedValue = formatter.format(value);

    // Add leading zero if value < 10
    if (value < 10) {
      return '0$formattedValue';
    }

    return formattedValue;
  }
}
