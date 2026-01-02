import 'package:flutter/material.dart';
import 'package:supercycle/core/models/user_profile_model.dart';
import 'package:supercycle/features/representative_main_profile/presentation/widgets/representative_profile_view_body.dart';

class RepresentativeProfileView extends StatelessWidget {
  final UserProfileModel userProfile;
  const RepresentativeProfileView({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return RepresentativeProfileViewBody(userProfile: userProfile);
  }
}
