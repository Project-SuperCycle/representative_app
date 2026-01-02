import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supercycle/core/models/trader_main_branch_model.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class TraderMainBranchSection extends StatelessWidget {
  final TraderMainBranchModel branch;
  const TraderMainBranchSection({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: const BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text("تفاصيل الفرع", style: AppStyles.styleSemiBold18(context)),
            const SizedBox(height: 24),
            _DetailRow(Icons.store, "اسم الفرع", branch.branchName ?? ""),
            _DetailRow(Icons.location_on, "عنوان الفرع", branch.address ?? ""),
            _DetailRow(Icons.person, "اسم المسؤول", branch.contactName ?? ""),
            _DetailRow(
              Icons.phone,
              "رقم تواصل المسؤول",
              branch.contactPhone ?? "",
            ),
            _DetailRow(
              Icons.schedule,
              "بداية التعامل",
              _formatDateTime(branch.startDate),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '--/--/---- --:--';
    final DateTime adjustedDateTime = dateTime.subtract(Duration(hours: 2));
    return DateFormat('dd/MM/yyyy HH:mm').format(adjustedDateTime);
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF10B981), size: 25),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(value, style: AppStyles.styleSemiBold14(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
