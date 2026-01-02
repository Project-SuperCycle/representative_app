import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supercycle/core/utils/app_assets.dart' show AppAssets;
import 'package:supercycle/core/utils/app_colors.dart' show AppColors;
import 'package:supercycle/core/utils/app_styles.dart' show AppStyles;
import 'package:supercycle/generated/l10n.dart' show S;

class RoundedSearchField extends StatefulWidget {
  final ValueChanged<String> onChange;
  final String? hintText;
  final String? searchIconPath;
  final Color? fillColor;
  final Color? hintTextColor;
  final TextStyle? hintStyle;
  final double? borderRadius;
  final EdgeInsets? contentPadding;
  final double? widthFactor;
  final TextEditingController? controller;
  final bool showClearButton;
  final VoidCallback? onClear;

  const RoundedSearchField({
    super.key,
    required this.onChange,
    this.hintText,
    this.searchIconPath,
    this.fillColor = Colors.white,
    this.hintTextColor,
    this.hintStyle,
    this.borderRadius = 20,
    this.contentPadding = const EdgeInsets.all(12),
    this.widthFactor = 0.75,
    this.controller,
    this.showClearButton = true,
    this.onClear,
  });

  @override
  State<RoundedSearchField> createState() => _RoundedSearchFieldState();
}

class _RoundedSearchFieldState extends State<RoundedSearchField> {
  late TextEditingController _controller;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _showClearButton = _controller.text.isNotEmpty;
    });
  }

  void _clearText() {
    _controller.clear();
    widget.onChange('');
    if (widget.onClear != null) {
      widget.onClear!();
    }
    setState(() {
      _showClearButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * widget.widthFactor!,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChange,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor,
          contentPadding: widget.contentPadding,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
            borderSide: BorderSide(
              color: AppColors.primaryColor.withAlpha(150),
              width: 1.5,
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 18.0, left: 6.0),
            child: SvgPicture.asset(
              widget.searchIconPath ?? AppAssets.searchIcon,
              width: 30,
            ),
          ),
          suffixIcon: widget.showClearButton && _showClearButton
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey),
                  onPressed: _clearText,
                )
              : null,
          hintText: widget.hintText ?? S.of(context).search,
          hintStyle:
              widget.hintStyle ??
              AppStyles.styleSemiBold14(
                context,
              ).copyWith(color: widget.hintTextColor ?? AppColors.subTextColor),
        ),
      ),
    );
  }
}
