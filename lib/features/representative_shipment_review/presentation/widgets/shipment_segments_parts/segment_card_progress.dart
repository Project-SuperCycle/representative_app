import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class SegmentCardProgress extends StatefulWidget {
  final String segmentStatus;
  final int currentStep;
  final Color activeColor;
  final Color inactiveColor;
  final Color completedColor;

  const SegmentCardProgress({
    super.key,
    required this.currentStep,
    required this.segmentStatus,
    this.activeColor = Colors.blueAccent,
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.completedColor = const Color(0xFF3BC577),
  });

  @override
  State<SegmentCardProgress> createState() => _SegmentCardProgressState();
}

class _SegmentCardProgressState extends State<SegmentCardProgress> {
  final List<StepData> steps = const [
    StepData(title: 'تم التحرك', icon: Icons.shopping_cart_rounded),
    StepData(title: 'تم الوزن', icon: Icons.local_shipping_rounded),
    StepData(title: 'تم التسليم', icon: Icons.check_circle_rounded),
  ];
  Color activeColor = Colors.blueAccent;
  Color completedColor = const Color(0xFF3BC577);

  @override
  void initState() {
    super.initState();
    setState(() {
      activeColor = widget.segmentStatus == "failed"
          ? AppColors.failureColor
          : widget.activeColor;

      completedColor = widget.segmentStatus == "failed"
          ? AppColors.failureColor
          : widget.completedColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          for (int i = 0; i < 3; i++) ...[
            Expanded(
              child: Column(
                children: [
                  // Step circle
                  _buildStepCircle(i),
                  const SizedBox(height: 12),
                  // Step label centered under circle
                  _buildStepLabel(i, context),
                ],
              ),
            ),
            if (i < 2)
              // Connector positioned between circles
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: _buildConnector(i),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepCircle(int index) {
    final isCompleted = index < widget.currentStep;
    final isActive = index == widget.currentStep;

    Color circleColor;
    if (isCompleted) {
      circleColor = completedColor;
    } else if (isActive) {
      circleColor = activeColor;
    } else {
      circleColor = widget.inactiveColor;
    }

    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(shape: BoxShape.circle, color: circleColor),
      child: Center(
        child: (widget.segmentStatus == "failed")
            ? const Icon(Icons.close_rounded, color: Colors.white, size: 15)
            : isCompleted
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
            : Icon(steps[index].icon, color: Colors.white, size: 15),
      ),
    );
  }

  Widget _buildConnector(int index) {
    final isCompleted = index < widget.currentStep;

    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: isCompleted ? completedColor : widget.inactiveColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildStepLabel(int index, BuildContext context) {
    final isCompleted = index < widget.currentStep;
    final isActive = index == widget.currentStep;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        steps[index].title,
        style: AppStyles.styleSemiBold12(context).copyWith(
          color: isActive || isCompleted
              ? const Color(0xFF212121)
              : const Color(0xFF9E9E9E),
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// Data model for steps
class StepData {
  final String title;
  final IconData icon;

  const StepData({required this.title, required this.icon});
}
