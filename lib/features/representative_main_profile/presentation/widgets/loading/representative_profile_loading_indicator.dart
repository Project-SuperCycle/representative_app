import 'package:flutter/material.dart';
import 'package:representative_app/core/constants.dart';
import 'package:representative_app/core/helpers/custom_fading_widget.dart';

class RepresentativeProfileLoadingIndicator extends StatelessWidget {
  const RepresentativeProfileLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ======== Header Section Shimmer ========
          _buildHeaderShimmer(context),

          const SizedBox(height: 20),

          // ======== Page Indicator Shimmer ========
          _buildPageIndicatorShimmer(),

          const SizedBox(height: 20),

          // ======== Info Card Shimmer ========
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildInfoCardShimmer(),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeaderShimmer(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: kGradientContainer,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ----- Navigation row -----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu button placeholder
                  CustomFadingWidget.box(
                    width: 44,
                    height: 44,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  // Logo placeholder
                  CustomFadingWidget.box(
                    width: 120,
                    height: 30,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  // Back button placeholder
                  CustomFadingWidget.box(
                    width: 44,
                    height: 44,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ----- Avatar -----
              CustomFadingWidget.circle(radius: 50),

              const SizedBox(height: 16),

              // ----- Business name -----
              CustomFadingWidget.line(width: 180, height: 28, radius: 8),

              const SizedBox(height: 30),

              // ----- Stats container -----
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Stat 1
                    Expanded(child: _buildStatShimmer(delay: 0)),

                    // Divider
                    Container(
                      height: 50,
                      width: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.white.withAlpha(80),
                    ),

                    // Stat 2
                    Expanded(child: _buildStatShimmer(delay: 100)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatShimmer({required int delay}) {
    return Column(
      children: [
        CustomFadingWidget(
          duration: Duration(milliseconds: 900 + delay),
          child: CustomFadingWidget.line(width: 40, height: 28, radius: 6),
        ),
        const SizedBox(height: 8),
        CustomFadingWidget(
          duration: Duration(milliseconds: 950 + delay),
          child: CustomFadingWidget.line(width: 60, height: 12, radius: 4),
        ),
        const SizedBox(height: 4),
        CustomFadingWidget(
          duration: Duration(milliseconds: 970 + delay),
          child: CustomFadingWidget.line(width: 50, height: 12, radius: 4),
        ),
      ],
    );
  }

  // ── Page Indicator ────────────────────────────────────────────────────────
  Widget _buildPageIndicatorShimmer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: index == 0
                ? const Color(0xFF10B981).withAlpha(120)
                : const Color(0xFFC0BEBE).withAlpha(120),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  // ── Info Card ─────────────────────────────────────────────────────────────
  Widget _buildInfoCardShimmer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ----- 5 info rows -----
            ...List.generate(2, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildInfoRowShimmer(index: index),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRowShimmer({required int index}) {
    return Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Value + label column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              CustomFadingWidget(
                duration: Duration(milliseconds: 880 + (index * 70)),
                child: CustomFadingWidget.line(
                  width: 80,
                  height: 12,
                  radius: 4,
                ),
              ),
              const SizedBox(height: 6),
              // Value
              CustomFadingWidget(
                duration: Duration(milliseconds: 920 + (index * 70)),
                child: CustomFadingWidget.line(height: 14, radius: 4),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Icon placeholder
        CustomFadingWidget(
          duration: Duration(milliseconds: 900 + (index * 70)),
          child: CustomFadingWidget.circle(radius: 18),
        ),
      ],
    );
  }
}
