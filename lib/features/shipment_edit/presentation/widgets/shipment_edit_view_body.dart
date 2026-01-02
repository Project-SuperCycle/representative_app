import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/functions/shipment_manager.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/widgets/custom_button.dart';
import 'package:supercycle/core/helpers/custom_back_button.dart';
import 'package:supercycle/core/widgets/shipment/expandable_section.dart';
import 'package:supercycle/core/widgets/shipment/shipment_logo.dart';
import 'package:supercycle/core/widgets/shipment/progress_widgets.dart';
import 'package:supercycle/core/widgets/custom_text_field.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';
import 'package:supercycle/features/sales_process/presentation/widgets/entry_shipment_details_cotent.dart';
import 'package:supercycle/core/widgets/shipment/shipment_details_notes.dart';
import 'package:supercycle/features/shipment_edit/data/cubits/shipment_edit_cubit.dart';
import 'package:supercycle/features/shipment_edit/data/models/edit_shipment_model.dart';
import 'package:supercycle/features/shipment_edit/presentation/widgets/shipment_edit_header.dart';
import 'package:supercycle/generated/l10n.dart';
import 'dart:io';

class ShipmentEditViewBody extends StatefulWidget {
  final SingleShipmentModel shipment;
  const ShipmentEditViewBody({super.key, required this.shipment});

  @override
  State<ShipmentEditViewBody> createState() => _ShipmentEditViewBodyState();
}

class _ShipmentEditViewBodyState extends State<ShipmentEditViewBody> {
  bool isClientDataExpanded = false;
  bool isShipmentDetailsExpanded = false;
  List<String> notes = [];
  List<DoshItemModel> products = [];
  List<File> selectedImages = [];
  DateTime? selectedDateTime;
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getShipmentAddress();
    setState(() {
      products = widget.shipment.items;
      selectedDateTime = widget.shipment.requestedPickupAt;
    });
  }

  void _getShipmentAddress() async {
    addressController.text = widget.shipment.customPickupAddress ?? '';
  }

  // Callback functions for shipment data
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

  void _onProductsChanged(List<DoshItemModel> products) {
    setState(() {
      this.products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(gradient: kGradientBackground),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header Section (Fixed)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const ShipmentLogo(),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            textDirection: TextDirection.ltr,
                            Icons.info_outline,
                            size: 25,
                            color: Colors.white,
                          ),
                          CustomBackButton(color: Colors.white, size: 25),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // White Container Content (Scrollable)
              SliverFillRemaining(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // تمرير قائمة الصور ودالة التحديث للـ Header
                        ShipmentEditHeader(
                          shipment: widget.shipment,
                          selectedImages: selectedImages,
                          onImagesChanged: _onImagesChanged,
                          onDateTimeChanged: _onDateTimeChanged,
                        ),
                        const SizedBox(height: 20),
                        const ProgressBar(completedSteps: 0),
                        const SizedBox(height: 30),
                        // Column(
                        //   children: [
                        //     Container(
                        //       clipBehavior: Clip.antiAliasWithSaveLayer,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //       child: ExpandableSection(
                        //         title: 'بيانات جهة التعامل',
                        //         iconPath: AppAssets.entityCard,
                        //         isExpanded: isClientDataExpanded,
                        //         maxHeight: 320,
                        //         onTap: _toggleClientData,
                        //         content: const ClientDataContent(),
                        //       ),
                        //     ),
                        //     const SizedBox(height: 25),
                        //   ],
                        // ),
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ExpandableSection(
                            title: 'تفاصيل الشحنة',
                            iconPath: AppAssets.boxPerspective,
                            isExpanded: isShipmentDetailsExpanded,
                            maxHeight: 320,
                            onTap: _toggleShipmentDetails,
                            content: EntryShipmentDetailsContent(
                              products: products,
                              onProductsChanged: _onProductsChanged,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomTextField(
                              label: "العنوان",
                              hint: "عنوان الاستلام",
                              controller: addressController,
                              keyboardType: TextInputType.text,
                              icon: Icons.location_on_rounded,
                              isArabic: true,
                              enabled: true,
                              borderColor: Colors.green.shade300,
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Text(
                                "سيتم استلام الشحنة منه",
                                style: AppStyles.styleSemiBold12(
                                  context,
                                ).copyWith(color: AppColors.subTextColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        ShipmentDetailsNotes(
                          notes: widget.shipment.mainNotes,
                          shipmentID: widget.shipment.id,
                        ),
                        const SizedBox(height: 30),
                        BlocConsumer<ShipmentEditCubit, ShipmentEditState>(
                          listener: (context, state) {
                            // TODO: implement listener
                            if (state is EditShipmentSuccess) {
                              GoRouter.of(context).pushReplacement(
                                EndPoints.shipmentsCalendarView,
                              );
                            }

                            if (state is EditShipmentFailure) {
                              CustomSnackBar.showError(
                                context,
                                state.errorMessage,
                              );
                            }
                          },
                          builder: (context, state) {
                            return (state is EditShipmentLoading)
                                ? Center(
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CustomLoadingIndicator(),
                                    ),
                                  )
                                : CustomButton(
                                    onPress: () {
                                      _confirmProcess();
                                    },
                                    title: S.of(context).shipment_edit,
                                  );
                          },
                        ),
                        // مساحة إضافية في النهاية
                        const SizedBox(height: 40),
                      ],
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

  void _toggleShipmentDetails() {
    setState(() {
      isShipmentDetailsExpanded = !isShipmentDetailsExpanded;
    });
  }

  void _confirmProcess() async {
    EditShipmentModel shipment = EditShipmentModel(
      customPickupAddress: addressController.text.isEmpty
          ? widget.shipment.customPickupAddress ?? ""
          : addressController.text,
      requestedPickupAt: selectedDateTime ?? widget.shipment.requestedPickupAt,
      images: selectedImages,
      items: products.isEmpty ? widget.shipment.items : products,
      userNotes: notes.isEmpty ? widget.shipment.userNotes : notes.first,
    );

    FormData updatedShipment = await _createFormData(shipment);

    BlocProvider.of<ShipmentEditCubit>(
      context,
    ).editShipment(shipment: updatedShipment, id: widget.shipment.id);
  }

  Future<FormData> _createFormData(EditShipmentModel shipment) async {
    List<File> images = widget.shipment.images;
    List<MultipartFile> imagesFiles =
        await ShipmentManager.createMultipartImages(images: images);

    // Create FormData
    final formData = FormData.fromMap({
      ...shipment.toMap(),
      'uploadedImages': imagesFiles, // Add the converted MultipartFiles
    });
    return formData;
  }
}
