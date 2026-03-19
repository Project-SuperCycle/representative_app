import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:representative_app/core/constants.dart';
import 'package:representative_app/core/helpers/custom_fading_widget.dart';
import 'package:representative_app/core/helpers/custom_snack_bar.dart';
import 'package:representative_app/core/routes/end_points.dart';
import 'package:representative_app/core/widgets/shipment/shipment_logo.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/loading/shipment_details_loading_header.dart';
import 'package:representative_app/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_cubit.dart';
import 'package:representative_app/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_state.dart';

class ShipmentDetailsLoadingIndicator extends StatelessWidget {
  const ShipmentDetailsLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShipmentsCalendarCubit, ShipmentsCalendarState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is GetShipmentFailure) {
          CustomSnackBar.showError(context, state.errorMessage);
        }

        if (state is GetShipmentSuccess) {
          // Navigate once with the shipment data
          GoRouter.of(context).pushReplacement(
            EndPoints.representativeShipmentDetailsView,
            extra: state.shipment,
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(gradient: kGradientBackground),
          child: SafeArea(
            child: Column(
              children: [
                // ======== Header (ShipmentLogo) ========
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: const ShipmentLogo(),
                ),

                // ======== White Content Area ========
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 25, 20, 30), // ✅
                        child: Column(
                          children: [
                            _buildProgressBarShimmer(),
                            const SizedBox(height: 16),
                            _buildHeaderCardShimmer(),
                            const SizedBox(height: 20),

                            // ✅ مفيش Padding wrapper هنا خالص
                            _buildRepresentativeCardShimmer(),
                            const SizedBox(height: 20),
                            _buildExpandableCardShimmer(delay: 0),
                            const SizedBox(height: 16),
                            _buildExpandableCardShimmer(delay: 80),
                            const SizedBox(height: 16),
                            _buildAddressSectionShimmer(),
                            const SizedBox(height: 20),
                            _buildNotesCardShimmer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Progress Bar ──────────────────────────────────────────────────────────
  Widget _buildProgressBarShimmer() {
    return Row(
      children: List.generate(5, (index) {
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: CustomFadingWidget(
                  duration: Duration(milliseconds: 880 + (index * 60)),
                  child: CustomFadingWidget.box(
                    height: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              if (index < 4) const SizedBox(width: 4),
            ],
          ),
        );
      }),
    );
  }

  // ── Header Card ───────────────────────────────────────────────────────────
  Widget _buildHeaderCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: const ShipmentDetailsLoadingHeader(),
    );
  }

  // ── Representative Card ───────────────────────────────────────────────────
  Widget _buildRepresentativeCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CustomFadingWidget.circle(radius: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFadingWidget.line(width: 120, height: 14, radius: 5),
                const SizedBox(height: 8),
                CustomFadingWidget(
                  duration: const Duration(milliseconds: 950),
                  child: CustomFadingWidget.line(
                    width: 80,
                    height: 12,
                    radius: 4,
                  ),
                ),
              ],
            ),
          ),
          CustomFadingWidget.box(
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }

  // ── Expandable Card ───────────────────────────────────────────────────────
  Widget _buildExpandableCardShimmer({required int delay}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: [
          // Chevron icon placeholder
          CustomFadingWidget(
            duration: Duration(milliseconds: 900 + delay),
            child: CustomFadingWidget.circle(radius: 12),
          ),
          // Title + icon
          Row(
            textDirection: TextDirection.ltr,

            children: [
              CustomFadingWidget(
                duration: Duration(milliseconds: 920 + delay),
                child: CustomFadingWidget.line(
                  width: 110,
                  height: 16,
                  radius: 5,
                ),
              ),
              const SizedBox(width: 10),
              CustomFadingWidget(
                duration: Duration(milliseconds: 940 + delay),
                child: CustomFadingWidget.box(
                  width: 28,
                  height: 28,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Address Section ───────────────────────────────────────────────────────
  Widget _buildAddressSectionShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.shade200.withValues(alpha: 0.75),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Address field
          CustomFadingWidget.box(
            height: 52,
            width: double.infinity,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 8),
          // Info note row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomFadingWidget(
                duration: const Duration(milliseconds: 960),
                child: CustomFadingWidget.line(
                  width: 180,
                  height: 12,
                  radius: 4,
                ),
              ),
              const SizedBox(width: 6),
              CustomFadingWidget(
                duration: const Duration(milliseconds: 940),
                child: CustomFadingWidget.circle(radius: 8),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Notes Card ────────────────────────────────────────────────────────────
  Widget _buildNotesCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomFadingWidget.line(width: 80, height: 16, radius: 5),
              const SizedBox(width: 10),
              CustomFadingWidget.circle(radius: 12),
            ],
          ),
          const SizedBox(height: 12),
          // Note lines
          ...List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomFadingWidget(
                duration: Duration(milliseconds: 930 + (index * 70)),
                child: CustomFadingWidget.line(
                  width: index == 2 ? 160 : double.infinity,
                  height: 13,
                  radius: 4,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
