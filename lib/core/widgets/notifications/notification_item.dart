import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:representative_app/core/helpers/custom_loading_indicator.dart';
import 'package:representative_app/core/helpers/custom_snack_bar.dart';
import 'package:representative_app/core/models/notifications_model.dart';
import 'package:representative_app/core/routes/end_points.dart';
import 'package:representative_app/core/utils/app_styles.dart';
import 'package:representative_app/features/notifications/data/cubits/read_notification/read_notification_cubit.dart';
import 'package:representative_app/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_cubit.dart';
import 'package:representative_app/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_state.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.notContext,
    this.onTap,
    required this.onRead,
    required this.onDelete,
  });

  final NotificationModel notification;
  final BuildContext notContext;
  final VoidCallback? onTap;
  final VoidCallback onRead;
  final VoidCallback onDelete;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShipmentsCalendarCubit, ShipmentsCalendarState>(
      listener: (context, state) {
        if (state is GetShipmentSuccess &&
            state.shipment.id == widget.notification.relatedEntityId) {
          setState(() {
            isLoading = false;
          });
          GoRouter.of(context).push(
            EndPoints.representativeShipmentDetailsView,
            extra: state.shipment,
          );
        } else if (state is GetShipmentFailure) {
          setState(() {
            isLoading = false;
          });
          CustomSnackBar.showError(context, state.errorMessage);
        }
      },
      child: GestureDetector(
        onTap: () =>
            _handleRooting(notification: widget.notification, context: context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.notification.seen
                ? Colors.white
                : const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.notification.seen
                  ? Colors.grey[200]!
                  : const Color(0xFF10B981).withAlpha(100),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _buildIcon(),
                  const SizedBox(height: 16),
                  _buildMenuIcon(context),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return isLoading
        ? Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: CustomLoadingIndicator(),
          )
        : Container(
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

  Widget _buildMenuIcon(BuildContext context) {
    return Builder(
      builder: (iconContext) {
        return GestureDetector(
          onTap: () {
            final box = iconContext.findRenderObject() as RenderBox?;
            if (box == null) return;

            final position = box.localToGlobal(Offset.zero);
            OverlayEntry? overlay;

            overlay = OverlayEntry(
              builder: (_) => GestureDetector(
                onTap: () => overlay?.remove(),
                child: Stack(
                  children: [
                    Positioned(
                      left: position.dx - 150,
                      top: position.dy + 30,
                      child: Material(
                        elevation: 16,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildMenuItem(
                                context: context,
                                icon: Icons.mark_email_read_rounded,
                                iconColor: const Color(0xFF10B981),
                                label: 'قراءة',
                                onTap: () {
                                  widget.onRead();
                                  overlay?.remove();
                                },
                              ),
                              Divider(height: 1, color: Colors.grey[200]),
                              _buildMenuItem(
                                context: context,
                                icon: Icons.delete_rounded,
                                iconColor: Colors.red,
                                label: 'حذف',
                                onTap: () {
                                  widget.onDelete();
                                  overlay?.remove();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            Overlay.of(widget.notContext).insert(overlay);
          },
          child: const Icon(
            Icons.more_horiz_rounded,
            color: Color(0xFF10B981),
            size: 20,
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Text(label, style: AppStyles.styleMedium14(context)),
          ],
        ),
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
                widget.notification.title,
                style: AppStyles.styleBold14(context),
              ),
            ),
            if (!widget.notification.seen) _buildUnreadBadge(),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.notification.body,
          style: AppStyles.styleMedium12(
            context,
          ).copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          widget.notification.time,
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

  void _handleRooting({
    required NotificationModel notification,
    required BuildContext context,
  }) {
    BlocProvider.of<ReadNotificationCubit>(
      context,
    ).readNotification(id: notification.id);
    String entityType = notification.relatedEntity;
    String entityId = notification.relatedEntityId;

    switch (entityType) {
      case "shipment":
        {
          setState(() {
            isLoading = true;
          });
          BlocProvider.of<ShipmentsCalendarCubit>(
            context,
          ).getShipmentById(shipmentId: entityId, type: "type");
        }
        break;
    }
  }
}
