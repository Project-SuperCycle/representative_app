import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_back_button.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/features/representative_main_profile/presentation/widgets/representative_profile_header/representative_profile_header_logo.dart';

class RepresentativeProfileHeaderNavigation extends StatelessWidget {
  const RepresentativeProfileHeaderNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Button (Edit Profile)
          IconButton(
            onPressed: () {
              GoRouter.of(context).go(EndPoints.editRepresentativeProfileView);
            },
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
          ),

          // Logo Section
          Expanded(child: Center(child: RepresentativeProfileHeaderLogo())),

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
