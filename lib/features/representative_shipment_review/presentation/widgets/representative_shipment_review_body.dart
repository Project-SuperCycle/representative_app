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

  late List<ShipmentSegmentModel> _segments;
  bool _isReturning = false; // ✅ NEW: Prevent multiple pops

  @override
  void initState() {
    super.initState();
    _segments = List.from(widget.shipment.segments);
  }

  void _onNavigationTap(int index) {
    setState(() {
      _page = index;
    });
  }

  void _updateSegment(ShipmentSegmentModel updatedSegment) {
    setState(() {
      final index = _segments.indexWhere((seg) => seg.id == updatedSegment.id);
      if (index != -1) {
        _segments[index] = updatedSegment;
      }
    });
  }

  String _calculateShipmentStatus() {
    if (_segments.isEmpty) return widget.shipment.status;

    final totalSegments = _segments.length;
    final deliveredCount = _segments.where((seg) => seg.status == 'delivered').length;
    final failedCount = _segments.where((seg) => seg.status == 'failed').length;

    if (deliveredCount == totalSegments) {
      return 'delivered';
    }

    if (failedCount > 0 || (deliveredCount > 0 && deliveredCount < totalSegments)) {
      return 'partially_delivered';
    }

    final anyInTransitToDestination = _segments.any(
          (seg) => seg.status == 'in_transit_to_destination',
    );
    if (anyInTransitToDestination) {
      return 'delivery_in_transit';
    }

    final anyInTransitToScale = _segments.any(
          (seg) => seg.status == 'in_transit_to_scale',
    );
    if (anyInTransitToScale) {
      return 'complete_weighted';
    }

    return widget.shipment.status;
  }

  void _handleBackPressed() {
    // ✅ Prevent multiple simultaneous pops
    if (_isReturning) return;

    setState(() {
      _isReturning = true;
    });

    final updatedShipment = widget.shipment.copyWith(
      segments: _segments,
      status: _calculateShipmentStatus(),
    );

    Navigator.pop(context, updatedShipment);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        // ✅ Only handle if pop didn't happen yet
        if (!didPop && !_isReturning) {
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const ShipmentLogo(),
                ),
              ),

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
                              RepresentativeShipmentReviewHeader(
                                shipment: widget.shipment,
                              ),
                              const SizedBox(height: 6),

                              RepresentativeShipmentStates(
                                shipment: widget.shipment.copyWith(
                                  segments: _segments,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),

                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              return ShipmentSegmentCard(
                                key: ValueKey(_segments[index].id),
                                shipmentID: widget.shipment.id,
                                segment: _segments[index],
                                onSegmentUpdated: _updateSegment,
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