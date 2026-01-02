import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/environment/presentation/widgets/trees_tab/point_item.dart';

class EarnPointsCard extends StatelessWidget {
  const EarnPointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('كيف تربح نقاطًا أكثر؟', style: AppStyles.styleBold18(context)),
          const SizedBox(height: 16),
          PointItem(points: '+50', description: 'مقابل كل شحنة تدوير'),
          const SizedBox(height: 12),
          PointItem(points: '+100', description: 'شحنات منتظمة شهريًا'),
          const SizedBox(height: 12),
          PointItem(points: '+200', description: 'دعوة أصدقاء للمشاركة'),
        ],
      ),
    );
  }
}
