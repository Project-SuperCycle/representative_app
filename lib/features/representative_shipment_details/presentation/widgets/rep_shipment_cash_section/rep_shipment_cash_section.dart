import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:representative_app/core/helpers/custom_loading_indicator.dart';
import 'package:representative_app/core/helpers/custom_snack_bar.dart';
import 'package:representative_app/core/utils/app_colors.dart';
import 'package:representative_app/features/representative_shipment_details/data/cubits/confirm_cash/confirm_cash_cubit.dart';
import 'package:representative_app/features/representative_shipment_details/data/cubits/confirm_cash/confirm_cash_state.dart';
import 'package:representative_app/features/representative_shipment_details/data/cubits/get_meal_shipments/get_meal_shipments_cubit.dart';
import 'package:representative_app/features/representative_shipment_details/data/cubits/get_meal_shipments/get_meal_shipments_state.dart';
import 'package:representative_app/features/representative_shipment_details/data/models/shipment_cash_item.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/rep_shipment_cash_section/confirm_button.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/rep_shipment_cash_section/shipment_tile.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/rep_shipment_cash_section/shipment_tile_loading.dart';
import 'package:representative_app/features/representative_shipment_details/presentation/widgets/rep_shipment_cash_section/total_row.dart';

class CashCollectionSection extends StatefulWidget {
  final void Function(List<ShipmentCashItem> selected, File? receipt)?
  onConfirm;

  const CashCollectionSection({super.key, this.onConfirm});

  @override
  State<CashCollectionSection> createState() => _CashCollectionSectionState();
}

class _CashCollectionSectionState extends State<CashCollectionSection>
    with SingleTickerProviderStateMixin {
  File? _receiptImage;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  static const _green = Color(0xFF2DBD6A);
  static const _greenLight = Color(0xFFE8F9F0);
  static const _greenBorder = Color(0xFF2DBD6A);
  static const _textDark = Color(0xFF1A1A2E);
  static const _textGrey = Color(0xFF9E9E9E);
  static const _white = Colors.white;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  List<ShipmentCashItem> get _currentShipments {
    final state = context.read<GetMealShipmentsCubit>().state;
    if (state is GetMealShipmentsSuccess) return state.shipments;
    return [];
  }

  double get _totalSelected => _currentShipments
      .where((s) => s.isSelected)
      .fold(0.0, (sum, s) => sum + s.amount);

  bool get _hasSelection => _currentShipments.any((s) => s.isSelected);

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() => _receiptImage = File(picked.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _sheetOption(
                icon: Icons.camera_alt_rounded,
                label: 'التقاط صورة',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
              _sheetOption(
                icon: Icons.photo_library_rounded,
                label: 'اختيار من المعرض',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: _greenLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _greenBorder.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: _green, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShipmentsList(),
          Divider(
            height: 1,
            color: AppColors.primaryColor.withValues(alpha: 0.25),
            indent: 30,
            endIndent: 30,
          ),
          TotalRow(hasSelection: _hasSelection, totalSelected: _totalSelected),
          Divider(
            height: 1,
            color: AppColors.primaryColor.withValues(alpha: 0.25),
            indent: 30,
            endIndent: 30,
          ),
          _buildReceiptUpload(),
          BlocConsumer<ConfirmCashCubit, ConfirmCashState>(
            listener: (context, state) {
              if (state is ConfirmCashFailure) {
                CustomSnackBar.showError(context, state.errorMessage);
              }

              if (state is ConfirmCashSuccess) {
                CustomSnackBar.showInfo(context, 'تم تأكيد الدفع');
              }
            },
            builder: (context, state) {
              if (state is ConfirmCashLoading) {
                Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CustomLoadingIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }
              return ConfirmButton(
                pulseController: _pulseController,
                pulseAnim: _pulseAnim,
                enabled: _hasSelection,
                shipments: _currentShipments,
                receiptImage: _receiptImage,
                totalSelected: _totalSelected,
                onConfirm: widget.onConfirm,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentsList() {
    return BlocConsumer<GetMealShipmentsCubit, GetMealShipmentsState>(
      listener: (context, state) {
        if (state is GetMealShipmentsFailure) {
          CustomSnackBar.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is GetMealShipmentsLoading) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: 4,
            itemBuilder: (_, __) => const ShipmentTileLoading(),
          );
        }

        if (state is GetMealShipmentsSuccess) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: state.shipments.length,
            itemBuilder: (_, index) {
              final item = state.shipments[index];
              return ShipmentTile(
                item: item,
                green: _green,
                greenLight: _greenLight,
                onChanged: (val) =>
                    setState(() => item.isSelected = val ?? false),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildReceiptUpload() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 4),
            child: Row(
              children: [
                Icon(Icons.receipt_long_rounded, color: _green, size: 16),
                const SizedBox(width: 6),
                const Text(
                  'وصل التحصيل',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(اختياري)',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: _textGrey,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _showImageSourceSheet,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _receiptImage != null ? 140 : 72,
              decoration: BoxDecoration(
                color: _receiptImage != null ? Colors.transparent : _greenLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _greenBorder.withValues(alpha: 0.5),
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: _receiptImage != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(_receiptImage!, fit: BoxFit.cover),
                        Positioned(
                          top: 6,
                          left: 6,
                          child: GestureDetector(
                            onTap: () => setState(() => _receiptImage = null),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            color: Colors.black38,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'تغيير الصورة',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_rounded,
                          color: _green,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'رفع وصل التحصيل',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _green,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
