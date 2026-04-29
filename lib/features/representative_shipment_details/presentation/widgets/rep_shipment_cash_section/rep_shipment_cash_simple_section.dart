import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:representative_app/core/utils/app_colors.dart';

class CashCollectionSimpleSection extends StatefulWidget {
  final num totalAmount;
  final void Function(File? receipt)? onConfirm;

  const CashCollectionSimpleSection({
    super.key,
    required this.totalAmount,
    this.onConfirm,
  });

  @override
  State<CashCollectionSimpleSection> createState() =>
      _CashCollectionSimpleSectionState();
}

class _CashCollectionSimpleSectionState
    extends State<CashCollectionSimpleSection>
    with SingleTickerProviderStateMixin {
  File? _receiptImage;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // ── Design tokens ──────────────────────────────────────────────────────────
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

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) setState(() => _receiptImage = File(picked.path));
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
          border: Border.all(color: _greenBorder.withOpacity(0.3)),
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
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTotalRow(),
          Divider(
            height: 1,
            color: AppColors.primaryColor.withValues(alpha: 0.25),
            indent: 30,
            endIndent: 30,
          ),
          _buildReceiptUpload(),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  // ── Total Row ────────────────────────────────────────────────────────────────
  Widget _buildTotalRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F9F0), Color(0xFFD0F2E3)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _green.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.calculate_rounded, color: _green, size: 18),
              const SizedBox(width: 8),
              const Text(
                'إجمالي التحصيل',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
            ],
          ),
          Text(
            '${widget.totalAmount.toStringAsFixed(2)} ج.م',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _green,
            ),
          ),
        ],
      ),
    );
  }

  // ── Receipt Upload ───────────────────────────────────────────────────────────
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
                const Icon(Icons.receipt_long_rounded, color: _green, size: 16),
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
                  color: _greenBorder.withOpacity(0.5),
                  width: 1.5,
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
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_rounded,
                          color: _green,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
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

  // ── Confirm Button ───────────────────────────────────────────────────────────
  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, child) =>
            Transform.scale(scale: _pulseAnim.value, child: child),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => widget.onConfirm?.call(_receiptImage),
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: _white,
              elevation: 4,
              shadowColor: _green.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_rounded, size: 20, color: _white),
                const SizedBox(width: 8),
                const Text(
                  'تأكيد التحصيل',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _white,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.totalAmount.toStringAsFixed(2)} ج.م',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
