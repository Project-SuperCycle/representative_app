import 'package:flutter/material.dart';

class CustomFadingWidget extends StatefulWidget {
  const CustomFadingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minOpacity = 0.2,
    this.maxOpacity = 0.8,
  });

  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;

  // ── Convenience constructors ──────────────────────────────────

  /// Single text-line placeholder.
  factory CustomFadingWidget.line({
    Key? key,
    double? width,
    double height = 16,
    double radius = 8,
  }) =>
      CustomFadingWidget(
        key: key,
        child: _ShimmerBox(
          width: width,
          height: height,
          borderRadius: BorderRadius.circular(radius),
        ),
      );

  /// Rectangular block placeholder (e.g. card, image).
  factory CustomFadingWidget.box({
    Key? key,
    double? width,
    required double height,
    BorderRadius? borderRadius,
  }) =>
      CustomFadingWidget(
        key: key,
        child: _ShimmerBox(
          width: width,
          height: height,
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
      );

  /// Circular avatar / icon placeholder.
  factory CustomFadingWidget.circle({Key? key, required double radius}) =>
      CustomFadingWidget(
        key: key,
        child: _ShimmerBox(
          width: radius * 2,
          height: radius * 2,
          borderRadius: BorderRadius.circular(radius),
        ),
      );

  @override
  State<CustomFadingWidget> createState() => _CustomFadingWidgetState();
}

class _CustomFadingWidgetState extends State<CustomFadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _opacity = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal shimmer-coloured box
// ─────────────────────────────────────────────────────────────────────────────

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    this.width,
    required this.height,
    required this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final color = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
    );
  }
}
