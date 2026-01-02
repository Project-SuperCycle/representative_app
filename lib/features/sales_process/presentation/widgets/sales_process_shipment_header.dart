import 'package:flutter/material.dart';
import 'package:supercycle/core/helpers/date_time_picker_util.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'dart:io';
import 'image_picker_widget.dart';
import 'package:intl/intl.dart';

class SalesProcessShipmentHeader extends StatefulWidget {
  final List<File> selectedImages;
  final Function(List<File>) onImagesChanged;
  final Function(DateTime?) onDateTimeChanged;

  const SalesProcessShipmentHeader({
    super.key,
    required this.selectedImages,
    required this.onImagesChanged,
    required this.onDateTimeChanged,
  });

  @override
  State<SalesProcessShipmentHeader> createState() =>
      _SalesProcessShipmentHeaderState();
}

class _SalesProcessShipmentHeaderState
    extends State<SalesProcessShipmentHeader> {
  DateTime? selectedDateTime; // تغيير الاسم ليشمل الوقت أيضاً

  void _onImageChanged(File? image) {
    if (image != null) {
      List<File> updatedImages = List.from(widget.selectedImages);
      updatedImages.add(image);
      widget.onImagesChanged(updatedImages);
    }
  }

  void _removeImage(int index) {
    List<File> updatedImages = List.from(widget.selectedImages);
    updatedImages.removeAt(index);
    widget.onImagesChanged(updatedImages);
  }

  void _clearAllImages() {
    widget.onImagesChanged([]);
  }

  Future<void> _selectDate() async {
    final DateTime? result = await DateTimePickerHelper.selectDateTime(
      context,
      currentSelectedDateTime: selectedDateTime,
    );

    if (result != null) {
      setState(() {
        selectedDateTime = result;
      });
      widget.onDateTimeChanged(selectedDateTime);
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '--/--/---- --:--';
    final DateTime adjustedDateTime = dateTime.subtract(Duration(hours: 2));
    return DateFormat('dd/MM/yyyy HH:mm').format(adjustedDateTime);
  }

  Widget _buildImagesPreview() {
    if (widget.selectedImages.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.selectedImages.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(1),
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    widget.selectedImages[index],
                    width: 80,
                    height: 90,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 90,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: ClipRRect(
                              child: Image.asset(
                                AppAssets.boxPerspective,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.inventory_2_outlined,
                                    color: Colors.orange,
                                    size: 25,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'رقم الشحنة: ',
                            style: AppStyles.styleSemiBold18(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'لم يحدد بعد ',
                            style: AppStyles.styleSemiBold12(
                              context,
                            ).copyWith(color: AppColors.subTextColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Text(
                            'موعد الاستلام: ',
                            style: AppStyles.styleMedium12(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _formatDateTime(selectedDateTime),
                            style: AppStyles.styleMedium12(
                              context,
                            ).copyWith(color: AppColors.subTextColor),
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.grey.shade100,
                              shadowColor: Colors.grey,
                              elevation: 1,
                            ),
                            onPressed: _selectDate,
                            icon: const Icon(
                              Icons.edit_calendar_sharp,
                              color: Colors.black54,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // عرض عدد الصور المحددة
                    if (widget.selectedImages.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Text(
                              'الصور المحددة: ${widget.selectedImages.length}',
                              style: AppStyles.styleSemiBold12(
                                context,
                              ).copyWith(color: Colors.blue),
                            ),
                            const SizedBox(width: 8),
                            if (widget.selectedImages.length > 1)
                              GestureDetector(
                                onTap: _clearAllImages,
                                child: Text(
                                  'حذف الكل',
                                  style: AppStyles.styleMedium12(context)
                                      .copyWith(
                                        color: Colors.red,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                ImagePickerWidget(
                  defaultImagePath: AppAssets.photoGallery,
                  onImageChanged: _onImageChanged,
                ),
                const SizedBox(height: 4),
                Text(
                  'إضافة صورة',
                  style: AppStyles.styleMedium12(
                    context,
                  ).copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
        // معاينة الصور المحددة
        _buildImagesPreview(),
      ],
    );
  }
}
