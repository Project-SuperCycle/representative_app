import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_cubit.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_state.dart';
import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';
import 'package:supercycle/features/shipments_calendar/presentation/widget/shipment_calendar_card.dart';

class RepresentativeProfileInfoCard extends StatefulWidget {
  final int currentPage;
  final Function(int) onPageChanged;

  const RepresentativeProfileInfoCard({
    super.key,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  State<RepresentativeProfileInfoCard> createState() =>
      _RepresentativeProfileInfoCardState();
}

class _RepresentativeProfileInfoCardState
    extends State<RepresentativeProfileInfoCard> {
  List<ShipmentModel> shipments = [];
  bool hasMoreData = true;
  bool isLoadingMore = false;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    _getTotalPages();
  }

  void _loadNextPage() {
    if (!isLoadingMore && widget.currentPage < totalPages) {
      setState(() {
        isLoadingMore = true;
      });
      widget.onPageChanged(widget.currentPage + 1);
    }
  }

  void _loadPreviousPage() {
    if (widget.currentPage > 1 && !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      widget.onPageChanged(widget.currentPage - 1);
    }
  }

  void _getTotalPages() async {
    final pages = await StorageServices.readData("totalShipmentsHistoryPages");
    setState(() {
      totalPages = pages ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'سجل المعاملات السابقة',
          style: AppStyles.styleSemiBold22(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withAlpha(25),
            border: Border.all(color: const Color(0xFF10B981)),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: BlocConsumer<ShipmentsCalendarCubit, ShipmentsCalendarState>(
            listener: (context, state) {
              if (state is GetAllShipmentsSuccess) {
                setState(() {
                  shipments = state.shipments;
                  isLoadingMore = false;
                  hasMoreData = widget.currentPage < totalPages;
                });
              }
              if (state is GetAllShipmentsFailure) {
                setState(() {
                  isLoadingMore = false;
                });

                CustomSnackBar.showError(context, state.errorMessage);
              }
            },
            builder: (context, state) {
              if (state is GetAllShipmentsLoading && shipments.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CustomLoadingIndicator(),
                  ),
                );
              }

              if (shipments.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: shipments.length,
                        itemBuilder: (context, index) {
                          final transaction = shipments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ShipmentsCalendarCard(shipment: transaction),
                          );
                        },
                      ),

                      // Pagination Controls
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Previous Button
                            IconButton(
                              onPressed:
                                  widget.currentPage > 1 && !isLoadingMore
                                  ? _loadPreviousPage
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey.shade300,
                                padding: const EdgeInsets.all(3),
                                minimumSize: const Size(30, 30),
                                maximumSize: const Size(30, 30),
                              ),
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 20,
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Page Number with Total Pages
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.currentPage} / $totalPages',
                                  style: AppStyles.styleSemiBold16(context),
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Next Button
                            IconButton(
                              onPressed:
                                  widget.currentPage < totalPages &&
                                      !isLoadingMore
                                  ? _loadNextPage
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey.shade300,
                                padding: const EdgeInsets.all(3),
                                minimumSize: const Size(30, 30),
                                maximumSize: const Size(30, 30),
                              ),
                              icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Loading Indicator when loading more
                      if (isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: CustomLoadingIndicator(),
                        ),
                    ],
                  ),
                );
              }

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppAssets.boxIcon,
                        height: 100,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withAlpha(150),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'لا يوجد معاملات',
                        style: AppStyles.styleSemiBold22(context),
                      ),
                    ],
                  ),
                ),
              );
            },
            buildWhen: (previous, current) =>
                current is GetAllShipmentsLoading ||
                current is GetAllShipmentsSuccess ||
                current is GetAllShipmentsFailure,
          ),
        ),
      ],
    );
  }
}
