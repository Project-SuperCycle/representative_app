import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_back_button.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/features/trader_main_profile/presentation/widgets/trader_profile_header/trader_profile_header_logo.dart';

class TraderProfileHeaderNavigation extends StatelessWidget {
  const TraderProfileHeaderNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Button (Edit trader_main_profile)
          IconButton(
            onPressed: () {
              GoRouter.of(context).go(EndPoints.editProfileView);
            },
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
          ),

          // Logo Section
          Expanded(child: Center(child: TraderProfileHeaderLogo())),

          // Back Button (Home)
          CustomBackButton(
            color: Colors.white,
            size: 28,
            onPressed: () {
              GoRouter.of(context).pushReplacement(EndPoints.homeView);
            },
          ),
        ],
      ),
    );
  }
}
