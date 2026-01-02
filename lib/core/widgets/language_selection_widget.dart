import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class LanguageSelectionWidget extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const LanguageSelectionWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildOption(context: context, label: "العربية", optionValue: "ar"),
        const SizedBox(height: 8),
        _buildOption(context: context, label: "English", optionValue: "en"),
      ],
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required String label,
    required String optionValue,
  }) {
    final bool isSelected = value == optionValue;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(optionValue),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.grey.shade400,
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
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(label, style: AppStyles.styleMedium14(context)),
          ],
        ),
      ),
    );
  }
}
