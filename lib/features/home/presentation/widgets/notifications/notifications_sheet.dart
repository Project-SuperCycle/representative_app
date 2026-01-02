import 'package:flutter/material.dart';
import 'package:supercycle/core/models/notifications_model.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/home/presentation/widgets/notifications/notification_item.dart';
import 'package:supercycle/features/home/presentation/widgets/notifications/notifications_empty_state.dart';

class NotificationsSheet extends StatefulWidget {
  const NotificationsSheet({super.key});

  @override
  State<NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<NotificationsSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // TODO: استبدليها بداتا من الـ API
  final List<NotificationModel> _allNotifications = [
    // NotificationModel(
    //   id: '1',
    //   title: 'شحنة جديدة',
    //   message: 'تم إضافة شحنة جديدة #12345',
    //   time: 'منذ ساعة',
    //   isRead: false,
    // ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NotificationModel> get _unreadNotifications =>
      _allNotifications.where((n) => !n.isRead).toList();

  List<NotificationModel> get _readNotifications =>
      _allNotifications.where((n) => n.isRead).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [_buildHeader(context), _buildTabs(context), _buildContent()],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text('الإشعارات', style: AppStyles.styleBold18(context)),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF10B981),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF10B981),
        labelStyle: AppStyles.styleSemiBold14(context),
        tabs: const [
          Tab(text: 'الكل'),
          Tab(text: 'غير مقروءة'),
          Tab(text: 'مقروءة'),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList(_allNotifications, 'الكل'),
          _buildNotificationsList(_unreadNotifications, 'غير مقروءة'),
          _buildNotificationsList(_readNotifications, 'مقروءة'),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(
    List<NotificationModel> notifications,
    String type,
  ) {
    if (notifications.isEmpty) {
      return NotificationsEmptyState(type: type);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationItem(
          notification: notification,
          onTap: () => _handleNotificationTap(notification),
        );
      },
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    // TODO: اعملي الأكشن اللي عايزاه لما يضغط على إشعار
  }
}
