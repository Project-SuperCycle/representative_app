import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/widgets/custom_button.dart';
import 'package:supercycle/features/home/data/models/dosh_type_model.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';
import 'package:supercycle/generated/l10n.dart';

class TypeCardItem extends StatefulWidget {
  final DoshTypeModel typeModel;
  const TypeCardItem({super.key, required this.typeModel});

  @override
  State<TypeCardItem> createState() => _TypeCardItemState();
}

class _TypeCardItemState extends State<TypeCardItem> {
  bool _isPressed = false;

  String formatPrice(dynamic price) {
    if (price == null) return '0.00';
    double value;
    if (price is String) {
      value = double.tryParse(price) ?? 0.0;
    } else if (price is int) {
      value = price.toDouble();
    } else if (price is double) {
      value = price;
    } else {
      value = 0.0;
    }
    return value.toStringAsFixed(2);
  }

  String formatPriceRange(dynamic minPrice, dynamic maxPrice) {
    return '${formatPrice(minPrice)} : ${formatPrice(maxPrice)}';
  }

  /// التحقق من تسجيل الدخول والانتقال للصفحة المناسبة
  Future<void> _handleMakeProcess() async {
    // جلب بيانات المستخدم
    LoginedUserModel? user = await StorageServices.getUserData();

    if (!mounted) return;

    if (user != null) {
      // المستخدم مسجل دخول - الانتقال لصفحة عملية البيع
      GoRouter.of(context).push(EndPoints.salesProcessView);
    } else {
      // المستخدم غير مسجل - عرض رسالة والانتقال لصفحة تسجيل الدخول
      CustomSnackBar.showError(context, 'يرجى تسجيل الدخول لإتمام عملية البيع');

      // الانتقال لصفحة تسجيل الدخول
      GoRouter.of(context).push(EndPoints.signInView);
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeModel = widget.typeModel;

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: Container(
          width: 200,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(100),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ======== IMAGE SECTION ========
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Stack(
                  children: [
                    Image.asset(
                      AppAssets.miniature,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withAlpha(0),
                            Colors.black.withAlpha(50),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(450),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.recycling,
                          size: 18,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ======== CONTENT SECTION ========
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ----- Title -----
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          typeModel.name,
                          textDirection: TextDirection.rtl,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.styleBold18(context).copyWith(),
                        ),
                      ),
                      // ----- Price Container -----
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withAlpha(50),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Text(
                                formatPriceRange(
                                  typeModel.minPrice,
                                  typeModel.maxPrice,
                                ),
                                style: AppStyles.styleBold14(
                                  context,
                                ).copyWith(color: AppColors.primaryColor),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${S.of(context).money} / ${S.of(context).unit}",
                                style: AppStyles.styleMedium12(
                                  context,
                                ).copyWith(color: AppColors.subTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ----- Button -----
                      CustomButton(
                        title: S.of(context).make_process,
                        onPress: _handleMakeProcess,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
