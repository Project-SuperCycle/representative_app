import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            type == 'الكل' ? 'لا يوجد إشعارات بعد' : 'لا توجد إشعارات $type',
            style: AppStyles.styleMedium16(
              context,
            ).copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
