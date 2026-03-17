import 'package:flutter/material.dart';
import 'package:representative_app/core/helpers/custom_fading_widget.dart';

class NotificationsLoadingIndicator extends StatelessWidget {
  const NotificationsLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, index) => _NotificationItemShimmer(index: index),
      ),
    );
  }
}

// ── Single shimmer notification item ─────────────────────────────────────────
class _NotificationItemShimmer extends StatelessWidget {
  const _NotificationItemShimmer({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======== Left column: icon + menu icon ========
          Column(
            children: [
              // ----- Notification icon placeholder -----
              CustomFadingWidget(
                duration: Duration(milliseconds: 900 + (index * 100)),
                child: CustomFadingWidget.circle(radius: 20),
              ),

              const SizedBox(height: 16),

              // ----- Menu icon placeholder -----
              CustomFadingWidget(
                duration: Duration(milliseconds: 950 + (index * 100)),
                child: CustomFadingWidget.circle(radius: 10),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // ======== Content column ========
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----- Title row + unread badge -----
                Row(
                  children: [
                    Expanded(
                      child: CustomFadingWidget(
                        duration: Duration(milliseconds: 900 + (index * 100)),
                        child: CustomFadingWidget.line(height: 14, radius: 5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Unread badge placeholder
                    CustomFadingWidget(
                      duration: Duration(milliseconds: 920 + (index * 100)),
                      child: CustomFadingWidget.circle(radius: 4),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ----- Body line 1 -----
                CustomFadingWidget(
                  duration: Duration(milliseconds: 960 + (index * 100)),
                  child: CustomFadingWidget.line(height: 12, radius: 4),
                ),

                const SizedBox(height: 6),

                // ----- Body line 2 (أقصر) -----
                CustomFadingWidget(
                  duration: Duration(milliseconds: 1000 + (index * 100)),
                  child: CustomFadingWidget.line(
                    width: 160,
                    height: 12,
                    radius: 4,
                  ),
                ),

                const SizedBox(height: 8),

                // ----- Time placeholder -----
                CustomFadingWidget(
                  duration: Duration(milliseconds: 1040 + (index * 100)),
                  child: CustomFadingWidget.line(
                    width: 80,
                    height: 10,
                    radius: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
