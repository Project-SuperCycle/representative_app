import 'package:flutter/material.dart';

class TraderProfilePageIndicator extends StatelessWidget {
  const TraderProfilePageIndicator({
    super.key,
    required this.currentPage,
    this.totalPages = 3,
    this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final Function(int)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        totalPages,
            (index) => GestureDetector(
          onTap: () {
            onPageChanged?.call(index);
          },
          child: _buildIndicatorDot(index == currentPage),
        ),
      ),
    );
  }

  Widget _buildIndicatorDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF10B981) : const Color(0xFFC0BEBE),
        shape: BoxShape.circle,
      ),
    );
  }
}