import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/utils/contact_strings.dart';

class MerchantQuestionWidget extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final bool isArabic;
  final bool enabled;

  const MerchantQuestionWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isArabic,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? const Color(0xFF3BC577) : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ContactStrings.get('merchantQuestion', isArabic),
            style: AppStyles.styleSemiBold16(context).copyWith(
              color: enabled ? const Color(0xFF3BC577) : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _buildRadioOption(
                  context: context,
                  label: ContactStrings.get('yes', isArabic),
                  radioValue: true,
                ),
              ),
              Expanded(
                child: _buildRadioOption(
                  context: context,
                  label: ContactStrings.get('no', isArabic),
                  radioValue: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required BuildContext context,
    required String label,
    required bool radioValue,
  }) {
    final isSelected = value == radioValue;

    return InkWell(
      onTap: enabled ? () => onChanged(radioValue) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: enabled
                      ? (isSelected
                            ? const Color(0xFF3BC577)
                            : Colors.grey.shade400)
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: enabled
                              ? const Color(0xFF3BC577)
                              : Colors.grey.shade400,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: AppStyles.styleMedium14(context).copyWith(
                  color: enabled ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
