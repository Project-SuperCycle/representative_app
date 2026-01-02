import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/generated/l10n.dart';

enum DialogType { info, warning, success, error }

Future<void> showCustomConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirmed,
  DialogType type = DialogType.info,
  String? confirmText,
  String? cancelText,
  bool isDismissible = false,
}) {
  return showDialog(
    context: context,
    barrierDismissible: isDismissible,
    barrierColor: Colors.black.withAlpha(300),
    builder: (BuildContext dialogContext) {
      return _CustomConfirmationDialog(
        title: title,
        message: message,
        onConfirmed: onConfirmed,
        type: type,
        confirmText: confirmText,
        cancelText: cancelText,
      );
    },
  );
}

class _CustomConfirmationDialog extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onConfirmed;
  final DialogType type;
  final String? confirmText;
  final String? cancelText;

  const _CustomConfirmationDialog({
    required this.title,
    required this.message,
    required this.onConfirmed,
    required this.type,
    this.confirmText,
    this.cancelText,
  });

  @override
  State<_CustomConfirmationDialog> createState() =>
      _CustomConfirmationDialogState();
}

class _CustomConfirmationDialogState extends State<_CustomConfirmationDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _iconController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _iconScaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _iconScaleAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    );

    _fadeController.forward();
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _iconController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  DialogConfig _getDialogConfig() {
    switch (widget.type) {
      case DialogType.warning:
        return DialogConfig(
          icon: Icons.warning_rounded,
          primaryColor: const Color(0xFFFFA726),
          gradientColors: [const Color(0xFFFFA726), const Color(0xFFFF9800)],
          backgroundColor: const Color(0xFFFFF8E1),
        );
      case DialogType.success:
        return DialogConfig(
          icon: Icons.check_circle_rounded,
          primaryColor: const Color(0xFF00C853),
          gradientColors: [const Color(0xFF00C853), const Color(0xFF00B248)],
          backgroundColor: const Color(0xFFE8F5E9),
        );
      case DialogType.error:
        return DialogConfig(
          icon: Icons.error_rounded,
          primaryColor: const Color(0xFFE53935),
          gradientColors: [const Color(0xFFE53935), const Color(0xFFD32F2F)],
          backgroundColor: const Color(0xFFFFEBEE),
        );
      case DialogType.info:
        return DialogConfig(
          icon: Icons.info_rounded,
          primaryColor: AppColors.primaryColor,
          gradientColors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withAlpha(400),
          ],
          backgroundColor: AppColors.primaryColor.withAlpha(25),
        );
    }
  }

  void _onConfirm() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop();
    widget.onConfirmed();
  }

  void _onCancel() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final config = _getDialogConfig();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: config.primaryColor.withAlpha(100),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(config),
                _buildContent(config),
                _buildActions(config),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(DialogConfig config) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: config.gradientColors,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          ScaleTransition(
            scale: _iconScaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(config.icon, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.title,
            style: AppStyles.styleBold20(context).copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(DialogConfig config) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: config.backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: config.primaryColor.withAlpha(100),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: config.primaryColor.withAlpha(125),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.message_rounded,
                    color: config.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: AppStyles.styleRegular14(
                      context,
                    ).copyWith(height: 1.5),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(DialogConfig config) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        children: [
          Expanded(child: _buildConfirmButton(config)),
          const SizedBox(width: 12),
          Expanded(child: _buildCancelButton(config)),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(DialogConfig config) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: config.gradientColors,
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: config.primaryColor.withAlpha(150),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onConfirm,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.confirmText ?? S.of(context).alert_ok_button,
                  style: AppStyles.styleSemiBold14(
                    context,
                  ).copyWith(color: Colors.white),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.check_rounded, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(DialogConfig config) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: config.primaryColor.withAlpha(150),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onCancel,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.cancelText ?? S.of(context).alert_cancel_button,
                  style: AppStyles.styleSemiBold14(
                    context,
                  ).copyWith(color: config.primaryColor),
                ),
                const SizedBox(width: 6),
                Icon(Icons.close_rounded, color: config.primaryColor, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DialogConfig {
  final IconData icon;
  final Color primaryColor;
  final List<Color> gradientColors;
  final Color backgroundColor;

  DialogConfig({
    required this.icon,
    required this.primaryColor,
    required this.gradientColors,
    required this.backgroundColor,
  });
}
