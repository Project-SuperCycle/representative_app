import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class ExpandableSection extends StatefulWidget {
  final String title;
  final String iconPath;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget content;
  final double maxHeight;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.iconPath,
    required this.isExpanded,
    required this.onTap,
    required this.content,
    this.maxHeight = 300,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shadowColor: Colors.grey,
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade400, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    AnimatedRotation(
                      turns: widget.isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: ClipRRect(
                            child: Image.asset(
                              widget.iconPath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.settings,
                                  color: Colors.grey,
                                  size: 24,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          widget.title,
                          style: AppStyles.styleSemiBold16(context).copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withAlpha(250),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: widget.isExpanded ? widget.maxHeight : 0,
              child: widget.isExpanded
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Scrollbar(
                        controller: _scrollController, // إضافة الـ controller
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _scrollController, // نفس الـ controller
                          padding: const EdgeInsets.all(16),
                          physics: const BouncingScrollPhysics(),
                          child: widget.content,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
