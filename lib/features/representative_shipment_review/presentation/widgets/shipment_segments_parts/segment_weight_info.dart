import 'dart:io';
import 'package:flutter/material.dart';
import 'package:representative_app/core/helpers/custom_loading_indicator.dart';
import 'package:representative_app/core/utils/app_colors.dart';
import 'package:representative_app/core/utils/app_styles.dart';
import 'package:representative_app/features/representative_shipment_review/data/models/shipment_segment_model.dart';
import 'package:representative_app/features/representative_shipment_review/data/models/weigh_segment_model.dart';

class SegmentWeightInfo extends StatefulWidget {
  final String imagePath;
  final ShipmentSegmentModel segment;
  final WeighSegmentModel? localWeightReport; // Added for local data

  const SegmentWeightInfo({
    super.key,
    required this.imagePath,
    required this.segment,
    this.localWeightReport,
  });

  @override
  State<SegmentWeightInfo> createState() => _SegmentWeightInfoState();
}

class _SegmentWeightInfoState extends State<SegmentWeightInfo> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ✅ Get images from localWeightReport (File) or segment.weightReport (String)
  List<dynamic> get _images {
    // Priority: localWeightReport > segment.weightReport
    if (widget.localWeightReport != null) {
      return widget.localWeightReport!.images; // List<File>
    }
    if (widget.segment.weightReport != null) {
      return widget.segment.weightReport!.images; // List<String>
    }
    return [];
  }

  num get _actualWeight {
    if (widget.localWeightReport != null) {
      return widget.localWeightReport!.actualWeightKg;
    }
    if (widget.segment.weightReport != null) {
      return widget.segment.weightReport!.actualWeightKg;
    }
    return 0.0;
  }

  bool get _hasImages => _images.isNotEmpty;

  // ✅ Check if image is local file path or network URL
  bool _isLocalFile(String path) {
    return !path.startsWith('http://') && !path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.25),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image Slider Display
          _buildImageSlider(),

          // Image Indicators (Dots)
          if (_hasImages && _images.length > 1) ...[
            const SizedBox(height: 12),
            _buildImageIndicators(),
          ],

          // Weight Display
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0).withAlpha(100),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'الوزن الفعلي',
                  style: AppStyles.styleMedium14(
                    context,
                  ).copyWith(color: AppColors.subTextColor),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${_actualWeight.toStringAsFixed(2)} كجم",
                    style: AppStyles.styleSemiBold16(context),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    if (!_hasImages) {
      return _buildEmptyImagePlaceholder();
    }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[100],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return _buildImageItem(_images[index]);
              },
            ),
          ),
        ),

        // Image Counter Badge
        if (_images.length > 1)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentImageIndex + 1}/${_images.length}',
                style: AppStyles.styleSemiBold12(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
          ),

        // Navigation Arrows (if more than 1 image)
        if (_images.length > 1) ...[
          // Left Arrow
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildNavigationButton(
                icon: Icons.arrow_back_ios_rounded,
                onPressed: () {
                  if (_currentImageIndex > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ),

          // Right Arrow
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildNavigationButton(
                icon: Icons.arrow_forward_ios_rounded,
                onPressed: () {
                  if (_currentImageIndex < _images.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageItem(dynamic image) {
    // ✅ Check if it's a File (local) or String
    if (image is File) {
      return Image.file(
        image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    } else if (image is String) {
      // ✅ Check if it's a local file path or network URL
      if (_isLocalFile(image)) {
        // ✅ It's a local file path
        return Image.file(
          File(image),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        );
      } else {
        // ✅ It's a network URL
        return Image.network(
          image,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CustomLoadingIndicator(color: AppColors.primaryColor),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        );
      }
    }

    return _buildErrorWidget();
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(300),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildImageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _images.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentImageIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentImageIndex == index
                ? AppColors.primaryColor
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: _buildErrorWidget(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'الصورة غير متاحة',
            style: AppStyles.styleMedium14(
              context,
            ).copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
