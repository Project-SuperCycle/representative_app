import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تحدي الشهر',
            style: AppStyles.styleBold18(context).copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            'وفر 3000 لتر ماء هذا الشهر واحصل على شارة خاصة!',
            style: AppStyles.styleMedium14(
              context,
            ).copyWith(color: Color(0xFFDDD6FE)),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.73,
            backgroundColor: Colors.white.withAlpha(50),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
          const SizedBox(height: 12),
          Text(
            '2,190 / 3,000 لتر (73%)',
            style: AppStyles.styleMedium12(
              context,
            ).copyWith(color: Color(0xFFDDD6FE)),
          ),
        ],
      ),
    );
  }
}
