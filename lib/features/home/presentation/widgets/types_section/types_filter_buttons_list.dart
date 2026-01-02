import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart' show AppColors;
import 'package:supercycle/features/home/presentation/widgets/types_section/types_filter_button.dart'
    show TypesFilterButton;
import 'package:supercycle/generated/l10n.dart' show S;

class TypesFilterButtonsList extends StatelessWidget {
  const TypesFilterButtonsList({super.key});

  @override
  Widget build(BuildContext context) {
    List<TabModel> tabs = [
      TabModel(title: S.of(context).all, color: AppColors.primaryColor),
      TabModel(
        title: S.of(context).carton,
        color: AppColors.primaryColor.withAlpha(150),
      ),
      TabModel(
        title: S.of(context).paper,
        color: AppColors.primaryColor.withAlpha(75),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs
            .map(
              (item) => IntrinsicWidth(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TypesFilterButton(
                    title: item.title,
                    color: item.color,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class TabModel {
  final String title;
  final Color color;
  TabModel({required this.title, required this.color});
}
