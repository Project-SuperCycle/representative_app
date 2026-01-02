import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/environment/data/models/top_participant_model.dart';
import 'package:supercycle/features/environment/presentation/widgets/achievements_tab/leader_board_item.dart';

class LeaderBoardsCard extends StatelessWidget {
  final List<TopParticipant> participants;
  const LeaderBoardsCard({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('لوحة المتصدرين', style: AppStyles.styleBold18(context)),
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            shrinkWrap: true,
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final participant = participants[index];
              return LeaderBoardItem(
                rank: (index + 1).toString(),
                name: participant.user.bussinessName,
                points:
                    "${participant.totalPoints.toString().padLeft(2, '0')} نقطة",
                color: const Color(0xFF059669),
                isHighlighted: false,
              );
            },
          ),
        ],
      ),
    );
  }
}
