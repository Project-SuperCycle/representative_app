import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/helpers/custom_back_button.dart';
import 'package:supercycle/core/models/user_profile_model.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class TraderProfileHeaderSection extends StatelessWidget {
  final UserProfileModel userProfile;
  const TraderProfileHeaderSection({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: kGradientContainer,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menu Button (Opens Drawer)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 24,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),

                      // Logo Section
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppAssets.logoName,
                                fit: BoxFit.contain,
                                scale: 6.0,
                              ),
                              const SizedBox(width: 5),
                              Image.asset(
                                AppAssets.logoIcon,
                                fit: BoxFit.contain,
                                scale: 7.5,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Back Button (Home)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomBackButton(
                          color: Colors.white,
                          size: 24,
                          onPressed: () {
                            GoRouter.of(
                              context,
                            ).pushReplacement(EndPoints.homeView);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Profile Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          AppAssets.defaultAvatar,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.store,
                              size: 70,
                              color: Color(0xFF10B981),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Profile Name
                  Text(
                    userProfile.businessName!,
                    style: AppStyles.styleBold24(
                      context,
                    ).copyWith(color: Colors.white, fontSize: 28),
                  ),

                  const SizedBox(height: 30),

                  // Stats Row
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(20),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _StatCard(
                            value: (userProfile.totalShipmentsCount == null)
                                ? userProfile.scheduledCount.toString().padLeft(
                                    2,
                                    '0',
                                  )
                                : userProfile.totalShipmentsCount
                                      .toString()
                                      .padLeft(2, '0'),
                            label: 'عدد شحناتك\nالمتفق عليها',
                          ),
                        ),
                        if (userProfile.role == "trader_contracted") ...[
                          Container(
                            height: 50,
                            width: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.white.withAlpha(80),
                          ),
                          Expanded(
                            child: _StatCard(
                              value: userProfile.manualCount!
                                  .toString()
                                  .padLeft(2, '0'),
                              label: 'عدد شحناتك\nالإضافية معانا',
                            ),
                          ),
                        ],
                        Container(
                          height: 50,
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.white.withAlpha(80),
                        ),
                        Expanded(
                          child: _StatCard(
                            value: (userProfile.fullyDeliveredCount == null)
                                ? userProfile.deliveredTotal.toString().padLeft(
                                    2,
                                    '0',
                                  )
                                : userProfile.fullyDeliveredCount
                                      .toString()
                                      .padLeft(2, '0'),
                            label: 'عدد شحنات\nتم تسليمها',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Text(
            value,
            style: AppStyles.styleBold24(
              context,
            ).copyWith(color: Colors.white, fontSize: 32),
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: AppStyles.styleBold12(context).copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
