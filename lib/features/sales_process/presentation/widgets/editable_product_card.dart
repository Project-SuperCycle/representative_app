import 'package:flutter/material.dart';
import 'package:supercycle/core/helpers/custom_dropdown.dart';
import 'package:supercycle/core/services/dosh_types_manager.dart';
import 'package:supercycle/core/services/services_locator.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';
import 'package:supercycle/features/sales_process/data/models/unit.dart';
import 'package:supercycle/generated/l10n.dart';

class EditableProductCard extends StatefulWidget {
  final DoshItemModel product;
  final Function(DoshItemModel updatedProduct) onProductUpdated;
  final VoidCallback onProductDeleted;

  const EditableProductCard({
    super.key,
    required this.product,
    required this.onProductUpdated,
    required this.onProductDeleted,
  });

  @override
  State<EditableProductCard> createState() => _EditableProductCardState();
}

class _EditableProductCardState extends State<EditableProductCard> {
  late TextEditingController quantityController;
  String? selectedTypeName;
  String? selectedUnit;
  String averagePrice = '0';
  bool _isInitializing = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _setInitialTypeName();
    _setInitialUnit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _calculateAndUpdateAveragePrice();
        _isInitializing = false;
      }
    });
  }

  void _initializeController() {
    quantityController = TextEditingController(
      text: widget.product.quantity == 0
          ? ''
          : widget.product.quantity.toString(),
    );
    quantityController.addListener(_onQuantityChanged);
  }

  void _setInitialTypeName() {
    final typeOptions = _getTypeOptions();

    if (widget.product.name.isNotEmpty &&
        typeOptions.contains(widget.product.name)) {
      selectedTypeName = widget.product.name;
    } else if (typeOptions.isNotEmpty && widget.product.name.isNotEmpty) {
      final similarType = typeOptions.firstWhere(
        (type) =>
            type.toLowerCase().contains(widget.product.name.toLowerCase()),
        orElse: () => typeOptions.first,
      );
      selectedTypeName = similarType;
    } else {
      selectedTypeName = null;
    }
  }

  void _setInitialUnit() {
    final options = _getUnitOptions();
    if (options.contains(widget.product.unit)) {
      selectedUnit = widget.product.unit;
    } else {
      selectedUnit = options.first;
    }
  }

  @override
  void dispose() {
    quantityController.removeListener(_onQuantityChanged);
    quantityController.dispose();
    super.dispose();
  }

  void _onQuantityChanged() {
    if (_isInitializing || _isUpdating || !mounted) return;
    _calculateAndUpdateAveragePrice();
  }

  void _onTypeChanged(String? value) {
    if (value == null || !mounted || _isUpdating) return;
    setState(() {
      selectedTypeName = value;
    });
    _calculateAndUpdateAveragePrice();
    _safeUpdateProduct(widget.product.copyWith(name: value));
  }

  void _onUnitChanged(String? value) {
    if (value == null || !mounted || _isUpdating) return;
    setState(() {
      selectedUnit = value;
    });
    _calculateAndUpdateAveragePrice();
    _safeUpdateProduct(widget.product.copyWith(unit: value));
  }

  String _formatPriceInThousands(double price) {
    if (price == 0) return '0';

    if (price >= 1000) {
      double thousands = price / 1000;

      // إذا كان الرقم صحيح (مثلاً 5000)
      if (thousands == thousands.roundToDouble()) {
        int thousandsInt = thousands.toInt();
        if (thousandsInt == 1) {
          return 'ألف';
        } else if (thousandsInt == 2) {
          return 'ألفان';
        } else if (thousandsInt >= 3 && thousandsInt <= 10) {
          return '$thousandsInt آلاف';
        } else {
          return '$thousandsInt ألف';
        }
      } else {
        // إذا كان فيه كسور (مثلاً 5500 = 5.5 ألف)
        String formattedThousands = thousands.toStringAsFixed(1);

        // إزالة .0 إذا كان موجود
        if (formattedThousands.endsWith('.0')) {
          formattedThousands = formattedThousands.substring(
            0,
            formattedThousands.length - 2,
          );
        }

        return '$formattedThousands ألف';
      }
    } else {
      // أقل من ألف
      if (price == price.roundToDouble()) {
        return price.toInt().toString();
      } else {
        return price.toStringAsFixed(2);
      }
    }
  }

  void _calculateAndUpdateAveragePrice() {
    if (!mounted || _isUpdating) return;
    final quantityText = quantityController.text;
    if (quantityText.isEmpty ||
        selectedTypeName == null ||
        selectedUnit == null) {
      if (mounted) {
        setState(() {
          averagePrice = '0';
        });
      }
      return;
    }

    final quantity = double.tryParse(quantityText) ?? 0.0;
    final unitPrice = _getPrice(selectedTypeName!);

    // إذا كانت الوحدة "طن"، اضرب في 1000
    final multiplier = selectedUnit == Unit.ton.abbreviation ? 1000 : 1;
    final totalPrice = quantity * unitPrice * multiplier;

    if (mounted) {
      setState(() {
        averagePrice = _formatPriceInThousands(totalPrice.toDouble());
      });
    }

    if (!_isInitializing && quantity != widget.product.quantity) {
      _safeUpdateProduct(widget.product.copyWith(quantity: quantity));
    }
  }

  void _safeUpdateProduct(DoshItemModel updatedProduct) {
    if (_isUpdating || _isInitializing || !mounted) return;
    _isUpdating = true;
    Future.microtask(() {
      if (mounted) {
        widget.onProductUpdated(updatedProduct);
      }
      _isUpdating = false;
    });
  }

  void _safeDeleteProduct() {
    if (_isUpdating || !mounted) return;
    _isUpdating = true;
    Future.microtask(() {
      if (mounted) {
        widget.onProductDeleted();
      }
      _isUpdating = false;
    });
  }

  List<String> _getTypeOptions() {
    try {
      var typesList = getIt<DoshTypesManager>().typesList
          .map((type) => type.name)
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList();

      typesList.sort();
      return typesList;
    } catch (e) {
      return [];
    }
  }

  num _getPrice(String name) {
    try {
      var price = getIt<DoshTypesManager>().typesList
          .firstWhere((type) => type.name == name)
          .price;
      return price;
    } catch (e) {
      return 0;
    }
  }

  List<String> _getUnitOptions() {
    return [Unit.kg.abbreviation, Unit.ton.abbreviation];
  }

  String? _getValidTypeInitialValue() {
    final options = _getTypeOptions();
    if (options.isEmpty) return null;

    if (selectedTypeName != null && options.contains(selectedTypeName)) {
      return selectedTypeName;
    }
    return null;
  }

  String _getValidUnitInitialValue() {
    final options = _getUnitOptions();

    if (options.contains(widget.product.unit)) {
      return widget.product.unit ?? "";
    }

    return options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Header with delete button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withAlpha(25),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withAlpha(50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "تفاصيل المنتج",
                      style: AppStyles.styleMedium14(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _safeDeleteProduct,
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  iconSize: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Type Selection
                _buildModernTypeSelection(context),
                const SizedBox(height: 16),

                // Quantity and Unit
                Row(
                  children: [
                    Expanded(flex: 3, child: _buildQuantityField(context)),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: _buildUnitDropdown(context)),
                  ],
                ),

                const SizedBox(height: 20),

                // Price Display
                _buildModernPriceDisplay(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTypeSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 4),
          child: Text(
            "نوع المنتج",
            style: AppStyles.styleMedium12(
              context,
            ).copyWith(color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
        ),
        CustomDropdown(
          showBorder: true,
          options: _getTypeOptions(),
          onChanged: _onTypeChanged,
          hintText: S.of(context).select_type,
          initialValue: _getValidTypeInitialValue(),
        ),
      ],
    );
  }

  Widget _buildQuantityField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 4),
          child: Text(
            "الكمية",
            style: AppStyles.styleMedium12(
              context,
            ).copyWith(color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1.5),
          ),
          child: Row(
            children: [
              // Decrease button
              _buildQuantityButton(
                icon: Icons.remove,
                onTap: () {
                  final currentValue =
                      double.tryParse(quantityController.text) ?? 0;
                  if (currentValue > 0) {
                    final newValue = currentValue - 1;
                    quantityController.text = newValue == 0
                        ? ''
                        : newValue.toString();
                  }
                },
                color: Colors.red,
              ),

              // Text field
              Expanded(
                child: TextField(
                  controller: quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  style: AppStyles.styleMedium14(context).copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                  ),
                ),
              ),

              // Increase button
              _buildQuantityButton(
                icon: Icons.add,
                onTap: () {
                  final currentValue =
                      double.tryParse(quantityController.text) ?? 0;
                  final newValue = currentValue + 1;
                  quantityController.text = newValue.toString();
                },
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha(50),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  Widget _buildUnitDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 4),
          child: Text(
            "الوحدة",
            style: AppStyles.styleMedium12(
              context,
            ).copyWith(color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
        ),
        CustomDropdown(
          showBorder: true,
          initialValue: _getValidUnitInitialValue(),
          options: _getUnitOptions(),
          onChanged: _onUnitChanged,
        ),
      ],
    );
  }

  Widget _buildModernPriceDisplay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "الإجمالي",
            style: AppStyles.styleMedium14(
              context,
            ).copyWith(color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    averagePrice,
                    style: AppStyles.styleMedium14(context).copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "جنيه",
                  style: AppStyles.styleMedium12(
                    context,
                  ).copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
