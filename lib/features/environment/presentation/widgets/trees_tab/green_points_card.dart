import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/environment/data/cubits/create_request_cubit/create_request_cubit.dart';

class GreenPointsCard extends StatelessWidget {
  final num points;
  final Function(int treeCount)? onPlantTrees;

  const GreenPointsCard({super.key, required this.points, this.onPlantTrees});

  static const int pointsPerTree = 120;

  void _showPlantTreeDialog(BuildContext context) {
    final maxTrees = (points / pointsPerTree).floor();
    int selectedTrees = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF10B981).withAlpha(200),
                    Color(0xFF059669).withAlpha(200),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tree Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.park, color: Colors.white, size: 48),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    'ازرع شجرتك! 🌳',
                    style: AppStyles.styleSemiBold24(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Points per tree info
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'كل شجرة تحتاج $pointsPerTree نقطة',
                      style: AppStyles.styleSemiBold14(
                        context,
                      ).copyWith(color: Color(0xFFD1FAE5)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Available trees info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'نقاطك الحالية:',
                              style: AppStyles.styleSemiBold14(
                                context,
                              ).copyWith(color: Colors.white70),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '$points',
                                style: AppStyles.styleSemiBold16(context)
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'أقصى عدد أشجار:',
                              style: AppStyles.styleSemiBold14(
                                context,
                              ).copyWith(color: Colors.white70),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '$maxTrees شجرة',
                                style: AppStyles.styleSemiBold16(context)
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tree counter
                  Text(
                    'عدد الأشجار',
                    style: AppStyles.styleSemiBold14(
                      context,
                    ).copyWith(color: Colors.white70),
                  ),

                  const SizedBox(height: 12),

                  // Counter controls
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Decrease button
                        IconButton(
                          onPressed: selectedTrees > 1
                              ? () => setState(() => selectedTrees--)
                              : null,
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: selectedTrees > 1
                                ? Colors.white
                                : Colors.white38,
                            size: 32,
                          ),
                        ),

                        const SizedBox(width: 20),

                        // Tree count display
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '$selectedTrees',
                              style: AppStyles.styleSemiBold24(context)
                                  .copyWith(
                                    color: Color(0xFF059669),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        // Increase button
                        IconButton(
                          onPressed: selectedTrees < maxTrees
                              ? () => setState(() => selectedTrees++)
                              : null,
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: selectedTrees < maxTrees
                                ? Colors.white
                                : Colors.white38,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Total points cost
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'التكلفة: ${selectedTrees * pointsPerTree} نقطة',
                      style: AppStyles.styleSemiBold14(
                        context,
                      ).copyWith(color: Color(0xFFD1FAE5)),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      // Confirm button
                      Expanded(
                        child:
                            BlocConsumer<
                              CreateRequestCubit,
                              CreateRequestState
                            >(
                              listener: (context, state) {
                                // TODO: implement listener
                                if (state is CreateRequestFailure) {
                                  CustomSnackBar.showError(
                                    context,
                                    state.errMessage,
                                  );
                                }
                              },
                              builder: (context, state) {
                                return (state is CreateRequestLoading)
                                    ? Center(
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CustomLoadingIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          BlocProvider.of<CreateRequestCubit>(
                                            context,
                                          ).createTraderEcoRequest(
                                            quantity: selectedTrees,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'إتمام',
                                          style: AppStyles.styleSemiBold16(
                                            context,
                                          ).copyWith(color: Color(0xFF059669)),
                                        ),
                                      );
                              },
                            ),
                      ),
                      const SizedBox(width: 12),

                      // Cancel button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'إلغاء',
                            style: AppStyles.styleSemiBold16(
                              context,
                            ).copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canPlant = points >= pointsPerTree;
    final remainingPoints = canPlant ? 0 : (pointsPerTree - points);
    final maxTrees = (points / pointsPerTree).floor();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: kGradientContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    points.toString().padLeft(2, '0'),
                    style: AppStyles.styleSemiBold24(context).copyWith(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'نقطة خضراء',
                    style: AppStyles.styleSemiBold14(
                      context,
                    ).copyWith(color: Color(0xFFD1FAE5)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.park, color: Colors.white, size: 24),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Message and button
          if (canPlant)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'يمكنك زراعة $maxTrees ${maxTrees == 1 ? 'شجرة' : 'شجرة'} باسمك! 🌳',
                      style: AppStyles.styleSemiBold14(
                        context,
                      ).copyWith(color: Color(0xFFD1FAE5)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _showPlantTreeDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.park, color: Color(0xFF10B981), size: 20),
                      const SizedBox(width: 4),
                      Text(
                        'ازرع',
                        style: AppStyles.styleSemiBold14(
                          context,
                        ).copyWith(color: Color(0xFF10B981)),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'تحتاج $remainingPoints نقطة أخرى لزراعة شجرتك التالية باسمك! 🌳',
                style: AppStyles.styleSemiBold14(
                  context,
                ).copyWith(color: Color(0xFFD1FAE5)),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
