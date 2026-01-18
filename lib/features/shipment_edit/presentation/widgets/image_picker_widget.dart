import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'dart:io';

import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/generated/l10n.dart';

class ImagePickerWidget extends StatefulWidget {
  final double width;
  final double height;
  final String? defaultImagePath;
  final Function(File?)? onImageChanged;
  final bool showRemoveOption;
  final String addImageText;
  final IconData addImageIcon;

  const ImagePickerWidget({
    super.key,
    this.width = 80,
    this.height = 80,
    this.defaultImagePath,
    this.onImageChanged,
    this.showRemoveOption = true,
    this.addImageText = 'إضافة صورة',
    this.addImageIcon = Icons.add_a_photo,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // مؤشر السحب
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // عنوان
                Text(
                  'اختر مصدر الصورة',
                  style: AppStyles.styleSemiBold18(context).copyWith(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // خيارات الاختيار
                _buildBottomSheetOption(
                  icon: Icons.photo_library_rounded,
                  title: 'اختر من المعرض',
                  subtitle: 'تصفح الصور المحفوظة',
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.gallery);
                  },
                ),

                _buildBottomSheetOption(
                  icon: Icons.camera_alt_rounded,
                  title: 'التقط صورة جديدة',
                  subtitle: 'استخدام الكاميرا',
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.camera);
                  },
                ),

                // خيار حذف الصورة (إذا كان متاحاً)
                if (selectedImage != null && widget.showRemoveOption)
                  _buildBottomSheetOption(
                    icon: Icons.delete_rounded,
                    title: 'حذف الصورة',
                    subtitle: 'إزالة الصورة الحالية',
                    textColor: Colors.red,
                    onTap: () {
                      Navigator.of(context).pop();
                      _removeImage();
                    },
                  ),

                const SizedBox(height: 10),

                // زر الإلغاء
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    S.of(context).close,
                    style: AppStyles.styleMedium16(
                      context,
                    ).copyWith(color: AppColors.subTextColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryColor, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.styleSemiBold16(
                      context,
                    ).copyWith(color: textColor ?? Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: AppStyles.styleRegular12(
                      context,
                    ).copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85, // ضغط الصورة لتوفير مساحة
      );

      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
          _isLoading = false;
        });
        widget.onImageChanged?.call(selectedImage);

        // إظهار رسالة نجاح
        if (mounted) {
          CustomSnackBar.showSuccess(
            context,
            source == ImageSource.camera
                ? 'تم التقاط الصورة بنجاح'
                : 'تم اختيار الصورة بنجاح',
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        CustomSnackBar.showError(
          context,
          'حدث خطأ في اختيار الصورة: ${e.toString()}',
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      selectedImage = null;
    });
    widget.onImageChanged?.call(null);

    CustomSnackBar.showInfo(context, 'تم حذف الصورة');
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.addImageIcon,
                  size: widget.width * 0.3,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.addImageText,
                  style: AppStyles.styleMedium12(
                    context,
                  ).copyWith(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }

  Widget _buildImageWithOverlay() {
    return Stack(
      children: [
        // الصورة
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              selectedImage!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholderImage();
              },
            ),
          ),
        ),

        // طبقة شفافة مع أيقونة التعديل
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withAlpha(150),
            ),
            child: const Center(
              child: Icon(Icons.edit_rounded, color: Colors.white, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: selectedImage != null
            ? _buildImageWithOverlay()
            : widget.defaultImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.defaultImagePath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                ),
              )
            : _buildPlaceholderImage(),
      ),
    );
  }
}
