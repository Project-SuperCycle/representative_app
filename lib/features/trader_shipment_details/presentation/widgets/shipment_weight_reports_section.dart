import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/shipment_segment_model.dart';

class ShipmentWeightReportsSection extends StatelessWidget {
  final List<ShipmentSegmentModel> segments;
  const ShipmentWeightReportsSection({super.key, required this.segments});

  // Filter segments that have weight reports
  List<ShipmentSegmentModel> get segmentsWithReports {
    return segments.where((segment) => segment.weightReport != null).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (segmentsWithReports.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weight Reports List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: segmentsWithReports.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final segment = segmentsWithReports[index];
            return WeightReportRow(segment: segment, reportNumber: index + 1);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class WeightReportRow extends StatelessWidget {
  final ShipmentSegmentModel segment;
  final int reportNumber;
  const WeightReportRow({
    super.key,
    required this.segment,
    required this.reportNumber,
  });

  @override
  Widget build(BuildContext context) {
    final weightReport = segment.weightReport!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Report Number Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'تقرير #$reportNumber',
            style: AppStyles.styleBold12(context).copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        // Two Cards Side by Side
        Row(
          children: [
            // Weight Card
            Expanded(
              child: _WeightCard(actualWeightKg: weightReport.actualWeightKg),
            ),
            const SizedBox(width: 12),
            // Gallery Card
            Expanded(
              child: _GalleryCard(
                images: weightReport.images,
                reportNumber: reportNumber,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WeightCard extends StatelessWidget {
  final num actualWeightKg;
  const _WeightCard({required this.actualWeightKg});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade200, Colors.green.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.monitor_weight_outlined,
              size: 100,
              color: Colors.white.withAlpha(50),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(100),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.scale,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'الوزن الفعلي',
                        style: AppStyles.styleBold12(
                          context,
                        ).copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$actualWeightKg',
                    style: AppStyles.styleBold24(
                      context,
                    ).copyWith(color: Colors.white, fontSize: 30),
                  ),
                ),
                Text(
                  'كيلوجرام',
                  style: AppStyles.styleMedium14(
                    context,
                  ).copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  final List<String> images;
  final int reportNumber;
  const _GalleryCard({required this.images, required this.reportNumber});

  @override
  Widget build(BuildContext context) {
    final hasImages = images.isNotEmpty;
    return GestureDetector(
      onTap: hasImages ? () => _openGalleryModal(context) : null,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: hasImages
                ? [Colors.blue.shade200, Colors.blue.shade400]
                : [Colors.grey.shade200, Colors.grey.shade300],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: hasImages
                  ? Colors.blue.withAlpha(100)
                  : Colors.grey.withAlpha(50),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Pattern
            if (hasImages)
              Positioned(
                left: -20,
                bottom: -20,
                child: Icon(
                  Icons.photo_library_outlined,
                  size: 100,
                  color: Colors.white.withAlpha(50),
                ),
              ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(100),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            hasImages ? Icons.photo_library : Icons.hide_image,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'المعرض',
                          style: AppStyles.styleBold12(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (hasImages) ...[
                    Text(
                      '${images.length}',
                      style: AppStyles.styleBold24(
                        context,
                      ).copyWith(color: Colors.white, fontSize: 30),
                    ),
                    Text(
                      'صورة',
                      style: AppStyles.styleMedium14(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ] else ...[
                    Text(
                      'لا يوجد',
                      style: AppStyles.styleBold20(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                    Text(
                      'صور متاحة',
                      style: AppStyles.styleSemiBold14(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ],
                ],
              ),
            ),
            // Tap indicator
            if (hasImages)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(100),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.touch_app,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openGalleryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _ImageGalleryModal(images: images, reportNumber: reportNumber),
    );
  }
}

class _ImageGalleryModal extends StatefulWidget {
  final List<String> images;
  final int reportNumber;

  const _ImageGalleryModal({required this.images, required this.reportNumber});

  @override
  State<_ImageGalleryModal> createState() => _ImageGalleryModalState();
}

class _ImageGalleryModalState extends State<_ImageGalleryModal> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Title and Close Button
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'تقرير #${widget.reportNumber} - صورة ${_currentIndex + 1} من ${widget.images.length}',
                        style: AppStyles.styleSemiBold16(context),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Image Viewer
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stack) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'تعذر تحميل الصورة',
                                style: AppStyles.styleMedium14(
                                  context,
                                ).copyWith(color: Colors.white54),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // Thumbnail Strip
          if (widget.images.length > 1)
            Container(
              height: 100,
              color: Colors.grey.shade900,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _currentIndex;
                  return GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          widget.images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) {
                            return Container(
                              color: Colors.grey.shade800,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
