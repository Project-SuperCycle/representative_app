import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/environment/data/models/trader_transaction_model.dart';

class EcoTransactionCard extends StatelessWidget {
  final TraderTransactionModel transaction;

  const EcoTransactionCard({super.key, required this.transaction});

  // Helper method to get icon and color based on transaction type
  IconData _getTransactionIcon() {
    switch (transaction.type.toLowerCase()) {
      case 'earn':
      case 'earned':
      case 'credit':
        return Icons.arrow_downward_rounded;
      case 'redeem':
      case 'redeemed':
      case 'spend':
      case 'debit':
        return Icons.arrow_upward_rounded;
      case 'bonus':
        return Icons.card_giftcard_rounded;
      case 'refund':
        return Icons.refresh_rounded;
      default:
        return Icons.sync_alt_rounded;
    }
  }

  Color _getTransactionColor() {
    switch (transaction.type.toLowerCase()) {
      case 'earn':
      case 'earned':
      case 'credit':
      case 'bonus':
      case 'refund':
        return const Color(0xFF10B981); // Green
      case 'redeem':
      case 'redeemed':
      case 'spend':
      case 'debit':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final difference = now.difference(transaction.updatedAt);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(transaction.updatedAt);
    }
  }

  bool get _isPositive {
    return transaction.type.toLowerCase() == 'earn' ||
        transaction.type.toLowerCase() == 'earned' ||
        transaction.type.toLowerCase() == 'credit' ||
        transaction.type.toLowerCase() == 'bonus' ||
        transaction.type.toLowerCase() == 'refund';
  }

  @override
  Widget build(BuildContext context) {
    final transactionColor = _getTransactionColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle tap if needed
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: transactionColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTransactionIcon(),
                    color: transactionColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Transaction Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          transaction.reason.toUpperCase(),
                          style: AppStyles.styleSemiBold14(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: transactionColor.withAlpha(50),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              transaction.type.toUpperCase(),
                              style: AppStyles.styleSemiBold12(
                                context,
                              ).copyWith(color: transactionColor),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getFormattedDate(),
                            style: AppStyles.styleMedium12(
                              context,
                            ).copyWith(color: Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Points Display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_isPositive ? '+' : '-'}${transaction.points.toStringAsFixed(0)}',
                      style: AppStyles.styleBold18(
                        context,
                      ).copyWith(color: transactionColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'points',
                      style: AppStyles.styleMedium12(
                        context,
                      ).copyWith(color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
