import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int completedSteps;
  final int totalSteps;

  const ProgressBar({
    super.key,
    required this.completedSteps,
    this.totalSteps = 5, // العدد الافتراضي 4 نقاط
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        textDirection: TextDirection.rtl,
        children: _buildProgressWidgets(),
      ),
    );
  }

  List<Widget> _buildProgressWidgets() {
    List<Widget> widgets = [];

    for (int i = 0; i < totalSteps; i++) {
      bool isCompleted = i < completedSteps;

      // إضافة النقطة
      widgets.add(ProgressPoint(isCompleted: isCompleted));

      // إضافة الخط إذا لم تكن النقطة الأخيرة
      if (i < totalSteps - 1) {
        widgets.add(ProgressLine(isCompleted: isCompleted));
      }
    }

    return widgets;
  }
}

class ProgressPoint extends StatelessWidget {
  final bool isCompleted;

  const ProgressPoint({super.key, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFF3BC577) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted ? const Color(0xFFAAEBBF) : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: isCompleted
          ? const Icon(Icons.check, color: Colors.white, size: 15)
          : null,
    );
  }
}

class ProgressLine extends StatelessWidget {
  final bool isCompleted;

  const ProgressLine({super.key, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 5,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isCompleted ? const Color(0xFF4CAF50) : Colors.grey.shade300,
          border: Border.all(
            color: isCompleted ? const Color(0xFFAAEBBF) : Colors.grey.shade400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(1.5),
        ),
      ),
    );
  }
}

// مثال على الاستخدام في صفحات مختلفة:

// الصفحة الأولى - لم يكتمل أي خطوة
class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProgressBar(completedSteps: 0);
  }
}

// الصفحة الثانية - اكتملت خطوة واحدة
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProgressBar(completedSteps: 1);
  }
}

// الصفحة الثالثة - اكتملت خطوتان
class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProgressBar(completedSteps: 2);
  }
}

// الصفحة الرابعة - اكتملت 3 خطوات
class FourthPage extends StatelessWidget {
  const FourthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProgressBar(completedSteps: 3);
  }
}

// الصفحة الأخيرة - اكتملت كل الخطوات
class FinalPage extends StatelessWidget {
  const FinalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProgressBar(completedSteps: 4);
  }
}
