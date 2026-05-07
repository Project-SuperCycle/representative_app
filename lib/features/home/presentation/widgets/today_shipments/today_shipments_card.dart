import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:representative_app/core/helpers/custom_loading_indicator.dart';
import 'package:representative_app/core/helpers/custom_snack_bar.dart';
import 'package:representative_app/core/routes/end_points.dart';
import 'package:representative_app/core/utils/app_styles.dart';
import 'package:representative_app/features/home/data/managers/shipments_cubit/today_shipments_cubit.dart';
import 'package:representative_app/features/home/presentation/widgets/empty_shipments_card.dart';
import 'package:representative_app/features/home/presentation/widgets/today_shipments/today_shipments_initial_card.dart';
import 'package:representative_app/features/home/presentation/widgets/today_shipments/today_shipments_loading_indicator.dart';
import 'package:representative_app/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_cubit.dart';
import 'package:representative_app/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_state.dart';
import 'package:representative_app/features/shipments_calendar/data/models/shipment_model.dart';

class TodayShipmentsCard extends StatefulWidget {
  const TodayShipmentsCard({super.key});

  @override
  State<TodayShipmentsCard> createState() => _TodayShipmentsCardState();
}

class _TodayShipmentsCardState extends State<TodayShipmentsCard> {
  // ✅ Track which shipment is currently loading
  String? _loadingShipmentId;

  @override
  void initState() {
    super.initState();

    // ✅ جلب البيانات بعد بناء الـ Widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodayShipmentsCubit>().fetchInitialData();
    });
  }

  // ✅ FIX: Pass the shipment ID to track which card is loading
  void _showShipmentDetails(
    BuildContext context,
    String shipmentID,
    String type,
  ) {
    if (_loadingShipmentId != null) return; // Prevent multiple clicks

    setState(() {
      _loadingShipmentId = shipmentID; // Mark this shipment as loading
    });

    context.read<ShipmentsCalendarCubit>().getShipmentById(
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
          colors: [
            Color(0xffD04A1D).withValues(alpha: 0.9),
            Color(0xffD04A1D).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xffD04A1D).withValues(alpha: 0.5),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BlocBuilder<TodayShipmentsCubit, TodayShipmentsState>(
        builder: (context, state) {
          // ✅ حالة التحميل
          if (state is TodayShipmentsLoading) {
            return TodayShipmentsLoadingIndicator();
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
          return TodayShipmentsInitialCard();
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
              color: Colors.white.withAlpha(50),
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
              color: Colors.white.withAlpha(50),
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
                          ).copyWith(color: Colors.white.withAlpha(400)),
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

              // Shipments List with BlocListener
              ...shipments.map(
                (shipment) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _ShipmentItemWithListener(
                    shipment: shipment,
                    isLoading: _loadingShipmentId == shipment.id,
                    onTap: () => _showShipmentDetails(
                      context,
                      shipment.id,
                      shipment.type,
                    ),
                    onNavigationComplete: () {
                      if (mounted) {
                        setState(() {
                          _loadingShipmentId = null;
                        });
                      }
                    },
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
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 12),
            Text(
              'حدث خطأ أثناء تحميل الشحنات',
              style: AppStyles.styleBold14(
                context,
              ).copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppStyles.styleMedium12(
                context,
              ).copyWith(color: Colors.white.withAlpha(400)),
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
      ),
    );
  }
}

class _ShipmentItemWithListener extends StatefulWidget {
  const _ShipmentItemWithListener({
    required this.shipment,
    required this.isLoading,
    required this.onTap,
    required this.onNavigationComplete,
  });

  final ShipmentModel shipment;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onNavigationComplete;

  @override
  State<_ShipmentItemWithListener> createState() =>
      _ShipmentItemWithListenerState();
}

class _ShipmentItemWithListenerState extends State<_ShipmentItemWithListener> {
  bool _hasNavigated = false;

  @override
  void didUpdateWidget(_ShipmentItemWithListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset navigation flag when loading stops
    if (oldWidget.isLoading && !widget.isLoading) {
      _hasNavigated = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShipmentsCalendarCubit, ShipmentsCalendarState>(
      listenWhen: (previous, current) {
        // Only listen if this card is loading and hasn't navigated yet
        return widget.isLoading &&
            !_hasNavigated &&
            (current is GetShipmentSuccess || current is GetShipmentFailure);
      },
      listener: (context, state) {
        if (state is GetShipmentSuccess) {
          // Double check this is our shipment
          if (state.shipment.id == widget.shipment.id) {
            _hasNavigated = true;

            Future.microtask(() {
              if (mounted) {
                GoRouter.of(context)
                    .push(
                      EndPoints.representativeShipmentDetailsView,
                      extra: state.shipment,
                    )
                    .then((_) {
                      widget.onNavigationComplete();
                      if (mounted) {
                        setState(() {
                          _hasNavigated = false;
                        });
                      }
                    });
              }
            });
          }
        } else if (state is GetShipmentFailure) {
          _hasNavigated = false;
          widget.onNavigationComplete();

          if (mounted) {
            CustomSnackBar.showError(context, state.errorMessage);
          }
        }
      },
      child: _ShipmentItem(
        shipment: widget.shipment,
        onTap: widget.onTap,
        isNavigating: widget.isLoading,
      ),
    );
  }
}

class _ShipmentItem extends StatelessWidget {
  const _ShipmentItem({
    required this.shipment,
    required this.onTap,
    required this.isNavigating,
  });

  final ShipmentModel shipment;
  final VoidCallback onTap;
  final bool isNavigating;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isNavigating ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(50),
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
                        color: Colors.white.withAlpha(300),
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
                        color: Colors.white.withAlpha(300),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          shipment.customPickupAddress,
                          style: AppStyles.styleMedium12(
                            context,
                          ).copyWith(color: Colors.white.withAlpha(400)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow Icon or Loading
            if (isNavigating)
              const SizedBox(
                width: 20,
                height: 20,
                child: CustomLoadingIndicator(color: Colors.white),
              )
            else
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
    String period = hour < 12 ? "صباحًا" : "مساءً";
    return "$displayHour $period";
  }
}
