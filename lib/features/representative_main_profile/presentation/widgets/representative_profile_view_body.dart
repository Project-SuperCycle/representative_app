import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/core/models/user_profile_model.dart';
import 'package:supercycle/core/widgets/drawer/custom_drawer.dart';
import 'package:supercycle/features/representative_main_profile/presentation/widgets/representative_profile_header/representative_profile_header_section.dart';
import 'package:supercycle/features/representative_main_profile/presentation/widgets/representative_profile_info_card.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_cubit.dart';

class RepresentativeProfileViewBody extends StatefulWidget {
  final UserProfileModel userProfile;
  const RepresentativeProfileViewBody({super.key, required this.userProfile});

  @override
  State<RepresentativeProfileViewBody> createState() =>
      _RepresentativeProfileViewBodyState();
}

class _RepresentativeProfileViewBodyState
    extends State<RepresentativeProfileViewBody> {
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchShipments(currentPage);
  }

  void _fetchShipments(int page) {
    BlocProvider.of<ShipmentsCalendarCubit>(
      context,
    ).getShipmentsHistory(page: page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: CustomDrawer(isInProfilePage: true),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: RepresentativeProfileHeaderSection(
              userProfile: widget.userProfile,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  RepresentativeProfileInfoCard(
                    currentPage: currentPage,
                    onPageChanged: (newPage) {
                      setState(() {
                        currentPage = newPage;
                      });
                      _fetchShipments(newPage);
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
