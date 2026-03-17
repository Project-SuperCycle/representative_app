import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/core/models/notifications_model.dart';
import 'package:representative_app/core/utils/app_colors.dart';
import 'package:representative_app/core/utils/app_styles.dart';
import 'package:representative_app/core/widgets/notifications/notification_item.dart';
import 'package:representative_app/core/widgets/notifications/notifications_empty_state.dart';
import 'package:representative_app/core/widgets/notifications/notifications_loading_indicator.dart';
import 'package:representative_app/features/notifications/data/cubits/delete_notification/delete_notification_cubit.dart';
import 'package:representative_app/features/notifications/data/cubits/delete_notification/delete_notification_state.dart';
import 'package:representative_app/features/notifications/data/cubits/get_notifications/get_notifications_cubit.dart';
import 'package:representative_app/features/notifications/data/cubits/get_notifications/get_notifications_state.dart';
import 'package:representative_app/features/notifications/data/cubits/read_notification/read_notification_cubit.dart';
import 'package:representative_app/features/notifications/data/cubits/read_notification/read_notification_state.dart';

class NotificationsViewBody extends StatefulWidget {
  const NotificationsViewBody({super.key});

  @override
  State<NotificationsViewBody> createState() => _NotificationsViewBodyState();
}

class _NotificationsViewBodyState extends State<NotificationsViewBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  List<NotificationModel> _getUnreadNotifications(
    List<NotificationModel> allNotifications,
  ) => allNotifications.where((n) => !n.seen).toList();

  List<NotificationModel> _getReadNotifications(
    List<NotificationModel> allNotifications,
  ) => allNotifications.where((n) => n.seen).toList();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ✅ لما الـ read ينجح → حدّث الـ notification في الـ list
        BlocListener<ReadNotificationCubit, ReadNotificationState>(
          listener: (context, state) {
            if (state is ReadNotificationSuccess) {
              context.read<GetNotificationsCubit>().markAsRead(state.id);
            }
          },
        ),
        // ✅ لما الـ delete ينجح → شيل الـ notification من الـ list
        BlocListener<DeleteNotificationCubit, DeleteNotificationState>(
          listener: (context, state) {
            if (state is DeleteNotificationSuccess) {
              context.read<GetNotificationsCubit>().removeNotification(
                state.id,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: Column(children: [_buildTabs(), _buildContent()]),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      leading: const SizedBox.shrink(),
      centerTitle: true,
      leadingWidth: 0.0,
      title: Text(
        'الإشعارات',
        style: AppStyles.styleBold18(context).copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: const Color(0xFF10B981),
            borderRadius: BorderRadius.circular(10),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[600],
          labelStyle: AppStyles.styleSemiBold14(context),
          unselectedLabelStyle: AppStyles.styleSemiBold14(context),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'غير مقروءة'),
            Tab(text: 'مقروءة'),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: BlocBuilder<GetNotificationsCubit, GetNotificationsState>(
        builder: (context, state) {
          // حالة التحميل
          if (state is GetNotificationsLoading) {
            return NotificationsLoadingIndicator();
          }

          // حالة الخطأ
          if (state is GetNotificationsFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ في تحميل الإشعارات',
                    style: AppStyles.styleMedium16(
                      context,
                    ).copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage,
                    style: AppStyles.styleRegular12(
                      context,
                    ).copyWith(color: Colors.grey[400]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // حالة النجاح أو الحالة الأولية
          final allNotifications = BlocProvider.of<GetNotificationsCubit>(
            context,
          ).notifications;

          return TabBarView(
            controller: _tabController,
            children: [
              // تاب الكل
              _buildNotificationsList(allNotifications, 'الكل'),
              // تاب غير مقروءة
              _buildNotificationsList(
                _getUnreadNotifications(allNotifications),
                'غير مقروءة',
              ),
              // تاب مقروءة
              _buildNotificationsList(
                _getReadNotifications(allNotifications),
                'مقروءة',
              ),
            ],
          );
        },
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
          onRead: () {
            BlocProvider.of<ReadNotificationCubit>(
              context,
            ).readNotification(id: notification.id);
          },
          onDelete: () {
            BlocProvider.of<DeleteNotificationCubit>(
              context,
            ).deleteNotification(id: notification.id);
          },
          notContext: context,
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
