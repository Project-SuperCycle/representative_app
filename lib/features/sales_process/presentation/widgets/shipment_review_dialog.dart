import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/functions/shipment_manager.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/services/dosh_types_manager.dart';
import 'package:supercycle/core/services/services_locator.dart';
import 'package:supercycle/features/sales_process/data/cubit/create_shipment_cubit/create_shipment_cubit.dart';
import 'package:supercycle/features/sales_process/data/models/create_shipment_model.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';

class ShipmentReviewDialog extends StatefulWidget {
  final CreateShipmentModel shipment;
  final VoidCallback? onConfirm;
  final Function(CreateShipmentModel)? onUpdate;

  const ShipmentReviewDialog({
    super.key,
    required this.shipment,
    this.onConfirm,
    this.onUpdate,
  });

  @override
  State<ShipmentReviewDialog> createState() => _ShipmentReviewDialogState();
}

class _ShipmentReviewDialogState extends State<ShipmentReviewDialog> {
  late TextEditingController addressController;
  late TextEditingController notesController;
  bool isContacted = false;

  final Map<int, TextEditingController> _qtyControllers = {};

  late List<DoshItemModel> items;
  late List<File> images;
  DateTime? selectedDateTime;

  // إضافة متغيرات الفرع
  String? selectedBranchId;
  String? selectedBranchName;

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _setIsContacted();

    addressController = TextEditingController(
      text: widget.shipment.customPickupAddress,
    );
    notesController = TextEditingController(text: widget.shipment.userNotes);

    items = List.from(widget.shipment.items);
    images = List.from(widget.shipment.images);
    selectedDateTime = widget.shipment.requestedPickupAt;

    // تهيئة بيانات الفرع من الشحنة الممررة
    selectedBranchId = widget.shipment.selectedBranchId;
    selectedBranchName = widget.shipment.selectedBranchName;

