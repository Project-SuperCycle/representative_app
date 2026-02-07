import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:representative_app/core/helpers/custom_snack_bar.dart';
import 'package:representative_app/core/utils/app_assets.dart';
import 'package:representative_app/core/utils/app_colors.dart';
import 'package:representative_app/core/utils/app_styles.dart';
import 'package:representative_app/core/models/shipment/single_shipment_model.dart';
import 'package:representative_app/core/helpers/network_images_preview_dialog.dart';

class RepresentativeShipmentDetailsHeader extends StatelessWidget {
  final SingleShipmentModel shipment;
  const RepresentativeShipmentDetailsHeader({
    super.key,
    required this.shipment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        AppAssets.boxPerspective,
                        width: 25,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.orange,
                            size: 20,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        shipment.shipmentNumber,
                        style: AppStyles.styleSemiBold18(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  shipment.statusDisplay.toUpperCase(),
                  style: AppStyles.styleSemiBold16(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, color: _getStatusColor()),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'تاريخ الاستلام: ',
                      style: AppStyles.styleSemiBold14(context),
                    ),
                    Text(
                      _formatDateTime(shipment.requestedPickupAt),
                      style: AppStyles.styleSemiBold14(
                        context,
                      ).copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () =>
                _showImagesPreview(context, images: shipment.uploadedImages),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.asset(
                      AppAssets.photoGallery,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                          child: const Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    if (shipment.images.isNotEmpty)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(350),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${shipment.images.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagesPreview(
    BuildContext context, {
    required List<String> images,
  }) {
    if (images.isEmpty) {
      CustomSnackBar.showWarning(context, 'لا توجد صور للعرض');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        return NetworkImagesPreviewDialog(images: images);
      },
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '--/--/---- --:--';
    final DateTime adjustedDateTime = dateTime.subtract(Duration(hours: 2));
    return DateFormat('dd/MM/yyyy HH:mm').format(adjustedDateTime);
  }

  Color _getStatusColor() {
    switch (shipment.status) {
      case 'قيد المراجعة':
      case 'بانتظار المعاينة':
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
      case 'تم الرفض':
        return AppColors.failureColor;
      default:
        return Color(0xff1624A2);
    }
  }
}
