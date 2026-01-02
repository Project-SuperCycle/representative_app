import 'package:flutter/material.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/helpers/custom_dropdown.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/models/trader_branch_model.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/widgets/custom_button.dart';
import 'package:supercycle/core/widgets/shipment/client_data_content.dart';
import 'package:supercycle/core/widgets/shipment/expandable_section.dart';
import 'package:supercycle/core/widgets/shipment/shipment_logo.dart';
import 'package:supercycle/core/widgets/shipment/notes_content.dart';
import 'package:supercycle/core/widgets/shipment/progress_widgets.dart';
import 'package:supercycle/core/widgets/custom_text_field.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';
import 'package:supercycle/features/sales_process/data/models/create_shipment_model.dart';
import 'package:supercycle/features/sales_process/presentation/widgets/entry_shipment_details_cotent.dart';
import 'package:supercycle/features/sales_process/presentation/widgets/sales_process_shipment_header.dart';
import 'package:supercycle/features/sales_process/presentation/widgets/shipment_review_dialog.dart';
import 'package:supercycle/generated/l10n.dart';
import 'dart:io';

class SalesProcessViewBody extends StatefulWidget {
  const SalesProcessViewBody({super.key});

  @override
  State<SalesProcessViewBody> createState() => _SalesProcessViewBodyState();
}

class _SalesProcessViewBodyState extends State<SalesProcessViewBody> {
  bool isClientDataExpanded = false;
  bool isShipmentDetailsExpanded = false;
  List<String> notes = [];
  List<DoshItemModel> products = [];
  List<File> selectedImages = [];
  DateTime? selectedDateTime;
  String userAddress = "";
  String userRole = "";
  TextEditingController addressController = TextEditingController();
  List<TraderBranchModel> branchs = [];

  // Variables للـ branch المختار
  String? selectedBranchId;
  String? selectedBranchName;

  @override
  void initState() {
    super.initState();
    _getUserAddress();
    _getUserBranchs();
  }

  void _getUserBranchs() async {
    final storedBranchs = await StorageServices.getUserBranchs();
    setState(() {
      branchs = storedBranchs;
    });
  }

  void _getUserAddress() async {
    var user = await StorageServices.getUserData();
    if (user == null) {
      return;
    }
    setState(() {
      userAddress = user.bussinessAdress ?? "";
      userRole = user.role ?? "";
      addressController.text = userAddress;
    });
  }

  void _onImagesChanged(List<File> images) {
    setState(() {
      selectedImages = images;
    });
  }

  void _onDateTimeChanged(DateTime? dateTime) {
    setState(() {
      selectedDateTime = dateTime;
    });
  }

  void _onNotesChanged(List<String> notes) {
    setState(() {
      this.notes = notes;
    });
  }

  void _onProductsChanged(List<DoshItemModel> products) {
    setState(() {
      this.products = products;
    });
  }

  // Function لما يختار branch
  void _onBranchChanged(String? branchName) {
    if (branchName == null) return;

    // البحث عن الـ branch المختار في الـ list
    final selectedBranch = branchs.firstWhere(
      (branch) => branch.branchName == branchName,
      orElse: () => branchs.first,
    );

    setState(() {
      selectedBranchName = selectedBranch.branchName;
      selectedBranchId = selectedBranch.branchId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 50),
        decoration: const BoxDecoration(gradient: kGradientBackground),
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
                        // Progress Bar
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
                          child: const ProgressBar(completedSteps: 0),
                        ),

                        // المحتوى الرئيسي
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),

                              // قسم الصور والتاريخ
                              _buildImageAndDateSection(),

                              const SizedBox(height: 20),

                              // بياناتي
                              _buildExpandableCard(
                                title: 'بياناتي',
                                icon: AppAssets.entityCard,
                                isExpanded: isClientDataExpanded,
                                onTap: _toggleClientData,
                                content: const ClientDataContent(),
                                maxHeight: 320,
                              ),

                              const SizedBox(height: 16),

                              // تفاصيل الشحنة
                              _buildExpandableCard(
                                title: 'تفاصيل الشحنة',
                                icon: AppAssets.boxPerspective,
                                isExpanded: isShipmentDetailsExpanded,
                                onTap: _toggleShipmentDetails,
                                content: EntryShipmentDetailsContent(
                                  products: products,
                                  onProductsChanged: _onProductsChanged,
                                ),
                                maxHeight: 320,
                              ),

                              const SizedBox(height: 20),

                              // عنوان الاستلام
                              (userRole == "trader_contracted")
                                  ? _buildBranchSection()
                                  : _buildAddressSection(),

                              const SizedBox(height: 20),

                              // الملاحظات
                              _buildNotesCard(),