    for (int i = 0; i < items.length; i++) {
      _qtyControllers[i] = TextEditingController(
        text: items[i].quantity.toString(),
      );
    }
  }

  void _setIsContacted() async {
    final user = await StorageServices.getUserData();
    if (user!.role == "trader_contracted") {
      setState(() {
        isContacted = true;
      });
    } else {
      setState(() {
        isContacted = false;
      });
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    addressController.dispose();
    notesController.dispose();
    for (final c in _qtyControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _updateQuantity(int index, int quantity) {
    if (quantity <= 0) return;

    setState(() {
      items[index] = items[index].copyWith(quantity: quantity);
      _qtyControllers[index]?.text = quantity.toString();
    });
  }

  void _removeItem(int index) {
    if (items.length == 1) {
      _showError('يجب أن تحتوي الشحنة على منتج واحد على الأقل');
      return;
    }

    setState(() {
      items.removeAt(index);

      _qtyControllers[index]?.dispose();

      final newControllers = <int, TextEditingController>{};
      for (int i = 0; i < items.length; i++) {
        if (i < index) {
          newControllers[i] = _qtyControllers[i]!;
        } else {
          newControllers[i] = _qtyControllers[i + 1]!;
        }
      }

      _qtyControllers.clear();
      _qtyControllers.addAll(newControllers);
    });
  }

  String _getAveragePrice(DoshItemModel item) {
    var price = getIt<DoshTypesManager>().typesList
        .firstWhere((type) => type.name == item.name)
        .price;
    num averagePrice = price * item.quantity;
    return averagePrice.toStringAsFixed(2);
  }

  void _saveChanges() async {
    if (addressController.text.trim().isEmpty) {
      _showError('يرجى إدخال عنوان الاستلام');
      return;
    }

    for (var item in items) {
      if (item.quantity <= 0) {
        _showError('يرجى التأكد من صحة الكميات');
        return;
      }
    }

    final updated = CreateShipmentModel(
      customPickupAddress: addressController.text.trim(),
      requestedPickupAt: selectedDateTime,
      images: images,
      items: items,
      userNotes: notesController.text.trim(),
      selectedBranchId: selectedBranchId, // تمرير الفرع
      selectedBranchName: selectedBranchName, // تمرير الفرع
    );

    widget.onUpdate?.call(updated);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CustomLoadingIndicator()),
      );

      FormData shipment = await _createFormData(updated);

      if (mounted) {
        BlocProvider.of<CreateShipmentCubit>(
          context,
        ).createShipment(shipment: shipment);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showError('حدث خطأ أثناء معالجة البيانات');
    }
  }

  Future<FormData> _createFormData(CreateShipmentModel shipment) async {
    List<File> images = shipment.images;
    List<MultipartFile> imagesFiles =
        await ShipmentManager.createMultipartImages(images: images);

    final formData = FormData.fromMap({
      ...shipment.toMap(includeCustomPickupAddress: !isContacted),
      'uploadedImages': imagesFiles,
    });

    return formData;
  }

  void _showError(String msg) {
    _overlayEntry?.remove();
    _overlayEntry = null;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(100),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    msg,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    final isSmall = size.width < 360;
    final isMedium = size.width >= 360 && size.width < 600;
    final isLarge = size.width >= 600;
    final isShortScreen = size.height < 700;

    final dialogWidth = isLarge
        ? 700.0
        : isMedium
        ? size.width * 0.92
        : size.width * 0.95;
    final availableHeight = size.height - padding.top - padding.bottom;
    final maxDialogHeight = isShortScreen
        ? availableHeight * 0.92
        : availableHeight * 0.9;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isShortScreen ? 16 : 24,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(maxHeight: maxDialogHeight),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(isSmall),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isSmall ? 16 : 20),
                  child: _buildProducts(isSmall, isMedium, isShortScreen),
                ),
              ),
              _buildFooter(isSmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isSmall) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: isSmall ? 16 : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withAlpha(400),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withAlpha(150),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(100),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.all(8),
            ),
          ),
          Expanded(
            child: Text(
              'مراجعة تفاصيل الشحنة',
              textAlign: TextAlign.center,
              style: AppStyles.styleBold18(context).copyWith(
                color: Colors.white,
                fontSize: isSmall ? 17 : 19,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProducts(bool isSmall, bool isMedium, bool isShortScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ميعاد التسليم
        _buildDeliveryTimeSection(),

        // منتجات الشحنة
        _buildProductsHeader(),

        // قائمة المنتجات
        ...items.asMap().entries.map((e) {
          final index = e.key;
          final item = e.value;
          return _buildProductCard(index, item, isSmall, isMedium);
        }),

        const SizedBox(height: 8),

        // عنوان الاستلام
        if (!isContacted) _buildAddressSection(),

        // عرض الفرع المختار (إن وُجد)
        if (selectedBranchName != null && selectedBranchId != null) ...[
          const SizedBox(height: 16),
          _buildBranchSection(),
        ],
      ],
    );
  }

  Widget _buildDeliveryTimeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.green.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withAlpha(100),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.access_time_rounded,
              color: Colors.green.shade700,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ميعاد التسليم',
                  style: AppStyles.styleMedium14(
                    context,
                  ).copyWith(color: Colors.green.shade800),
                ),
                const SizedBox(height: 4),
                Text(
                  _formateDate(),
                  style: AppStyles.styleBold16(
                    context,
                  ).copyWith(color: Colors.green.shade900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formateDate() {
    if (selectedDateTime == null) {
      return 'لم يتم التحديد';
    }
    final adjustedDate = selectedDateTime!.subtract(const Duration(hours: 2));
    return DateFormat('yyyy-MM-dd | hh:mm a', 'ar').format(adjustedDate);
  }

  Widget _buildProductsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withAlpha(50),
            AppColors.primaryColor.withAlpha(25),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withAlpha(100),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.inventory_2_rounded,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'منتجات الشحنة',
            style: AppStyles.styleSemiBold16(
              context,
            ).copyWith(color: AppColors.primaryColor),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${items.length}',
              style: AppStyles.styleSemiBold14(
                context,
              ).copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    int index,
    DoshItemModel item,
    bool isSmall,
    bool isMedium,
  ) {
    final averagePrice = _getAveragePrice(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withAlpha(400),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withAlpha(150),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppStyles.styleBold16(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.name,
                    textAlign: TextAlign.right,
                    style: AppStyles.styleSemiBold16(
                      context,
                    ).copyWith(color: Colors.grey.shade800),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade100, width: 1),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red.shade400,
                      size: 22,
                    ),
                    onPressed: () => _removeItem(index),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.format_list_numbered_rounded,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'الكمية',
                          style: AppStyles.styleSemiBold14(
                            context,
                          ).copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    Container(
                      width: isSmall
                          ? 100
                          : isMedium
                          ? 120
                          : 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primaryColor.withAlpha(150),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withAlpha(50),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _qtyControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: AppStyles.styleBold16(
                          context,
                        ).copyWith(color: AppColors.primaryColor),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: '0',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                        ),
                        onChanged: (v) {
                          final qty = int.tryParse(v);
                          if (qty != null && qty > 0) {
                            _updateQuantity(index, qty);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.attach_money,
                            color: Colors.green.shade600,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'السعر',
                          style: AppStyles.styleSemiBold14(
                            context,
                          ).copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    Container(
                      width: isSmall
                          ? 100
                          : isMedium
                          ? 120
                          : 140,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          averagePrice,
                          style: AppStyles.styleBold14(
                            context,
                          ).copyWith(color: Colors.green.shade700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade50, Colors.orange.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withAlpha(100),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: Colors.orange.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'عنوان الاستلام',
                style: AppStyles.styleSemiBold16(
                  context,
                ).copyWith(color: Colors.orange.shade800),
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
              border: Border.all(color: Colors.orange.shade200, width: 1),
            ),
            child: Text(
              addressController.text.isEmpty
                  ? 'لم يتم تحديد العنوان'
                  : addressController.text,
              style: AppStyles.styleMedium14(context).copyWith(
                color: addressController.text.isEmpty
                    ? Colors.grey.shade500
                    : Colors.grey.shade800,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha(100),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.store_rounded,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'الفرع المختار',
                style: AppStyles.styleSemiBold16(
                  context,
                ).copyWith(color: Colors.blue.shade800),
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
              border: Border.all(color: Colors.blue.shade200, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedBranchName ?? '',
                        style: AppStyles.styleSemiBold14(
                          context,
                        ).copyWith(color: Colors.grey.shade800),
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

  Widget _buildFooter(bool isSmall) {
    return BlocConsumer<CreateShipmentCubit, CreateShipmentState>(
      listener: (context, state) {
        if (state is CreateShipmentSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);
          GoRouter.of(context).pushReplacement(EndPoints.shipmentsCalendarView);
        }
        if (state is CreateShipmentFailure) {
          Navigator.pop(context);
          _showError(state.errorMessage);
        }
      },
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(isSmall ? 16 : 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(28),
            ),
            border: Border(
              top: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withAlpha(400),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withAlpha(150),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: state is CreateShipmentLoading
                          ? null
                          : _saveChanges,
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: state is CreateShipmentLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'حفظ وتأكيد',
                                    style: AppStyles.styleBold16(
                                      context,
                                    ).copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: state is CreateShipmentLoading
                          ? null
                          : () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: Text(
                          'إلغاء',
                          style: AppStyles.styleSemiBold16(
                            context,
                          ).copyWith(color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
