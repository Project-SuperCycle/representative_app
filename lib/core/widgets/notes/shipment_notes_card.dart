import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/rep_note_model.dart';

class ShipmentNoteCard extends StatelessWidget {
  final ShipmentNoteModel note;

  const ShipmentNoteCard({super.key, required this.note});

  bool get isAdmin => note.authorRole.toLowerCase() == 'admin';

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('hh:mm a').format(date);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: !isAdmin
              ? [const Color(0xFFEFF6FF), const Color(0xFFE0E7FF)]
              : [const Color(0xFFECFDF5), const Color(0xFFD1FAE5)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          right: BorderSide(
            color: !isAdmin ? const Color(0xFF6366F1) : const Color(0xFF10B981),
            width: 2.5,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Author info
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: !isAdmin
                                    ? const Color(0xFFE0E7FF)
                                    : const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                isAdmin ? Icons.shield : Icons.person,
                                size: 18,
                                color: !isAdmin
                                    ? const Color(0xFF4F46E5)
                                    : const Color(0xFF059669),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isAdmin ? 'الإدارة' : 'التاجر',
                              style: AppStyles.styleSemiBold14(context)
                                  .copyWith(
                                    color: !isAdmin
                                        ? const Color(0xFF312E81)
                                        : const Color(0xFF064E3B),
                                  ),
                            ),
                          ],
                        ),
                        // Timestamp
                        Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatDate(note.createdAt),
                              style: AppStyles.styleMedium12(
                                context,
                              ).copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Content
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        note.content,
                        style: AppStyles.styleRegular14(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
