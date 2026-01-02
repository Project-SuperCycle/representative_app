import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/widgets/custom_button.dart';
import 'package:supercycle/core/widgets/custom_text_field.dart';
import 'package:supercycle/core/widgets/navbar/custom_curved_navigation_bar.dart';
import 'package:supercycle/core/widgets/shipment/client_data_content.dart';
import 'package:supercycle/core/widgets/shipment/expandable_section.dart';
import 'package:supercycle/core/widgets/shipment/progress_widgets.dart';
import 'package:supercycle/core/widgets/shipment/shipment_logo.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_details/presentation/widgets/representative_shipment_actions_row.dart';
import 'package:supercycle/features/representative_shipment_details/presentation/widgets/representative_shipment_details_content.dart';
import 'package:supercycle/features/representative_shipment_details/presentation/widgets/representative_shipment_details_header.dart';
import 'package:supercycle/features/representative_shipment_details/presentation/widgets/representative_shipment_details_notes.dart';
import 'package:supercycle/features/representative_shipment_details/presentation/widgets/representative_shipment_notes_content.dart';
import 'package:supercycle/features/representative_shipment_details/presentation/widgets/representative_shipment_review_button.dart';

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
  bool isShipmentDetailsExpanded = false;
  bool isInspectedItemsExpanded = false;
  bool isClientDataExpanded = false;
  bool isNotesDataExpanded = false;
  bool hasActionBeenTaken = false;
  bool showInspectionActions = false;
  int _page = 3;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String get _actionTakenKey => 'shipment_${widget.shipment.id}_action_taken';

  @override
  void initState() {
    super.initState();
    _loadActionState();
  }

  Future<void> _loadActionState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hasActionBeenTaken = prefs.getBool(_actionTakenKey) ?? false;
    });
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

  void _onNavigationTap(int index) {
    setState(() {
      _page = index;
    });
  }

  bool _isPickupDateToday() {
    final pickupDate = widget.shipment.requestedPickupAt;
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
              // Header Section - ثابت في الأعلى
              _buildHeader(),
              // المحتوى القابل للتمرير
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
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Header & Progress Bar
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
                            child: Column(
                              children: [
                                ProgressBar(
                                  completedSteps: _getProgressSteps(),
                                  totalSteps: 6,
                                ),
                                const SizedBox(height: 12),
                                RepresentativeShipmentDetailsHeader(
                                  shipment: widget.shipment,
                                ),
                              ],
                            ),
                          ),
                          // المحتوى الرئيسي
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                // تفاصيل الشحنة
                                _buildExpandableCard(
                                  title: 'تفاصيل الشحنة',
                                  icon: AppAssets.boxPerspective,
                                  isExpanded: isShipmentDetailsExpanded,
                                  onTap: _toggleShipmentDetails,
                                  content: RepresentativeShipmentDetailsContent(
                                    items: widget.shipment.items,
                                  ),
                                  maxHeight: 320,
                                ),
                                const SizedBox(height: 16),
                                // الشحنة بعد المعاينة
                                if (widget.shipment.inspectedItems.isNotEmpty)
                                  Column(
                                    children: [
                                      _buildExpandableCard(
                                        title: 'الشحنة بعد المعاينة',
                                        icon: AppAssets.boxPerspective,
                                        isExpanded: isInspectedItemsExpanded,
                                        onTap: _toggleInspectedItems,
                                        content:
                                            RepresentativeShipmentDetailsContent(
                                              items: widget
                                                  .shipment
                                                  .inspectedItems,
                                            ),
                                        maxHeight: 320,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                // بيانات جهة التعامل
                                _buildExpandableCard(
                                  title: 'بيانات جهة التعامل',
                                  icon: AppAssets.entityCard,
                                  isExpanded: isClientDataExpanded,
                                  onTap: _toggleClientData,
                                  content: ClientDataContent(
                                    trader: widget.shipment.trader,
                                  ),
                                  maxHeight: 320,
                                ),
                                const SizedBox(height: 20),
                                // عنوان الاستلام
                                (widget.shipment.customPickupAddress != null)
                                    ? _buildAddressSection()
                                    : _buildBranchSection(),

                                const SizedBox(height: 20),
                                // ملاحظات من التاجر / الاداره
                                _buildExpandableCard(
                                  title: 'ملاحظات من التاجر / الاداره',
                                  icon: AppAssets.entityCard,
                                  isExpanded: isNotesDataExpanded,
                                  onTap: _toggleNotesData,
                                  content: RepresentativeShipmentNotesContent(
                                    notes: widget.shipment.mainNotes,
                                  ),
                                  maxHeight: 200,
                                ),
                                const SizedBox(height: 20),
                                // ملاحظات المندوب
                                _buildNotesCard(),
                                const SizedBox(height: 25),
                                // الأزرار
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
      bottomNavigationBar: CustomCurvedNavigationBar(
        currentIndex: _page,
        navigationKey: _bottomNavigationKey,
        onTap: _onNavigationTap,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: const ShipmentLogo(),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required String icon,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget content,
    required double maxHeight,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? Colors.green.shade200 : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? Colors.green.withAlpha(50)
                : Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpandableSection(
        title: title,
        iconPath: icon,
        isExpanded: isExpanded,
        maxHeight: maxHeight,
        onTap: onTap,
        content: content,
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50.withAlpha(150),
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
                  hint: widget.shipment.customPickupAddress,
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
        color: Colors.green.shade50.withAlpha(150),
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
                        widget.shipment.branch?.branchName ?? '',
                        style: AppStyles.styleSemiBold14(
                          context,
                        ).copyWith(color: Colors.grey.shade800),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.shipment.branch?.address ?? '',
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
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: RepresentativeShipmentDetailsNotes(shipment: widget.shipment),
    );
  }

  int _getProgressSteps() {
    switch (widget.shipment.status) {
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

  /// بناء الأزرار حسب الحالة
  Widget _buildShipmentButtons() {
    final status = widget.shipment.status;

    // إذا الحالة 'approved' ولم يتم اتخاذ إجراء واليوم هو تاريخ الاستلام
    if (status == 'approved' && !hasActionBeenTaken) {
      // إذا لم يتم الضغط على زر "بدأ المعاينة"، اعرض الزر
      if (!showInspectionActions) {
        return CustomButton(onPress: _startInspection, title: 'بدأ المعاينة');
      }
      // إذا تم الضغط على زر "بدأ المعاينة"، اعرض أزرار الإجراءات
      return RepresentativeShipmentActionsRow(
        shipment: widget.shipment,
        onActionTaken: _markActionAsTaken,
      );
    }

    // في الحالات الأخرى (routed, delivery_in_transit, delivered, إلخ)، اعرض زر "مراجعة الشحنة"
    const reviewStatuses = [
      'routed',
      'delivery_in_transit',
      'delivered',
      'partially_delivered',
      'complete_weighted',
    ];
    if (reviewStatuses.contains(status)) {
      return RepresentativeShipmentReviewButton(shipment: widget.shipment);
    }

    return const SizedBox.shrink();
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
}
