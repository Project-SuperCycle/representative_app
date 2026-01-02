import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/helpers/custom_back_button.dart';
import 'package:supercycle/core/models/user_profile_model.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/representative_main_profile/presentation/widgets/representative_profile_image.dart';

class RepresentativeProfileHeaderSection extends StatelessWidget {
  final UserProfileModel userProfile;
  const RepresentativeProfileHeaderSection({
    super.key,
    required this.userProfile,
  });

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
                      Builder(
                        builder: (context) => Container(
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
                  RepresentativProfileImage(logoPath: AppAssets.defaultAvatar),

                  const SizedBox(height: 16),

                  // Profile Name
                  Text(
                    userProfile.repName!,
                    style: AppStyles.styleBold24(
                      context,
                    ).copyWith(color: Colors.white, fontSize: 28),
                  ),

                  const SizedBox(height: 20),

                  // Stats Row
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(20),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatCard(
                          value: userProfile.totalShipments.toString().padLeft(
                            2,
                            '0',
                          ),
                          label: 'عدد شحناتك\nمعانا',
                        ),
                        Container(
                          height: 50,
                          width: 1,
                          color: Colors.white.withAlpha(80),
                        ),
                        _StatCard(
                          value: userProfile.delivered.toString().padLeft(
                            2,
                            '0',
                          ),
                          label: 'عدد شحناتك\nالتامة',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Contact Info Card
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.phone,
                            color: Color(0xFF10B981),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'رقم الهاتف',
                          style: AppStyles.styleSemiBold14(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Text(
                        userProfile.repPhone!,
                        style: AppStyles.styleMedium12(
                          context,
                        ).copyWith(color: Colors.grey[600]),
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.email,
                            color: Color(0xFF10B981),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'الإيميل',
                          style: AppStyles.styleSemiBold14(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Text(
                        userProfile.repEmail!,
                        style: AppStyles.styleMedium12(
                          context,
                        ).copyWith(color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
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
        Text(
          value,
          style: AppStyles.styleBold24(
            context,
          ).copyWith(color: Colors.white, fontSize: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppStyles.styleSemiBold12(
            context,
          ).copyWith(color: const Color(0xFFD1FAE5)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
