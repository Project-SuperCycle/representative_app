import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';

enum ShipmentActionType { reject, confirm }

class RepresentativeShipmentModal {
  static void show(
    BuildContext context, {
    required ShipmentActionType actionType,
    required Function(List<File>, String, double) onSubmit,
    required SingleShipmentModel shipment,
  }) {
    final isReject = actionType == ShipmentActionType.reject;
    final primaryColor = isReject
        ? const Color(0xFFE53935)
        : const Color(0xFF00C853);
    final gradientColors = isReject
        ? [const Color(0xFFE53935), const Color(0xFFD32F2F)]
        : [const Color(0xFF00C853), const Color(0xFF00B248)];

    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (modalSheetContext) {
        return [
          WoltModalSheetPage(
            backgroundColor: Colors.white,
            hasTopBarLayer: false,
            child: _ModalContent(
              shipment: shipment,
              actionType: actionType,
              primaryColor: primaryColor,
              gradientColors: gradientColors,
              onSubmit: (images, feedback, rating) {
                Navigator.of(modalSheetContext).pop();
                onSubmit(images, feedback, rating);
              },
              onClose: () => Navigator.of(modalSheetContext).pop(),
            ),
          ),
        ];
      },
      modalTypeBuilder: (context) => WoltModalType.dialog(),
      onModalDismissedWithBarrierTap: () => Navigator.of(context).pop(),
    );
  }
}

class _ModalContent extends StatefulWidget {
  final ShipmentActionType actionType;
  final Color primaryColor;
  final List<Color> gradientColors;
  final Function(List<File>, String, double) onSubmit;
  final VoidCallback onClose;
  final SingleShipmentModel shipment;

  const _ModalContent({
    required this.actionType,
    required this.primaryColor,
    required this.gradientColors,
    required this.onSubmit,
    required this.onClose,
    required this.shipment,
  });

  @override
  State<_ModalContent> createState() => _ModalContentState();
}

