import 'package:supercycle/core/utils/contact_strings.dart';

class FormValidators {
  // Private constructor to prevent instantiation
  FormValidators._();

  static String? validateRequired(String? value, bool isArabic) {
    if (value == null || value.trim().isEmpty) {
      return ContactStrings.get('requiredField', isArabic);
    }
    return null;
  }

  static String? validateEmail(String? value, bool isArabic) {
    final requiredError = validateRequired(value, isArabic);
    if (requiredError != null) return requiredError;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value!.trim())) {
      return ContactStrings.get('invalidEmail', isArabic);
    }
    return null;
  }

  static String? validateMobile(String? value, bool isArabic) {
    final requiredError = validateRequired(value, isArabic);
    if (requiredError != null) return requiredError;

    // Remove all non-digit characters for validation
    final digitsOnly = value!.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return ContactStrings.get('mobileTooShort', isArabic);
    }

    return null;
  }

  static String? validateName(String? value, bool isArabic) {
    final requiredError = validateRequired(value, isArabic);
    if (requiredError != null) return requiredError;

    // Additional name validation can be added here
    if (value!.trim().length < 2) {
      return isArabic ? 'الاسم قصير جداً' : 'Name is too short';
    }

    return null;
  }

  static String? validateMessage(String? value, bool isArabic) {
    final requiredError = validateRequired(value, isArabic);
    if (requiredError != null) return requiredError;

    if (value!.trim().length < 10) {
      return isArabic ? 'الرسالة قصيرة جداً' : 'Message is too short';
    }

    return null;
  }
}
