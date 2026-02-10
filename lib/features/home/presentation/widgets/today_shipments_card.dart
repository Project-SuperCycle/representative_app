import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:representative_app/core/helpers/custom_loading_indicator.dart';
import 'package:representative_app/core/routes/end_points.dart';
import 'package:representative_app/core/utils/app_styles.dart';
import 'package:representative_app/features/home/data/managers/shipments_cubit/today_shipments_cubit.dart';
import 'package:representative_app/features/home/presentation/widgets/empty_shipments_card.dart';
import 'package:representative_app/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_cubit.dart';
import 'package:representative_app/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_state.dart';
import 'package:representative_app/features/shipments_calendar/data/models/shipment_model.dart';

class TodayShipmentsCard extends StatefulWidget {
  const TodayShipmentsCard({super.key});

  @override
  State<TodayShipmentsCard> createState() => _TodayShipmentsCardState();
}

class _TodayShipmentsCardState extends State<TodayShipmentsCard> {
  @override
  void initState() {
    super.initState();

    // ✅ جلب البيانات بعد بناء الـ Widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodayShipmentsCubit>().fetchInitialData();
    });
  }

  void _showShipmentDetails(
      BuildContext context,
      String shipmentID,
      String type,
      ) {
    BlocProvider.of<ShipmentsCalendarCubit>(context).getShipmentById(
      shipmentId: shipmentID,
      type: type,
    );
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
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: BlocBuilder<TodayShipmentsCubit, TodayShipmentsState>(
        builder: (context, state) {
          // ✅ حالة التحميل
          if (state is TodayShipmentsLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CustomLoadingIndicator(color: Colors.white),
              ),
            );
          }

          // ✅ حالة النجاح - عرض الشحنات
          if (state is TodayShipmentsSuccess) {
            return _buildShipmentsContent(state.shipments);
          }

          // ✅ حالة عدم وجود شحنات
          if (state is TodayShipmentsEmpty) {
            return const EmptyShipmentsCard();
          }

          // ✅ حالة الخطأ
          if (state is TodayShipmentsFailure) {
            return _buildErrorContent(state.message);
          }

          // ✅ الحالة الافتراضية (Initial)
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CustomLoadingIndicator(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  /// ✅ عرض محتوى الشحنات
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
              color: Colors.white.withOpacity(0.1),
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
              color: Colors.white.withOpacity(0.1),
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
                      color: Colors.white.withOpacity(0.2),
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
                          style: AppStyles.styleBold16(context).copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${shipments.length} ${shipments.length == 1 ? 'شحنة' : 'شحنات'} مجدولة',
                          style: AppStyles.styleMedium12(context).copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
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
                      style: AppStyles.styleBold12(context).copyWith(
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Shipments List
              ...shipments.map(
                    (shipment) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BlocListener<ShipmentsCalendarCubit, ShipmentsCalendarState>(
                    listener: (context, state) {
                      if (state is GetShipmentSuccess) {
                        GoRouter.of(context).push(
                          EndPoints.representativeShipmentDetailsView,
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

  /// ✅ عرض رسالة الخطأ
  Widget _buildErrorContent(String message) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'حدث خطأ أثناء تحميل الشحنات',
            style: AppStyles.styleBold14(context).copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppStyles.styleMedium12(context).copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<TodayShipmentsCubit>().refreshData();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShipmentItem extends StatelessWidget {
  const _ShipmentItem({
    required this.shipment,
    required this.onTap,
  });

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
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
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
                    style: AppStyles.styleBold14(context).copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white.withOpacity(0.7),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimeToArabic(shipment.requestedPickupAt),
                        style: AppStyles.styleMedium12(context).copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.location_on,
                        color: Colors.white.withOpacity(0.7),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          shipment.customPickupAddress,
                          style: AppStyles.styleMedium12(context).copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
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
                color: Colors.white.withOpacity(0.2),
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
    String period = hour < 12 ? "صباحًا" : "مساءً";
    return "$displayHour $period";
  }
}