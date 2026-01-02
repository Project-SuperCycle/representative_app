import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/home/data/managers/shipments_cubit/today_shipments_cubit.dart';
import 'package:supercycle/features/home/presentation/widgets/empty_shipments_card.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_cubit.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_state.dart';
import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';

class TodayShipmentsCard extends StatefulWidget {
  const TodayShipmentsCard({super.key});

  @override
  State<TodayShipmentsCard> createState() => _TodayShipmentsCardState();
}

class _TodayShipmentsCardState extends State<TodayShipmentsCard> {
  late LoginedUserModel user;

  @override
  void initState() {
    super.initState();
    getUserData();
    // _loadTodayShipments();

    // عند فتح الـ widget، اعرض الداتا المخزنة لو موجودة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<TodayShipmentsCubit>();
      if (cubit.cachedTodayShipments != null &&
          cubit.cachedTodayShipments!.isNotEmpty) {
        // عمل emit للداتا المخزنة عشان الـ UI يعرضها
        cubit.emit(
          TodayShipmentsSuccess(shipments: cubit.cachedTodayShipments!),
        );
      }
    });
  }

  void _loadTodayShipments() {
    BlocProvider.of<TodayShipmentsCubit>(context).fetchInitialData();
  }

  void getUserData() {
    StorageServices.getUserData().then((value) {
      setState(() {
        user = value!;
      });
    });
  }

  void _showShipmentDetails(
    BuildContext context,
    String shipmentID,
    String type,
  ) {
    BlocProvider.of<ShipmentsCalendarCubit>(
      context,
    ).getShipmentById(shipmentId: shipmentID, type: type);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.orange.shade400, Colors.deepOrange.shade500],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withAlpha(50),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: BlocConsumer<TodayShipmentsCubit, TodayShipmentsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          // لو في cache، اعرضه حتى لو الـ state لسه Initial
          final cubit = context.read<TodayShipmentsCubit>();
          if (state is TodayShipmentsInitial &&
              cubit.cachedTodayShipments != null &&
              cubit.cachedTodayShipments!.isNotEmpty) {
            return _buildShipmentsContent(cubit.cachedTodayShipments!);
          }

          if (state is TodayShipmentsLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CustomLoadingIndicator(color: Colors.white),
              ),
            );
          }

          if (state is TodayShipmentsSuccess && state.shipments.isNotEmpty) {
            return _buildShipmentsContent(state.shipments);
          }

          return EmptyShipmentsCard();
        },
      ),
    );
  }

  Widget _buildShipmentsContent(List<ShipmentModel> shipments) {
    return Stack(
      children: [
        // Decorative circles
        Positioned(
          top: -30,
          right: -30,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(25),
            ),
          ),
        ),
        Positioned(
          bottom: -20,
          left: -20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(25),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(100),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_shipping,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shipments.length == 1 ? 'شحنة اليوم' : 'شحنات اليوم',
                          style: AppStyles.styleBold16(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                        Text(
                          '${shipments.length} ${shipments.length == 1 ? 'شحنة' : 'شحنات'} مجدولة',
                          style: AppStyles.styleMedium12(
                            context,
                          ).copyWith(color: Colors.white.withAlpha(500)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'اليوم',
                      style: AppStyles.styleBold12(
                        context,
                      ).copyWith(color: Colors.orange.shade700),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Shipments List
              ...shipments.map(
                (shipment) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child:
                      BlocListener<
                        ShipmentsCalendarCubit,
                        ShipmentsCalendarState
                      >(
                        listener: (context, state) {
                          if (state is GetShipmentSuccess) {
                            (user.role == "representative")
                                ? GoRouter.of(context).push(
                                    EndPoints.representativeShipmentDetailsView,
                                    extra: state.shipment,
                                  )
                                : GoRouter.of(context).push(
                                    EndPoints.traderShipmentDetailsView,
                                    extra: state.shipment,
                                  );
                          }
                        },
                        child: _ShipmentItem(
                          shipment: shipment,
                          onTap: () => _showShipmentDetails(
                            context,
                            shipment.id,
                            shipment.type,
                          ),
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShipmentItem extends StatelessWidget {
  const _ShipmentItem({required this.shipment, required this.onTap});

  final ShipmentModel shipment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(100),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withAlpha(150), width: 1),
        ),
        child: Row(
          children: [
            // Shipment Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.inventory_2,
                color: Colors.orange.shade600,
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            // Shipment Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'شحنة #${shipment.shipmentNumber}',
                    style: AppStyles.styleBold14(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white.withAlpha(400),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimeToArabic(shipment.requestedPickupAt),
                        style: AppStyles.styleMedium12(
                          context,
                        ).copyWith(color: Colors.white.withAlpha(500)),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.location_on,
                        color: Colors.white.withAlpha(400),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          shipment.customPickupAddress,
                          style: AppStyles.styleMedium12(
                            context,
                          ).copyWith(color: Colors.white.withAlpha(500)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeToArabic(DateTime dateTime) {
    int hour = dateTime.hour;
    int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    String period = hour < 12 ? "صباحا" : "مساءا";
    return "$displayHour $period";
  }
}

// Model
class TodayShipment {
  final String id;
  final String time;
  final String location;

  TodayShipment({required this.id, required this.time, required this.location});

  factory TodayShipment.fromJson(Map<String, dynamic> json) {
    return TodayShipment(
      id: json['id'],
      time: json['scheduled_time'] ?? 'غير محدد',
      location: json['pickup_address'] ?? 'غير محدد',
    );
  }
}
