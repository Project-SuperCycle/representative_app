import 'package:flutter/material.dart';
import 'package:supercycle/core/models/user_profile_model.dart';
import 'package:supercycle/features/trader_main_profile/presentation/widgets/trader_branches_section.dart';
import 'package:supercycle/features/trader_main_profile/presentation/widgets/trader_main_branch_section.dart';
import 'package:supercycle/features/trader_main_profile/presentation/widgets/trader_profile_info_row.dart';

class TraderProfileInfoCard1 extends StatelessWidget {
  final UserProfileModel userProfile;

  const TraderProfileInfoCard1({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ..._buildProfileInfoRows(),
            const SizedBox(height: 30),
            (userProfile.role == "trader_uncontracted")
                ? TraderMainBranchSection(branch: userProfile.mainBranch!)
                : TraderBranchesSection(branches: userProfile.branchs),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProfileInfoRows() {
    final profileInfo = [
      ProfileInfoItem(
        label: "نوع النشاط",
        value: userProfile.rawBusinessType!,
        icon: Icons.business,
      ),
      ProfileInfoItem(
        label: "العنوان",
        value: userProfile.businessAddress!,
        icon: Icons.location_on,
      ),
      ProfileInfoItem(
        label: "اسم المسئول",
        value: userProfile.doshManagerName!,
        icon: Icons.person,
      ),
      ProfileInfoItem(
        label: "رقم الهاتف",
        value: userProfile.doshManagerPhone!,
        icon: Icons.phone,
      ),
      ProfileInfoItem(
        label: "الايميل",
        value: userProfile.email,
        icon: Icons.email,
      ),
    ];

    return profileInfo
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TraderProfileInfoRow(
              label: item.label,
              value: item.value,
              icon: item.icon,
            ),
          ),
        )
        .toList();
  }
}

class ProfileInfoItem {
  final String label;
  final String value;
  final IconData icon;

  ProfileInfoItem({
    required this.label,
    required this.value,
    required this.icon,
  });
}
