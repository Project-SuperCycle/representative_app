import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/environment/data/models/environmental_redeem_model.dart';

class EcoRequestCard extends StatelessWidget {
  final EnvironmentalRedeemModel request;

  const EcoRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'طلب زراعة ${request.quantity.toInt()} شجرة',
                        style: AppStyles.styleSemiBold16(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.relativeTime,
                      style: AppStyles.styleSemiBold12(
                        context,
                      ).copyWith(color: AppColors.subTextColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildStatusBadge(context),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.grey[300], thickness: 0.6),
          ),

          // Request details
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context: context,
                  icon: Icons.eco_outlined,
                  label: 'الأشجار',
                  value: '${request.quantity.toInt()}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoItem(
                  context: context,
                  icon: Icons.stars_outlined,
                  label: 'النقاط',
                  value: '${request.totalPointsUsed.toInt()}',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Date info
          _buildInfoItem(
            context: context,
            icon: Icons.calendar_today_outlined,
            label: 'تاريخ الطلب',
            value: request.formattedDate,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: request.statusColor.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: request.statusColor.withAlpha(150), width: 1),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getStatusIcon(), size: 14, color: request.statusColor),
            const SizedBox(width: 4),
            Text(
              request.statusInArabic,
              style: AppStyles.styleSemiBold12(context).copyWith(
                color: request.statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    if (request.isPending) return Icons.pending_outlined;
    if (request.isApproved) return Icons.check_circle_outline;
    if (request.isRejected) return Icons.cancel_outlined;
    if (request.isPlanted) return Icons.nature_outlined;
    return Icons.info_outline;
  }

  Widget _buildInfoItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF10B981)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyles.styleSemiBold12(
                    context,
                  ).copyWith(color: AppColors.subTextColor),
                ),
                const SizedBox(height: 2),
                Text(value, style: AppStyles.styleBold16(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
