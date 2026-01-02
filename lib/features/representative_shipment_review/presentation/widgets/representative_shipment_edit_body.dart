import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/widgets/custom_button.dart';
import 'package:supercycle/core/widgets/shipment/client_data_content.dart';
import 'package:supercycle/core/helpers/custom_back_button.dart';
import 'package:supercycle/core/widgets/shipment/expandable_section.dart';
import 'package:supercycle/core/widgets/shipment/shipment_logo.dart';
import 'package:supercycle/core/widgets/shipment/progress_widgets.dart';
import 'package:supercycle/core/widgets/custom_text_field.dart';
import 'package:supercycle/features/representative_shipment_details/data/cubits/update_shipment_cubit/update_shipment_cubit.dart';
import 'package:supercycle/features/representative_shipment_details/data/cubits/update_shipment_cubit/update_shipment_state.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/update_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_details/presentation/widgets/representative_shipment_notes_content.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';
import 'package:supercycle/features/sales_process/presentation/widgets/entry_shipment_details_cotent.dart';
import 'package:supercycle/core/widgets/shipment/shipment_details_notes.dart';
import 'package:supercycle/features/shipment_edit/presentation/widgets/shipment_edit_header.dart';
import 'package:supercycle/generated/l10n.dart';
import 'dart:io';

class RepresentativeShipmentEditBody extends StatefulWidget {
  final SingleShipmentModel shipment;
  const RepresentativeShipmentEditBody({super.key, required this.shipment});

  @override
  State<RepresentativeShipmentEditBody> createState() =>
      _RepresentativeShipmentEditBodyState();
}

class _RepresentativeShipmentEditBodyState
    extends State<RepresentativeShipmentEditBody> {
  bool isClientDataExpanded = false;
  bool isShipmentDetailsExpanded = false;
  bool isNotesDataExpanded = false;
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

  void _toggleNotesData() {
    setState(() {
      isNotesDataExpanded = !isNotesDataExpanded;
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
                          showDateIcon: false,
                        ),
                        const SizedBox(height: 20),
                        const ProgressBar(completedSteps: 0),
                        const SizedBox(height: 30),
                        Column(
                          children: [
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
                          ],
                        ),

                        Column(
                          children: [
                            Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ExpandableSection(
                                title: 'بيانات جهة التعامل',
                                iconPath: AppAssets.entityCard,
                                isExpanded: isClientDataExpanded,
                                maxHeight: 320,
                                onTap: _toggleClientData,
                                content: const ClientDataContent(),
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
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
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ExpandableSection(
                            title: 'ملاحظات من التاجر / الاداره',
                            iconPath: AppAssets.entityCard,
                            isExpanded: isNotesDataExpanded,
                            maxHeight: 200,
                            onTap: _toggleNotesData,
                            content: RepresentativeShipmentNotesContent(
                              notes: widget.shipment.mainNotes,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        ShipmentDetailsNotes(
                          notes: widget.shipment.mainNotes,
                          shipmentID: widget.shipment.id,
                        ),
                        const SizedBox(height: 30),
                        BlocConsumer<UpdateShipmentCubit, UpdateShipmentState>(
                          listener: (context, state) {
                            // TODO: implement listener
                            if (state is UpdateRepShipmentFailure) {
                              CustomSnackBar.showError(
                                context,
                                state.errorMessage,
                              );
                            }
                            if (state is UpdateRepShipmentSuccess) {
                              GoRouter.of(context).pushReplacement(
                                EndPoints.shipmentsCalendarView,
                              );
                            }
                          },
                          builder: (context, state) {
                            return CustomButton(
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

  void _confirmProcess() async {
    UpdateShipmentModel updateShipmentModel = UpdateShipmentModel(
      shipmentID: widget.shipment.id,
      rank: 4.0,
      images: selectedImages,
      updatedItems: products.isEmpty ? widget.shipment.items : products,
      notes: notes.isEmpty ? widget.shipment.userNotes : notes.first,
    );

    BlocProvider.of<UpdateShipmentCubit>(
      context,
    ).updateShipmet(updateModel: updateShipmentModel);
  }
}
