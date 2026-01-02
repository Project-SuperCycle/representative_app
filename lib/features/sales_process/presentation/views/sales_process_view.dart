import 'package:flutter/material.dart';
import 'package:supercycle/core/widgets/navbar/custom_curved_navigation_bar.dart';
import 'package:supercycle/features/sales_process/presentation/widgets/sales_process_view_body.dart';

class SalesProcessView extends StatelessWidget {
  const SalesProcessView({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SalesProcessViewBody(),
      bottomNavigationBar: CustomCurvedNavigationBar(currentIndex: 1),
    );
  }
}
