import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'dart:io';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/fail_segment_cubit/fail_segment_cubit.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/weigh_segment_cubit/weigh_segment_cubit.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/weigh_segment_cubit/weigh_segment_state.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/fail_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/segment_fail_modal/segment_fail_modal.dart';

class SegmentWeightSection extends StatefulWidget {
  final VoidCallback? onWeightedPressed;
  final Function(List<File>?)? onImagesSelected;
  final int maxImages; // Maximum number of images allowed
  final String shipmentID;
  final String segmentID;
  final TextEditingController weightController;

  const SegmentWeightSection({
    super.key,
    this.onWeightedPressed,
    this.onImagesSelected,
    this.maxImages = 5,
    required this.shipmentID,
    required this.segmentID,
    required this.weightController,
  });

  @override
  State<SegmentWeightSection> createState() => _SegmentWeightSectionState();
}

class _SegmentWeightSectionState extends State<SegmentWeightSection> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    widget.weightController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    widget.weightController.removeListener(_updateButtonState);
    widget.weightController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final newState =
        _selectedImages.isNotEmpty &&
        widget.weightController.text.trim().isNotEmpty;
    if (_isButtonEnabled != newState) {
      setState(() {
        _isButtonEnabled = newState;
      });
    }
  }

  void _showFailModal(BuildContext context) {
    SegmentFailModal.show(
      context,
      shipmentID: widget.shipmentID,
      onSubmit: (List<File> images, String reason) {
        FailSegmentModel failModel = FailSegmentModel(
          shipmentID: widget.shipmentID,
          segmentID: widget.segmentID,
          reason: reason,
          images: images,
        );

        // هنا أضف منطق إرسال البيانات للـ API
        BlocProvider.of<FailSegmentCubit>(
          context,
        ).failSegment(failModel: failModel);

        CustomSnackBar.showWarning(context, 'تم تسجيل العطلة');
      },
    );
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= widget.maxImages) {
      CustomSnackBar.showWarning(
        context,
        'لا يمكن إضافة أكثر من ${widget.maxImages} صور',
      );

      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildImageSourceOption(
                        icon: Icons.photo_camera_rounded,
                        title: 'التقاط صورة',
                        subtitle: 'استخدم الكاميرا',
                        onTap: () async {
                          Navigator.pop(context);
                          await _getImage(ImageSource.camera);
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildImageSourceOption(
                        icon: Icons.photo_library_rounded,
                        title: 'اختيار من المعرض',
                        subtitle:
                            'اختر صور موجودة (حد أقصى ${5 - _selectedImages.length})',
                        onTap: () async {
                          Navigator.pop(context);
                          await _getMultipleImages();
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_back_ios_rounded,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
        widget.onImagesSelected?.call(_selectedImages);
        _updateButtonState();
      }
    } catch (e) {
      CustomSnackBar.showError(context, 'حدث خطأ أثناء اختيار الصورة: $e');
    }
  }

  Future<void> _getMultipleImages() async {
    try {
      final remainingSlots = widget.maxImages - _selectedImages.length;
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        final imagesToAdd = pickedFiles.take(remainingSlots).toList();
        setState(() {
          _selectedImages.addAll(imagesToAdd.map((xFile) => File(xFile.path)));
        });

        if (pickedFiles.length > remainingSlots) {
          CustomSnackBar.showError(
            context,
            'تم إضافة $remainingSlots صور فقط. الحد الأقصى ${widget.maxImages} صور',
          );
        }

        widget.onImagesSelected?.call(_selectedImages);
        _updateButtonState();
      }
    } catch (e) {
      CustomSnackBar.showError(context, 'حدث خطأ أثناء اختيار الصور: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesSelected?.call(
      _selectedImages.isEmpty ? null : _selectedImages,
    );
    _updateButtonState();
  }

  String get weightValue => widget.weightController.text;
  List<File> get selectedImages => _selectedImages;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: const Color(0xFF5C6BC0),
          strokeWidth: 1.5,
          dashWidth: 6,
          dashSpace: 6,
          borderRadius: 16,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title with camera icon
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_selectedImages.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3F51B5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_selectedImages.length}/${widget.maxImages}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      'صور الوزنة',
                      style: AppStyles.styleSemiBold16(context),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.photo_camera_outlined,
                      color: Color(0xFF3F51B5),
                      size: 25,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Images grid
              if (_selectedImages.isEmpty)
                // Empty state - show upload area
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.photo_camera_outlined,
                          size: 60,
                          color: Color(0xFF5C6BC0),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'اضغط لإضافة صور الوزنة',
                          style: AppStyles.styleMedium14(
                            context,
                          ).copyWith(color: AppColors.subTextColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'يمكنك إضافة حتى ${widget.maxImages} صور',
                          style: AppStyles.styleMedium12(context).copyWith(
                            color: AppColors.subTextColor.withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                // Images grid with add button
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount:
                      _selectedImages.length +
                      (_selectedImages.length < widget.maxImages ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _selectedImages.length) {
                      // Add more button
                      return GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF5C6BC0),
                              width: 2,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 32,
                                color: Color(0xFF5C6BC0),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'إضافة',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF5C6BC0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Image item
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImages[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          left: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red.withAlpha(250),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        // Image number badge
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(179),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

              const SizedBox(height: 24),

              // Actual weight label
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'الوزن الفعلي',
                  style: AppStyles.styleSemiBold14(context),
                ),
              ),
              const SizedBox(height: 12),

              // Weight input field
              Row(
                children: [
                  Text('طن', style: AppStyles.styleSemiBold16(context)),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: widget.weightController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      style: AppStyles.styleMedium14(context),
                      decoration: InputDecoration(
                        hintText: 'أدخل الوزن',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Upload button
              BlocConsumer<WeighSegmentCubit, WeighSegmentState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is WeighSegmentSuccess) {
                    CustomSnackBar.showSuccess(context, state.message);
                  }
                  if (state is WeighSegmentFailure) {
                    CustomSnackBar.showSuccess(context, state.errorMessage);
                  }
                },
                builder: (context, state) {
                  if (state is WeighSegmentLoading) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CustomLoadingIndicator(),
                        ),
                      ],
                    );
                  }
                  return Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: ElevatedButton(
                            onPressed: _isButtonEnabled
                                ? () {
                                    widget.onWeightedPressed?.call();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isButtonEnabled
                                  ? AppColors.primaryColor
                                  : const Color(0xFFBDBDBD),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              disabledBackgroundColor: const Color(0xFFBDBDBD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'رفع الوزنة',
                                style: AppStyles.styleBold14(context).copyWith(
                                  color: _isButtonEnabled
                                      ? Colors.white
                                      : AppColors.mainTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: ElevatedButton(
                            onPressed: () {
                              _showFailModal(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.failureColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              disabledBackgroundColor: const Color(0xFFBDBDBD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'عطلة',
                              style: AppStyles.styleBold14(
                                context,
                              ).copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for dashed border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            strokeWidth / 2,
            strokeWidth / 2,
            size.width - strokeWidth,
            size.height - strokeWidth,
          ),
          Radius.circular(borderRadius),
        ),
      );

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final dashPath = Path();
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;

      while (distance < metric.length) {
        final length = draw ? dashWidth : dashSpace;
        final endDistance = distance + length;

        if (endDistance > metric.length) {
          if (draw) {
            dashPath.addPath(
              metric.extractPath(distance, metric.length),
              Offset.zero,
            );
          }
          break;
        }

        if (draw) {
          dashPath.addPath(
            metric.extractPath(distance, endDistance),
            Offset.zero,
          );
        }

        distance = endDistance;
        draw = !draw;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
