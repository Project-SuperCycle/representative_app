import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/widgets/navbar/custom_curved_navigation_bar.dart';
import 'package:supercycle/core/widgets/shipment/shipment_logo.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/representative_shipment_review_header.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_segment_card/shipment_segment_card.dart';
import 'package:supercycle/features/representative_shipment_review/presentation/widgets/shipment_states_row/representative_shipment_states.dart';

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

  @override
  void initState() {
    super.initState();
  }

  void _onNavigationTap(int index) {
    setState(() {
      _page = index;
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
                            RepresentativeShipmentReviewHeader(
                              shipment: widget.shipment,
                            ),
                            const SizedBox(height: 6),
                            RepresentativeShipmentStates(
                              shipment: widget.shipment,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return ShipmentSegmentCard(
                            shipmentID: widget.shipment.id,
                            segment: widget.shipment.segments[index],
                          );
                        }, childCount: widget.shipment.segments.length),
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
