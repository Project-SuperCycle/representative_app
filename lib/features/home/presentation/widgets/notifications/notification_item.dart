import 'package:flutter/material.dart';
import 'package:supercycle/core/models/notifications_model.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.notification, this.onTap});

  final NotificationModel notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead
                ? Colors.grey[200]!
                : const Color(0xFF10B981).withAlpha(100),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withAlpha(50),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.notifications,
        color: Color(0xFF10B981),
        size: 20,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: AppStyles.styleBold14(context),
              ),
            ),
            if (!notification.isRead) _buildUnreadBadge(),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          notification.message,
          style: AppStyles.styleMedium12(
            context,
          ).copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          notification.time,
          style: AppStyles.styleRegular12(
            context,
          ).copyWith(color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildUnreadBadge() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFF10B981),
        shape: BoxShape.circle,
      ),
    );
  }
}