                              const SizedBox(height: 25),

                              // زر المراجعة
                              CustomButton(
                                onPress: _handleSubmit,
                                title: S.of(context).shipment_review,
                              ),

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
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: const ShipmentLogo(),
    );
  }

  Widget _buildImageAndDateSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: SalesProcessShipmentHeader(
        selectedImages: selectedImages,
        onImagesChanged: _onImagesChanged,
        onDateTimeChanged: _onDateTimeChanged,
      ),
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
                  hint: "عنوان الاستلام",
                  controller: addressController,
                  keyboardType: TextInputType.text,
                  icon: Icons.location_on_rounded,
                  isArabic: true,
                  enabled: true,
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

  // Widget جديد لقسم اختيار الفرع
  Widget _buildBranchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withAlpha(150),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.store_rounded,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text("اختر الفرع", style: AppStyles.styleSemiBold16(context)),
            ],
          ),
          const SizedBox(height: 12),
          CustomDropdown(
            options: branchs.map((branch) => branch.branchName).toList(),
            initialValue: selectedBranchName,
            hintText: "اختر الفرع",
            onChanged: _onBranchChanged,
            width: MediaQuery.of(context).size.width,
            maxHeight: 250,
            isSearchable: branchs.length > 5, // لو الأفرع أكتر من 5 يفعل البحث
            showBorder: true,
          ),
          if (selectedBranchName != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  "تم اختيار: $selectedBranchName",
                  style: AppStyles.styleSemiBold12(
                    context,
                  ).copyWith(color: Colors.green.shade700),
                ),
              ],
            ),
          ],
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
      child: NotesContent(
        notes: notes,
        shipmentID: "",
        onNotesChanged: _onNotesChanged,
      ),
    );
  }

  void _toggleClientData() {
    setState(() {
      isClientDataExpanded = !isClientDataExpanded;
    });
  }

  void _toggleShipmentDetails() {
    setState(() {
      isShipmentDetailsExpanded = !isShipmentDetailsExpanded;
    });
  }

  // في الـ _handleSubmit method
  Future<void> _handleSubmit() async {
    try {
      CreateShipmentModel shipment = CreateShipmentModel(
        customPickupAddress: _handleAddress(),
        requestedPickupAt: selectedDateTime,
        images: selectedImages,
        items: products,
        userNotes: notes.isEmpty ? "" : notes.first,
        selectedBranchId: selectedBranchId,
        selectedBranchName: selectedBranchName, // إضافة البيانات هنا
      );

      String? validationError = _getValidationError(shipment);

      if (validationError != null) {
        CustomSnackBar.showError(context, validationError);

        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ShipmentReviewDialog(
          shipment: shipment,
          onConfirm: () {
            CustomSnackBar.showSuccess(context, 'تم تأكيد الشحنة بنجاح');
          },
          onUpdate: (updatedShipment) {
            setState(() {
              selectedDateTime = updatedShipment.requestedPickupAt;
              addressController.text = updatedShipment.customPickupAddress;
              products = updatedShipment.items;
              selectedImages = updatedShipment.images;
              notes = [updatedShipment.userNotes];
              selectedBranchId = selectedBranchId;
              selectedBranchName = selectedBranchName;
            });

            CustomSnackBar.showSuccess(context, 'تم حفظ التعديلات بنجاح');
          },
        ),
      );
    } catch (e) {
      CustomSnackBar.showSuccess(context, 'حدث خطأ: ${e.toString()}');
    }
  }

  // تعديل الـ validation
  String? _getValidationError(CreateShipmentModel shipment) {
    if (shipment.requestedPickupAt == null || selectedDateTime == null) {
      return "يرجى تحديد تاريخ الاستلام";
    }

    if (shipment.customPickupAddress.isEmpty) {
      return "يرجى إدخال عنوان الاستلام";
    }

    // التحقق من الفرع فقط للـ trader_contracted
    if (userRole == "trader_contracted") {
      if (shipment.selectedBranchId == null ||
          shipment.selectedBranchId == null) {
        return "يرجى اختيار الفرع";
      }
    }

    if (shipment.items.isEmpty) {
      return "يرجى إضافة منتجات للشحنة";
    }

    if (shipment.items.isNotEmpty) {
      for (int i = 0; i < shipment.items.length; i++) {
        var item = shipment.items[i];
        if (item.quantity <= 0) {
          return "يرجى إدخال الكمية للمنتج رقم ${i + 1}";
        }
      }
    }

    if (shipment.images.isEmpty) {
      return "يرجى إضافة صور للشحنة";
    }

    return null;
  }

  String _handleAddress() {
    return (addressController.text.isNotEmpty)
        ? addressController.text
        : userAddress;
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }
}
