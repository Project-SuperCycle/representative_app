import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/core/models/user_profile_model.dart';
import 'package:supercycle/core/widgets/drawer/custom_drawer.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_cubit.dart';
import 'package:supercycle/features/trader_main_profile/presentation/widgets/trader_profile_header/trader_profile_header_section.dart';
import 'package:supercycle/features/trader_main_profile/presentation/widgets/trader_profile_info_card1.dart';
import 'package:supercycle/features/trader_main_profile/presentation/widgets/trader_profile_info_card2.dart';
import 'package:supercycle/features/trader_main_profile/presentation/widgets/trader_profile_info_card3.dart';
import 'package:supercycle/features/trader_main_profile/presentation/widgets/trader_profile_page_indicator.dart';

class TraderProfileViewBody extends StatefulWidget {
  final UserProfileModel userProfile;
  const TraderProfileViewBody({super.key, required this.userProfile});

  @override
  State<TraderProfileViewBody> createState() => _TraderProfileViewBodyState();
}

class _TraderProfileViewBodyState extends State<TraderProfileViewBody> {
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ShipmentsCalendarCubit>(
      context,
    ).getShipmentsHistory(page: 1);
  }

  List<Widget> _getPages() {
    return [
      TraderProfileInfoCard1(userProfile: widget.userProfile),
      TraderProfileInfoCard2(),
      TraderProfileInfoCard3(user: widget.userProfile),
    ];
  }

  void _onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: CustomDrawer(isInProfilePage: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Section
            TraderProfileHeaderSection(userProfile: widget.userProfile),

            const SizedBox(height: 20),

            // Page Indicators
            TraderProfilePageIndicator(
              currentPage: currentPage,
              onPageChanged: _onPageChanged,
            ),

            const SizedBox(height: 20),

            // Content with swipe gesture (RTL direction)
            GestureDetector(
              onHorizontalDragEnd: (details) {
                // Swipe right (next page in Arabic/RTL)
                if (details.primaryVelocity! > 0) {
                  if (currentPage < _getPages().length - 1) {
                    _onPageChanged(currentPage + 1);
                  }
                }
                // Swipe left (previous page in Arabic/RTL)
                else if (details.primaryVelocity! < 0) {
                  if (currentPage > 0) {
                    _onPageChanged(currentPage - 1);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-0.1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                  child: KeyedSubtree(
                    key: ValueKey<int>(currentPage),
                    child: _getPages()[currentPage],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
