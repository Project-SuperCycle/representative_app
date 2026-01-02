import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/environment/presentation/widgets/achievements_tab/badge_item.dart';

class BadgesCard extends StatelessWidget {
  const BadgesCard({super.key});

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
          Text('شاراتك البيئية', style: AppStyles.styleBold18(context)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BadgeItem(
                icon: Icons.emoji_events,
                color: const Color(0xFFFBBF24),
                label: 'بطل البيئة',
                sublabel: 'المستوى 3',
                isUnlocked: true,
              ),
              BadgeItem(
                icon: Icons.park,
                color: Colors.grey,
                label: 'زارع الغابات',
                sublabel: 'مقفل',
                isUnlocked: false,
              ),
              BadgeItem(
                icon: Icons.eco,
                color: const Color(0xFF10B981),
                label: 'صديق الأرض',
                sublabel: 'المستوى 2',
                isUnlocked: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
