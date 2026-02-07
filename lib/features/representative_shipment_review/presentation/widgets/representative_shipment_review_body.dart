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

  // ✅ Update specific segment in parent state
  void _updateSegmentStatus(String segmentId, String newStatus) {
    setState(() {
      final index = _segments.indexWhere((seg) => seg.id == segmentId);
      if (index != -1) {
        _segments[index] = _segments[index].copyWith(status: newStatus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              onSegmentStatusChanged: _updateSegmentStatus, // ✅ New callback
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
    );
  }
}