import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class EnvironmentalImpactTabBar extends StatelessWidget {
  final TabController tabController;
  const EnvironmentalImpactTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: tabController,
        indicator: BoxDecoration(
          color: Color(0xFF10B981),
          borderRadius: BorderRadius.circular(15),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.subTextColor,
        labelStyle: AppStyles.styleSemiBold12(
          context,
        ).copyWith(fontWeight: FontWeight.bold),
        indicatorSize: TabBarIndicatorSize.tab,
        isScrollable: true, // Added for better UI with 5 tabs
        tabAlignment:
            TabAlignment.start, // Better alignment for scrollable tabs
        tabs: [
          Tab(
            height: 36,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('التأثير البيئي'),
            ),
          ),
          Tab(
            height: 36,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('مبادرة الأشجار'),
              ),
            ),
          ),
          Tab(
            height: 36,
            child: Center(
              child: FittedBox(fit: BoxFit.scaleDown, child: Text('الإنجازات')),
            ),
          ),
          Tab(
            height: 36,
            child: Center(
              child: FittedBox(fit: BoxFit.scaleDown, child: Text('المعاملات')),
            ),
          ),
          Tab(
            height: 36,
            child: Center(
              child: FittedBox(fit: BoxFit.scaleDown, child: Text('الطلبات')),
            ),
          ),
        ],
      ),
    );
  }
}
