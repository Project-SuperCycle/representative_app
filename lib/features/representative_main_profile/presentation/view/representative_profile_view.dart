import 'package:flutter/material.dart';
import 'package:representative_app/core/models/user_profile_model.dart';
import 'package:representative_app/features/representative_main_profile/presentation/widgets/representative_profile_view_body.dart';

class RepresentativeProfileView extends StatelessWidget {
  final UserProfileModel userProfile;
  const RepresentativeProfileView({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return RepresentativeProfileViewBody(userProfile: userProfile);
  }
}
