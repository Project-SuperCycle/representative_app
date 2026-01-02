import 'package:flutter/material.dart';
import '../../data/models/contact_form_data.dart';

class FormController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool? isRagPaperMerchant;
  String? selectedTopic;
  bool hasBeenSubmitted = false;

  bool validateForm(bool isArabic) {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (isRagPaperMerchant == null) {
      return false;
    }

    return true;
  }

  ContactFormData buildContactFormData() {
    return ContactFormData(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      mobile: mobileController.text.trim(),
      message: messageController.text.trim(),
      isRagPaperMerchant: isRagPaperMerchant!,
      subject: selectedTopic!,
    );
  }

  void resetForm() {
    formKey.currentState?.reset();
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    messageController.clear();
    isRagPaperMerchant = null;
    selectedTopic = null;
    hasBeenSubmitted = false;
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    messageController.dispose();
  }
}
