import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_cubit.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_state.dart';
import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';
import 'package:supercycle/features/shipments_calendar/presentation/widget/shipment_calendar_card.dart';

class TraderProfileInfoCard2 extends StatefulWidget {
  const TraderProfileInfoCard2({super.key});

  @override
  State<TraderProfileInfoCard2> createState() => _TraderProfileInfoCard2State();
}

class _TraderProfileInfoCard2State extends State<TraderProfileInfoCard2> {
  List<ShipmentModel> shipments = [];
  int currentPage = 1;
  bool hasMoreData = true;
  bool isLoadingMore = false;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    _getTotalPages();
    _fetchShipments(currentPage);
  }

  void _fetchShipments(int page) {
    BlocProvider.of<ShipmentsCalendarCubit>(
      context,
    ).getShipmentsHistory(page: page);
  }

  void _getTotalPages() async {
    totalPages = await StorageServices.readData("totalShipmentsHistoryPages");
    setState(() {});
  }

  void _loadNextPage() {
    if (!isLoadingMore && hasMoreData) {
      setState(() {
        isLoadingMore = true;
        currentPage++;
      });
      _fetchShipments(currentPage);
    }
  }

  void _loadPreviousPage() {
    if (currentPage > 1 && !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
        currentPage--;
      });
      _fetchShipments(currentPage);
    }
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
                color: Colors.black.withAlpha(25),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocConsumer<ShipmentsCalendarCubit, ShipmentsCalendarState>(
              listener: (context, state) {
                if (state is GetAllShipmentsSuccess) {
                  setState(() {
                    shipments = state.shipments;
                    isLoadingMore = false;
                    // لو الشحنات أقل من 10، معناها مفيش صفحات تانية
                    hasMoreData = state.shipments.length >= 10;
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
                  return Column(
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
                              onPressed: currentPage > 1 && !isLoadingMore
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
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 20,
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Page Number
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
                                  '$currentPage',
                                  style: AppStyles.styleSemiBold16(context),
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Next Button
                            IconButton(
                              onPressed: hasMoreData && !isLoadingMore
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
                              icon: Icon(
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
                  );
                }

                // Empty state
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
            ),
          ),
        ),
      ],
    );
  }
}
