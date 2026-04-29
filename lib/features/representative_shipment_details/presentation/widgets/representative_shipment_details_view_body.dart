import 'package:flutter/material.dart';
import 'package:representative_app/core/constants.dart';
import 'package:representative_app/core/models/shipment/single_shipment_model.dart';
import 'package:representative_app/core/utils/app_assets.dart';
import 'package:representative_app/core/utils/app_colors.dart';
import 'package:representative_app/core/utils/app_styles.dart';
import 'package:representative_app/core/widgets/custom_button.dart';
import 'package:representative_app/core/widgets/custom_text_field.dart';
import 'package:representative_app/core/widgets/shipment/client_data_content.dart';
import 'package:representative_app/core/widgets/shipment/progress_widgets.dart';
import 'package:representative_app/core/widgets/shipment/shipment_logo.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/expandable_card/expandable_card.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/rep_shipment_cash_section/rep_shipment_cash_section.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/rep_shipment_cash_section/rep_shipment_cash_simple_section.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/representative_shipment_actions_row.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/representative_shipment_details_content.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/representative_shipment_details_header.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/representative_shipment_details_notes.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/representative_shipment_notes_content.dart';
import 'package:representative_app/features/representative_shipment_review/presentation/views/representative_shipment_review_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepresentativeShipmentDetailsViewBody extends StatefulWidget {
  const RepresentativeShipmentDetailsViewBody({
    super.key,
    required this.shipment,
  });
  final SingleShipmentModel shipment;

  @override
  State<RepresentativeShipmentDetailsViewBody> createState() =>
      _RepresentativeShipmentDetailsViewBodyState();
}

