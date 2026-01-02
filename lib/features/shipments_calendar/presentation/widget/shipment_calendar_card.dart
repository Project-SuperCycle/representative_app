import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_cubit.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_state.dart';
import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';

class ShipmentsCalendarCard extends StatefulWidget {
  final ShipmentModel shipment;
  const ShipmentsCalendarCard({super.key, required this.shipment});

  @override
  State<ShipmentsCalendarCard> createState() => _ShipmentsCalendarCardState();
}

class _ShipmentsCalendarCardState extends State<ShipmentsCalendarCard> {
  String userRole = "";
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    LoginedUserModel? user = await StorageServices.getUserData();
    if (user != null && mounted) {
      setState(() {
        userRole = user.role ?? "";
      });
    }
  }

  void _showShipmentDetails(BuildContext context) {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    BlocProvider.of<ShipmentsCalendarCubit>(context).getShipmentById(
      shipmentId: widget.shipment.id,
      type: widget.shipment.type,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShipmentsCalendarCubit, ShipmentsCalendarState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is GetShipmentSuccess && _isNavigating) {
          final targetRoute = (userRole == 'representative')
              ? EndPoints.representativeShipmentDetailsView
              : EndPoints.traderShipmentDetailsView;

          // استخدم push مع then للرجوع
          context.push(targetRoute, extra: state.shipment).then((_) {
            // لما ترجع من الصفحة، reset الـ flag
            if (mounted) {
              setState(() {
                _isNavigating = false;
              });
            }
          });
        }

        if (state is GetShipmentFailure && _isNavigating) {
          if (mounted) {
            setState(() {
              _isNavigating = false;
            });

            CustomSnackBar.showError(context, state.errorMessage);
          }
        }
      },
      child: Card(
        elevation: 1.5,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                Text(
                                  'رقم الشحنة: ',
                                  style: AppStyles.styleSemiBold16(context),
                                ),
                                Text(
                                  widget.shipment.shipmentNumber,
                                  style: AppStyles.styleMedium16(
                                    context,
                                  ).copyWith(color: AppColors.greenColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _formatTimeToArabic(
                                widget.shipment.requestedPickupAt,
                              ),
                              style: AppStyles.styleRegular14(
                                context,
                              ).copyWith(color: AppColors.greenColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1.5,
                      indent: 10,
                      endIndent: 10,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Text(
                                'الكمية: ',
                                style: AppStyles.styleSemiBold14(context),
                              ),
                              Text(
                                widget.shipment.totalQuantityKg.toString(),
                                style: AppStyles.styleMedium14(
                                  context,
                                ).copyWith(color: AppColors.subTextColor),
                              ),
                            ],
                          ),
                        ),

                        (widget.shipment.isExtra)
                            ? Image.asset(
                                AppAssets.extraBox,
                                width: 25,
                                height: 25,
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Text(
                            'العنوان: ',
                            style: AppStyles.styleSemiBold14(context),
                          ),
                          Text(
                            widget.shipment.customPickupAddress,
                            style: AppStyles.styleMedium14(
                              context,
                            ).copyWith(color: AppColors.subTextColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Text(
                            'الحالة: ',
                            style: AppStyles.styleSemiBold14(context),
                          ),
                          Text(
                            widget.shipment.status.toUpperCase(),
                            style: AppStyles.styleMedium14(context).copyWith(
                              color: _getStatusColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _isNavigating
                    ? null
                    : () => _showShipmentDetails(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _isNavigating
                        ? AppColors.primaryColor.withAlpha(300)
                        : AppColors.primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: _isNavigating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'إظهار التفاصيل',
                            style: AppStyles.styleSemiBold14(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeToArabic(DateTime dateTime) {
    int hour = dateTime.hour - 2;
    int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    String period = hour < 12 ? "صباحا" : "مساءا";
    return "$displayHour $period";
  }

  Color _getStatusColor() {
    switch (widget.shipment.status) {
      case 'قيد المراجعة':
        return Color(0xff1624A2);
      case 'تمت الموافقة':
        return Color(0xff3BC567);
      case 'تمت المعاينة':
      case 'في طريق التسليم':
      case 'جار الاستلام':
        return Color(0xffE04133);
      case 'تم الاستلام':
      case 'تم التسليم':
      case 'تسليم جزئي':
        return Color(0xff3BC567);
      default:
        return Color(0xff1624A2);
    }
  }
}