class _ModalContentState extends State<_ModalContent>
    with TickerProviderStateMixin {
  final TextEditingController _feedbackController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];
  static const int _maxImages = 5;
  double _rating = 0.0;
  bool _isSubmitting = false;
  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _contentFadeAnimation;

  bool get isReject => widget.actionType == ShipmentActionType.reject;
  bool get canAddMoreImages => _selectedImages.length < _maxImages;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerController,
            curve: Curves.easeOutCubic,
          ),
        );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _headerController.forward();
    _contentController.forward();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (!canAddMoreImages) {
      _showSnackBar('لقد وصلت للحد الأقصى من الصور (5 صور)');
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
                            'اختر صور موجودة (حد أقصى ${_maxImages - _selectedImages.length})',
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
                  color: widget.primaryColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: widget.primaryColor, size: 28),
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
    if (!canAddMoreImages) {
      _showSnackBar('لقد وصلت للحد الأقصى من الصور (5 صور)');
      return;
    }

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
        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      _showSnackBar('حدث خطأ أثناء اختيار الصورة', isError: true);
    }
  }

  Future<void> _getMultipleImages() async {
    if (!canAddMoreImages) {
      _showSnackBar('لقد وصلت للحد الأقصى من الصور (5 صور)');
      return;
    }

    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        final remainingSlots = _maxImages - _selectedImages.length;
        final imagesToAdd = pickedFiles.take(remainingSlots).toList();

        setState(() {
          _selectedImages.addAll(imagesToAdd.map((xFile) => File(xFile.path)));
        });

        HapticFeedback.mediumImpact();

        if (pickedFiles.length > remainingSlots) {
          _showSnackBar(
            'تم إضافة $remainingSlots صورة فقط (الحد الأقصى 5 صور)',
          );
        }
      }
    } catch (e) {
      _showSnackBar('حدث خطأ أثناء اختيار الصور', isError: true);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    HapticFeedback.lightImpact();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    isError
        ? CustomSnackBar.showError(context, message)
        : CustomSnackBar.showWarning(context, message);
  }

  Future<void> _onSubmitTap() async {
    if (_rating == 0.0) {
      _showSnackBar('يرجى تقييم الشحنة');
      return;
    }

    if (isReject && _rating > 2.0) {
      _showSnackBar('في حالة الرفض، يجب أن يكون التقييم 1 أو 2 فقط');
      return;
    }

    if (!isReject && _rating < 3.0) {
      _showSnackBar('في حالة التأكيد، يجب أن يكون التقييم من 3 إلى 5');
      return;
    }

    if (_selectedImages.isEmpty) {
      _showSnackBar('يرجى إضافة صورة واحدة على الأقل للشحنة');
      return;
    }

    if (isReject && _feedbackController.text.trim().isEmpty) {
      _showSnackBar('يرجى إدخال سبب الرفض');
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 500));

    widget.onSubmit(_selectedImages, _feedbackController.text, _rating);

    if (isReject) {
      var updatedShipment = widget.shipment.copyWith(status: "مرفوضة");
      GoRouter.of(context).push(
        EndPoints.representativeShipmentDetailsView,
        extra: updatedShipment,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _contentFadeAnimation,
              child: Column(
                children: [
                  _buildRatingSection(),
                  const SizedBox(height: 20),
                  _buildImageSection(),
                  const SizedBox(height: 20),
                  _buildFeedbackSection(),
                  const SizedBox(height: 28),
                  _buildSubmitButton(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _headerFadeAnimation,
      child: SlideTransition(
        position: _headerSlideAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isReject
                            ? Icons.cancel_rounded
                            : Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isReject ? 'رفض الشحنة' : 'تأكيد الشحنة',
                      style: AppStyles.styleBold22(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isReject
                          ? 'يرجى تحديد سبب الرفض'
                          : 'قم بتأكيد استلام الشحنة',
                      style: AppStyles.styleMedium14(
                        context,
                      ).copyWith(color: Colors.white.withAlpha(450)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA726).withAlpha(75),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFA726),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text('تقييم الشحنة', style: AppStyles.styleSemiBold16(context)),
            ],
          ),
          const SizedBox(height: 10),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 35,
            unratedColor: Colors.grey[200],
            itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
            itemBuilder: (context, _) =>
                const Icon(Icons.star_rounded, color: Color(0xFFFFA726)),
            onRatingUpdate: (rating) {
              setState(() => _rating = rating);
              HapticFeedback.lightImpact();
            },
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _rating == 0.0
                  ? Colors.grey[100]
                  : const Color(0xFFFFA726).withAlpha(50),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _rating == 0.0
                  ? 'لم يتم التقييم بعد'
                  : '${_rating.toStringAsFixed(1)} من 5.0 ⭐',
              style: AppStyles.styleSemiBold14(context).copyWith(
                color: _rating == 0.0
                    ? Colors.grey[600]
                    : const Color(0xFFFFA726),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.primaryColor.withAlpha(150), width: 2),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_camera_rounded,
                color: widget.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('صور الشحنة', style: AppStyles.styleSemiBold16(context)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.primaryColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_selectedImages.length}/$_maxImages',
                  style: AppStyles.styleSemiBold12(
                    context,
                  ).copyWith(color: widget.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Grid of images
          if (_selectedImages.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: _selectedImages.length + (canAddMoreImages ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _selectedImages.length) {
                  return _buildAddImageButton();
                }
                return _buildImageThumbnail(index);
              },
            )
          else
            _buildAddImageButton(isLarge: true),
        ],
      ),
    );
  }

  Widget _buildAddImageButton({bool isLarge = false}) {
    return GestureDetector(
      onTap: _pickImage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: isLarge ? 180 : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isLarge ? 20 : 12),
              decoration: BoxDecoration(
                color: widget.primaryColor.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_rounded,
                size: isLarge ? 40 : 24,
                color: widget.primaryColor,
              ),
            ),
            if (isLarge) ...[
              const SizedBox(height: 16),
              Text(
                'اضغط لإضافة صور',
                style: AppStyles.styleSemiBold14(context),
              ),
              const SizedBox(height: 4),
              Text(
                'حد أقصى 5 صور',
                style: AppStyles.styleRegular12(
                  context,
                ).copyWith(color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(_selectedImages[index], fit: BoxFit.cover),
          Positioned(
            top: 4,
            left: 4,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(350),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(350),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${index + 1}',
                style: AppStyles.styleBold12(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                isReject ? 'سبب الرفض :' : 'ملاحظات :',
                style: AppStyles.styleSemiBold16(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _feedbackController,
            textAlign: TextAlign.right,
            maxLines: 5,
            style: AppStyles.styleRegular14(context),
            decoration: InputDecoration(
              hintText: isReject
                  ? 'صف سبب رفض الشحنة بالتفصيل...'
                  : 'أضف أي ملاحظات إضافية...',
              hintStyle: AppStyles.styleRegular14(
                context,
              ).copyWith(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.all(20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: widget.primaryColor, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.gradientColors,
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withAlpha(200),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isSubmitting ? null : _onSubmitTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: _isSubmitting
                ? const Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isReject ? 'رفض الشحنة' : 'تأكيد الشحنة',
                        style: AppStyles.styleBold16(
                          context,
                        ).copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isReject ? Icons.close_rounded : Icons.check_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
