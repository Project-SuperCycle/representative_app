import 'package:flutter/material.dart';
import 'package:supercycle/features/environment/data/models/trader_eco_info_model.dart';
import 'package:supercycle/features/environment/presentation/widgets/achievements_tab/badges_card.dart';
import 'package:supercycle/features/environment/presentation/widgets/achievements_tab/challenge_card.dart';
import 'package:supercycle/features/environment/presentation/widgets/achievements_tab/leader_boards_card.dart';

class EnvironmentalAchievementsTab extends StatelessWidget {
  final TraderEcoInfoModel ecoInfoModel;
  const EnvironmentalAchievementsTab({super.key, required this.ecoInfoModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          BadgesCard(),
          const SizedBox(height: 12),
          LeaderBoardsCard(participants: ecoInfoModel.topParticipants),
          const SizedBox(height: 12),
          ChallengeCard(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
