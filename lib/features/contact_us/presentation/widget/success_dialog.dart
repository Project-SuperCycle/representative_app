import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/utils/contact_strings.dart';

class SuccessDialog extends StatelessWidget {
  final bool isArabic;

  const SuccessDialog({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Color(0xFF3BC577),
              size: 35,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            ContactStrings.get('successTitle', isArabic),
            style: const TextStyle(
              color: Color(0xFF3BC577),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        ContactStrings.get('successMessage', isArabic),
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3BC577),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              ContactStrings.get('ok', isArabic),
              style: AppStyles.styleSemiBold16(context),
            ),
          ),
        ),
      ],
    );
  }
}
