import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/features/sales_process/data/models/unit.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';
import 'package:supercycle/features/sales_process/presentation/widgets/editable_product_card.dart';

class EntryShipmentDetailsContent extends StatefulWidget {
  final List<DoshItemModel> products;
  final Function(List<DoshItemModel>) onProductsChanged;
  const EntryShipmentDetailsContent({
    super.key,
    required this.products,
    required this.onProductsChanged,
  });

  @override
  State<EntryShipmentDetailsContent> createState() =>
      _EntryShipmentDetailsContentState();
}

class _EntryShipmentDetailsContentState
    extends State<EntryShipmentDetailsContent> {
  late List<DoshItemModel> editableProducts;
  bool _isUpdating = false; // Flag to prevent recursive updates

  @override
  void initState() {
    super.initState();
    editableProducts = List.from(widget.products);
    if (editableProducts.isEmpty) {
      editableProducts.add(
        DoshItemModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: "",
          quantity: 0,
          unit: Unit.kg.abbreviation,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(EntryShipmentDetailsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update if products actually changed and we're not in the middle of an update
    if (!_isUpdating && widget.products != oldWidget.products) {
      editableProducts = List.from(widget.products);
      if (editableProducts.isEmpty) {
        editableProducts.add(
          DoshItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: "",
            quantity: 0,
            unit: Unit.kg.abbreviation,
          ),
        );
      }
    }
  }

  void _addProduct() {
    if (_isUpdating) return; // Prevent recursive calls

    setState(() {
      editableProducts.add(
        DoshItemModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: "",
          quantity: 0,
          unit: Unit.kg.abbreviation,
        ),
      );
    });
    // Don't call _scheduleCallback for add product as it's just adding an empty product
  }

  void _scheduleCallback() {
    if (_isUpdating) return; // Prevent recursive calls

    _isUpdating = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onProductsChanged(List.from(editableProducts));
      }
      _isUpdating = false;
    });
  }

  void _handleProductUpdate(DoshItemModel updatedProduct) {
    if (_isUpdating) return; // Prevent recursive calls

    // Use Future.microtask to defer the setState call
    Future.microtask(() {
      if (mounted && !_isUpdating) {
        setState(() {
          final index = editableProducts.indexWhere(
            (p) => p.id == updatedProduct.id,
          );
          if (index != -1) {
            editableProducts[index] = updatedProduct;
          }
        });
        _scheduleCallback();
      }
    });
  }

  void _handleProductDelete(DoshItemModel productToDelete) {
    if (_isUpdating) return; // Prevent recursive calls

    // Use Future.microtask to defer the setState call
    Future.microtask(() {
      if (mounted && !_isUpdating) {
        setState(() {
          editableProducts.removeWhere((p) => p.id == productToDelete.id);
          if (editableProducts.isEmpty) {
            editableProducts.add(
              DoshItemModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: "",
                quantity: 0,
                unit: Unit.kg.abbreviation,
              ),
            );
          }
        });
        _scheduleCallback();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...editableProducts.map((product) {
            return EditableProductCard(
              key: ValueKey(product.id), // Add key for better widget identity
              product: product,
              onProductUpdated: _handleProductUpdate,
              onProductDeleted: () => _handleProductDelete(product),
            );
          }),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: ElevatedButton(
                onPressed: _addProduct,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryColor,
                  elevation: 4,
                ),
                child: const Icon(Icons.add, size: 30),
              ),
            ),
          ),
          //ShipmentSummary(products: editableProducts),
        ],
      ),
    );
  }
}