class _RepresentativeShipmentDetailsViewBodyState
    extends State<RepresentativeShipmentDetailsViewBody> {
  late SingleShipmentModel _currentShipment;

  bool isShipmentDetailsExpanded = false;
  bool isInspectedItemsExpanded = false;
  bool isClientDataExpanded = false;
  bool isNotesDataExpanded = false;

  bool isCashCollectionExpanded = false;
  bool hasActionBeenTaken = false;
  bool showInspectionActions = false;
  bool _isNavigating = false; // ✅ Simplified: One flag is enough
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String get _actionTakenKey => 'shipment_${_currentShipment.id}_action_taken';

  @override
  void initState() {
    super.initState();
    _currentShipment = widget.shipment;
    _loadActionState();
  }

  Future<void> _loadActionState() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        hasActionBeenTaken = prefs.getBool(_actionTakenKey) ?? false;
      });
    }
  }

  Future<void> _saveActionState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_actionTakenKey, value);
  }

  void _markActionAsTaken() {
    setState(() {
      hasActionBeenTaken = true;
      showInspectionActions = false;
    });
    _saveActionState(true);
  }

  bool _isPickupDateToday() {
    final pickupDate = _currentShipment.requestedPickupAt;
    final now = DateTime.now();
    return pickupDate.year == now.year &&
        pickupDate.month == now.month &&
        pickupDate.day == now.day;
  }

  void _startInspection() {
    setState(() {
      showInspectionActions = true;
    });
  }

  int _getProgressSteps() {
    switch (_currentShipment.status) {
      case 'approved':
        return 1;
      case 'pending_admin_review':
        return 2;
      case 'routed':
        return 3;
      case 'delivery_in_transit':
        return 4;
      case 'complete_weighted':
        return 5;
      case 'delivered':
        return 6;
      default:
        return 0;
    }
  }

  Widget _buildShipmentButtons() {
    final status = _currentShipment.status;

    if (status == 'approved' && !hasActionBeenTaken) {
      if (!showInspectionActions) {
        return CustomButton(onPress: _startInspection, title: 'بدأ المعاينة');
      }
      return RepresentativeShipmentActionsRow(
        shipment: _currentShipment,
        onActionTaken: _markActionAsTaken,
      );
    }

    const reviewStatuses = [
      'routed',
      'delivery_in_transit',
      'delivered',
      'partially_delivered',
      'complete_weighted',
    ];

    if (reviewStatuses.contains(status)) {
      return CustomButton(
        onPress: _isNavigating ? null : _navigateToReview,
        title: 'مراجعة الشحنة',
      );
    }

    return const SizedBox.shrink();
  }

  // ✅ OPTIMIZED: Cleaner navigation with proper error handling
  Future<void> _navigateToReview() async {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    try {
      final updatedShipment = await Navigator.push<SingleShipmentModel>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RepresentativeShipmentReviewView(shipment: _currentShipment),
        ),
      );

      if (!mounted) return;

      if (updatedShipment != null) {
        setState(() {
          _currentShipment = updatedShipment;
        });
      }
    } catch (error) {
      // ✅ Handle any navigation errors
      debugPrint('Navigation error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(gradient: kGradientBackground),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
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
                        color: Colors.black.withOpacity(0.2),
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
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
                            child: Column(
                              children: [
                                ProgressBar(
                                  completedSteps: _getProgressSteps(),
                                  totalSteps: 6,
                                  color: (_currentShipment.status == "rejected")
                                      ? AppColors.failureColor
                                      : const Color(0xFF4CAF50),
                                ),
                                const SizedBox(height: 12),
                                RepresentativeShipmentDetailsHeader(
                                  shipment: _currentShipment,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                ExpandableCard(
                                  title: 'تفاصيل الشحنة',
                                  icon: AppAssets.boxPerspective,
                                  isExpanded: isShipmentDetailsExpanded,
                                  onTap: _toggleShipmentDetails,
                                  content: RepresentativeShipmentDetailsContent(
                                    items: _currentShipment.items,
                                  ),
                                  maxHeight: 320,
                                ),
                                const SizedBox(height: 16),
                                if (_currentShipment.inspectedItems.isNotEmpty)
                                  Column(
                                    children: [
                                      ExpandableCard(
                                        title: 'الشحنة بعد المعاينة',
                                        icon: AppAssets.boxPerspective,
                                        isExpanded: isInspectedItemsExpanded,
                                        onTap: _toggleInspectedItems,
                                        content:
                                            RepresentativeShipmentDetailsContent(
                                              items: _currentShipment
                                                  .inspectedItems,
                                            ),
                                        maxHeight: 320,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),

                                if (_currentShipment.status ==
                                        "complete_weighted" &&
                                    _currentShipment.financeSnapshot!.method ==
                                        'cash')
                                  Column(
                                    children: [
                                      (_currentShipment.financeSnapshot!.type !=
                                              'meal')
                                          ? ExpandableCard(
                                              title: 'تحصيل النقدية',
                                              icon: AppAssets.boxPerspective,
                                              isExpanded:
                                                  isCashCollectionExpanded,
                                              onTap: _toggleCachCollection,
                                              content: CashCollectionSection(
                                                onConfirm: (selected, receipt) {
                                                  final total = selected.fold(
                                                    0.0,
                                                    (s, e) => s + e.amount,
                                                  );
                                                },
                                              ),
                                              maxHeight: 320,
                                            )
                                          : (_currentShipment
                                                    .financeSnapshot!
                                                    .type ==
                                                'meal')
                                          ? ExpandableCard(
                                              title: 'تحصيل النقدية',
                                              icon: AppAssets.boxPerspective,
                                              isExpanded:
                                                  isCashCollectionExpanded,
                                              onTap: _toggleCachCollection,
                                              content:
                                                  CashCollectionSimpleSection(
                                                    totalAmount:
                                                        _currentShipment
                                                            .financeSnapshot!
                                                            .amount,
                                                    onConfirm: (receiptFile) {},
                                                  ),
                                              maxHeight: 320,
                                            )
                                          : const SizedBox.shrink(),

                                      const SizedBox(height: 25),
                                    ],
                                  ),

                                ExpandableCard(
                                  title: 'بيانات جهة التعامل',
                                  icon: AppAssets.entityCard,
                                  isExpanded: isClientDataExpanded,
                                  onTap: _toggleClientData,
                                  content: ClientDataContent(
                                    trader: _currentShipment.trader,
                                  ),
                                  maxHeight: 320,
                                ),
                                const SizedBox(height: 20),
                                (_currentShipment.customPickupAddress != null)
                                    ? _buildAddressSection()
                                    : _buildBranchSection(),
                                const SizedBox(height: 20),
                                ExpandableCard(
                                  title: 'ملاحظات من التاجر / الاداره',
                                  icon: AppAssets.entityCard,
                                  isExpanded: isNotesDataExpanded,
                                  onTap: _toggleNotesData,
                                  content: RepresentativeShipmentNotesContent(
                                    notes: _currentShipment.mainNotes,
                                  ),
                                  maxHeight: 200,
                                ),
                                const SizedBox(height: 20),
                                _buildNotesCard(),
                                const SizedBox(height: 25),
                                _buildShipmentButtons(),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
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
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: const ShipmentLogo(),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: "العنوان",
                  hint: _currentShipment.customPickupAddress,
                  keyboardType: TextInputType.text,
                  icon: Icons.location_on_rounded,
                  isArabic: true,
                  enabled: false,
                  borderColor: Colors.green.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.subTextColor),
              const SizedBox(width: 4),
              Text(
                "سيتم استلام الشحنة من هذا العنوان",
                style: AppStyles.styleSemiBold12(
                  context,
                ).copyWith(color: AppColors.subTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBranchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.store_rounded,
                  color: Colors.green.shade500,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'الفرع',
                style: AppStyles.styleSemiBold16(
                  context,
                ).copyWith(color: AppColors.mainTextColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green.shade500,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentShipment.branch?.branchName ?? '',
                        style: AppStyles.styleSemiBold14(
                          context,
                        ).copyWith(color: Colors.grey.shade800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentShipment.branch?.address ?? '',
                        style: AppStyles.styleSemiBold14(
                          context,
                        ).copyWith(color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: RepresentativeShipmentDetailsNotes(shipment: _currentShipment),
    );
  }

  void _toggleShipmentDetails() {
    setState(() {
      isShipmentDetailsExpanded = !isShipmentDetailsExpanded;
    });
  }

  void _toggleInspectedItems() {
    setState(() {
      isInspectedItemsExpanded = !isInspectedItemsExpanded;
    });
  }

  void _toggleClientData() {
    setState(() {
      isClientDataExpanded = !isClientDataExpanded;
    });
  }

  void _toggleNotesData() {
    setState(() {
      isNotesDataExpanded = !isNotesDataExpanded;
    });
  }

  void _toggleCachCollection() {
    setState(() {
      isCashCollectionExpanded = !isCashCollectionExpanded;
    });
  }
}
