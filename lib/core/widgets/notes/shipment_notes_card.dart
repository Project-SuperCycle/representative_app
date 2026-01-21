import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/rep_note_model.dart';

class ShipmentNoteCard extends StatelessWidget {
  final ShipmentNoteModel note;

  const ShipmentNoteCard({super.key, required this.note});

  bool get isAdmin => note.authorRole.toLowerCase() == 'admin';
  bool get isRep => note.authorRole.toLowerCase() == 'representative';
  bool get isTrader =>
      note.authorRole.toLowerCase() == 'trader' ||
      note.authorRole.toLowerCase() == 'trader_uncontracted';

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

  Color get bubbleColor {
    if (isTrader) {
      return const Color(0xFFDCF8C6); // WhatsApp green for trader
    } else if (isAdmin) {
      return const Color(0xFFE3F2FD); // Light blue for admin
    } else {
      return const Color(0xFFF3E5F5); // Light purple for rep
    }
  }

  String get authorLabel {
    if (isTrader) return 'التاجر';
    if (isAdmin) return 'الإدارة';
    return 'أنا';
  }

  IconData get authorIcon {
    if (isTrader) return Icons.person;
    if (isAdmin) return Icons.shield;
    return Icons.support_agent;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isTrader
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar for non-trader (left side)
          if (!isTrader) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: bubbleColor,
              child: Icon(
                authorIcon,
                size: 16,
                color: isAdmin
                    ? const Color(0xFF1976D2)
                    : const Color(0xFF7B1FA2),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isTrader ? 16 : 4),
                  bottomRight: Radius.circular(isTrader ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author name
                    Text(
                      authorLabel,
                      style: AppStyles.styleSemiBold12(context).copyWith(
                        color: isTrader
                            ? const Color(0xFF075E54)
                            : isAdmin
                            ? const Color(0xFF1976D2)
                            : const Color(0xFF7B1FA2),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Message content
                    Text(
                      note.content,
                      style: AppStyles.styleRegular14(
                        context,
                      ).copyWith(color: Colors.black87),
                    ),
                    const SizedBox(height: 4),

                    // Timestamp
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          formatDate(note.createdAt),
                          style: AppStyles.styleRegular12(
                            context,
                          ).copyWith(color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Avatar for trader (right side)
          if (isTrader) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: bubbleColor,
              child: Icon(authorIcon, size: 16, color: const Color(0xFF075E54)),
            ),
          ],
        ],
      ),
    );
  }
}
