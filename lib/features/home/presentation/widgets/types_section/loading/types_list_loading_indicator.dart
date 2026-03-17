import 'package:flutter/material.dart';
import 'package:representative_app/features/home/presentation/widgets/types_section/loading/type_card_item_shimmer.dart';

class TypesListLoadingIndicator extends StatelessWidget {
  const TypesListLoadingIndicator({super.key});

  static const List<String> items = ["1", "2", "3", "4", "5"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items
            .map(
              (item) => IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: TypeCardItemShimmer(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
