import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supercycle/core/models/notifications_model.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/home/presentation/widgets/notifications/notification_item.dart';

class NotificationsOverlay {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  static void show(BuildContext context) {
    if (_isShowing) return;

    _isShowing = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => const NotificationsPanel(),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    if (!_isShowing) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShowing = false;
  }

  static void toggle(BuildContext context) {
    if (_isShowing) {
      hide();
    } else {
      show(context);
    }
  }
}

class NotificationsPanel extends StatefulWidget {
  const NotificationsPanel({super.key});

  @override
  State<NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<NotificationsPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  int _selectedTabIndex = 0;

  // TODO: استبدليها بداتا من الـ API
  final List<NotificationModel> _allNotifications = [
    NotificationModel(
      id: '1',
      title: 'شحنة جديدة',
      message: 'تم إضافة شحنة جديدة #12345',
      time: 'منذ ساعة',
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      title: 'تم التسليم',
      message: 'تم تسليم الشحنة #12340 بنجاح',
      time: 'منذ 3 ساعات',
      isRead: true,
    ),
    NotificationModel(
      id: '3',
      title: 'تحديث مهم',
      message: 'يرجى تحديث معلومات الحساب الخاص بك',
      time: 'منذ 5 ساعات',
      isRead: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() async {
    await _controller.reverse();
    NotificationsOverlay.hide();
  }

  List<NotificationModel> get _filteredNotifications {
    if (_selectedTabIndex == 0) return _allNotifications;
    if (_selectedTabIndex == 1) {
      return _allNotifications.where((n) => !n.isRead).toList();
    }
    return _allNotifications.where((n) => n.isRead).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Backdrop مع Blur
          GestureDetector(
            onTap: _close,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withAlpha(150)),
              ),
            ),
          ),

          // الـ Panel نفسه
          SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 60,
                  left: 16,
                  right: 16,
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                  maxWidth: 600,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(100),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    _buildTabs(),
                    Flexible(child: _buildContent()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withAlpha(50),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notifications_active,
              color: Color(0xFF10B981),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الإشعارات', style: AppStyles.styleBold18(context)),
                Text(
                  '${_allNotifications.where((n) => !n.isRead).length} إشعار جديد',
                  style: AppStyles.styleRegular12(
                    context,
                  ).copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _close,
            icon: const Icon(Icons.close, size: 24),
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildTab('الكل', 0),
          const SizedBox(width: 8),
          _buildTab('غير مقروءة', 1),
          const SizedBox(width: 8),
          _buildTab('مقروءة', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF10B981) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppStyles.styleSemiBold14(
              context,
            ).copyWith(color: isSelected ? Colors.white : Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_filteredNotifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemCount: _filteredNotifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return NotificationItem(
          notification: _filteredNotifications[index],
          onTap: () {
            // TODO: Handle notification tap
            _close();
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedTabIndex == 0
                  ? 'لا يوجد إشعارات بعد'
                  : _selectedTabIndex == 1
                  ? 'لا توجد إشعارات غير مقروءة'
                  : 'لا توجد إشعارات مقروءة',
              style: AppStyles.styleMedium16(
                context,
              ).copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم إعلامك عند وصول إشعارات جديدة',
              style: AppStyles.styleRegular12(
                context,
              ).copyWith(color: Colors.grey[400]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
