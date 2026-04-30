import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:representative_app/core/widgets/drawer/custom_drawer.dart';
import 'package:representative_app/core/widgets/navbar/custom_curved_navigation_bar.dart';
import 'package:representative_app/features/finances/presentation/widgets/representative_finances_view_body.dart';

class RepresentativeFinancesView extends StatefulWidget {
  const RepresentativeFinancesView({super.key});

  @override
  State<RepresentativeFinancesView> createState() =>
      _RepresentativeFinancesViewState();
}

class _RepresentativeFinancesViewState
    extends State<RepresentativeFinancesView> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void onDrawerPressed() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: RepresentativeFinancesViewBody(onDrawerPressed: onDrawerPressed),
      bottomNavigationBar: CustomCurvedNavigationBar(
        currentIndex: 0,
        navigationKey: _bottomNavigationKey,
      ),
    );
  }
}
