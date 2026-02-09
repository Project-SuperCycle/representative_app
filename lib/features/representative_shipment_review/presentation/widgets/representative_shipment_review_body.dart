import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:representative_app/core/constants.dart';
import 'package:representative_app/core/widgets/navbar/custom_curved_navigation_bar.dart';
import 'package:representative_app/core/widgets/shipment/shipment_logo.dart';
import 'package:representative_app/core/models/shipment/single_shipment_model.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/representative_shipment_review_header.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/shipment_segment_card/shipment_segment_card.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/widgets/shipment_states_row/representative_shipment_states.dart';
import 'package:representative_app/features/representative_shipment_review/data/models/shipment_segment_model.dart';

class RepresentativeShipmentReviewBody extends StatefulWidget {
  const RepresentativeShipmentReviewBody({super.key, required this.shipment});
  final SingleShipmentModel shipment;

  @override
  State<RepresentativeShipmentReviewBody> createState() =>
      _RepresentativeShipmentReviewBodyState();
}

class _RepresentativeShipmentReviewBodyState
    extends State<RepresentativeShipmentReviewBody> {
  int _page = 3;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ✅ Maintain segments state in parent
  late List<ShipmentSegmentModel> _segments;

  @override
  void initState() {
    super.initState();
    // ✅ Copy segments to local state
    _segments = List.from(widget.shipment.segments);
  }

  void _onNavigationTap(int index) {
    setState(() {
      _page = index;
    });
  }

  // ✅ Update full segment (including weight report)
  void _updateSegment(ShipmentSegmentModel updatedSegment) {
    setState(() {
      final index = _segments.indexWhere((seg) => seg.id == updatedSegment.id);
      if (index != -1) {
        _segments[index] = updatedSegment;
      }
    });
  }

  // ✅ حساب الـ overall shipment status بناءً على الـ segments
  String _calculateShipmentStatus() {
    if (_segments.isEmpty) return widget.shipment.status;

    // عدد الـ segments
    final totalSegments = _segments.length;

    // عدد الـ delivered segments
    final deliveredCount = _segments.where((seg) => seg.status == 'delivered').length;

    // عدد الـ failed segments
    final failedCount = _segments.where((seg) => seg.status == 'failed').length;

    // لو كل الـ segments اتوصلوا
    if (deliveredCount == totalSegments) {
      return 'delivered';
    }

    // لو في failed أو partially delivered
    if (failedCount > 0 || (deliveredCount > 0 && deliveredCount < totalSegments)) {
      return 'partially_delivered';
    }

    // لو في أي segment في طريقه للوجهة النهائية
    final anyInTransitToDestination = _segments.any(
          (seg) => seg.status == 'in_transit_to_destination',
    );
    if (anyInTransitToDestination) {
      return 'delivery_in_transit';
    }

    // لو في أي segment اتحرك للميزان
    final anyInTransitToScale = _segments.any(
          (seg) => seg.status == 'in_transit_to_scale',
    );
    if (anyInTransitToScale) {
      return 'complete_weighted';
    }

    return widget.shipment.status;
  }

  // ✅ دالة للرجوع مع الـ updated data
  void _handleBackPressed() {
    final updatedShipment = widget.shipment.copyWith(
      segments: _segments,
      status: _calculateShipmentStatus(),
    );

    // ✅ ارجع الـ updated shipment للشاشة اللي قبلها
    Navigator.pop(context, updatedShipment);
  }

  @override
  Widget build(BuildContext context) {
    // ✅ استخدم PopScope مع onPopInvokedWithResult
    return PopScope(
      canPop: false, // ✅ منع الـ default pop behavior
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          _handleBackPressed();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: const BoxDecoration(gradient: kGradientBackground),
          child: CustomScrollView(
            slivers: [
              // Header Section (Fixed)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const ShipmentLogo(),
                ),
              ),

              // White Container Content (Scrollable)
              SliverFillRemaining(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              RepresentativeShipmentReviewHeader(
                                shipment: widget.shipment,
                              ),
                              const SizedBox(height: 6),

                              // ✅ Stats widget - will auto-update when _segments changes
                              RepresentativeShipmentStates(
                                // ✅ Create new shipment object with updated segments
                                shipment: widget.shipment.copyWith(
                                  segments: _segments,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),

                        // ✅ Build cards from parent state
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              return ShipmentSegmentCard(
                                key: ValueKey(_segments[index].id), // ✅ Unique key per segment
                                shipmentID: widget.shipment.id,
                                segment: _segments[index], // ✅ From parent state
                                onSegmentUpdated: _updateSegment, // ✅ New callback
                              );
                            },
                            childCount: _segments.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomCurvedNavigationBar(
          currentIndex: _page,
          navigationKey: _bottomNavigationKey,
          onTap: _onNavigationTap,
        ),
      ),
    );
  }
}