import 'package:flutter/material.dart' show BuildContext;
import 'package:supercycle/generated/l10n.dart' show S;

abstract class AuthFunctions {
  static String checkInputType(BuildContext context, String input) {
    String trimmedInput = input.trim();
    if (trimmedInput.isEmpty) {
      return S.of(context).field_required;
    }

    if (isValidEmail(trimmedInput)) {
      return 'email';
    }
    if (isValidPhone(trimmedInput)) {
      return 'phone';
    }
    return S.of(context).invalid_email_or_phone;
  }

  static String? validateEmailOrPhone(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).field_required;
    }

    String inputType = checkInputType(context, value);

    switch (inputType) {
      case 'email':
        if (!isValidEmail(value)) {
          return S.of(context).invalid_email;
        }
        return null;

      case 'phone':
        if (!isValidPhone(value)) {
          return S.of(context).invalid_phone;
        }
        return null;

      case 'غير محدد':
      default:
        return S.of(context).invalid_email_or_phone;
    }
  }

  static bool isValidEmail(String email) {
    String trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      return false;
    }
    RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );
    return emailRegex.hasMatch(trimmedEmail);
  }

  static bool isValidPhone(String phone) {
    String trimmedPhone = phone.trim();
    if (trimmedPhone.isEmpty) {
      return false;
    }
    String cleanedPhone = trimmedPhone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    RegExp egyptianPhoneRegex = RegExp(r'^(2)?01[0-9]{9}$');
    RegExp internationalPhoneRegex = RegExp(r'^[1-9]\d{7,14}$');

    if (egyptianPhoneRegex.hasMatch(cleanedPhone)) {
      return true;
    }
    if (internationalPhoneRegex.hasMatch(cleanedPhone)) {
      return true;
    }
    return false;
  }
}
