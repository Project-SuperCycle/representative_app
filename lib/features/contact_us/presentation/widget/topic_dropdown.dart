import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/contact_strings.dart';

class TopicDropdown extends StatelessWidget {
  final String? value;
  final Function(String?) onChanged;
  final bool isArabic;
  final bool enabled;

  const TopicDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isArabic,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: ContactStrings.get('messageTopic', isArabic),
        hintText: ContactStrings.get('Select a topic', isArabic),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3BC577), width: 2),
        ),
        prefixIcon: const Icon(Icons.list_alt, color: Color(0xFF3BC577)),
      ),
      items: [
        DropdownMenuItem(
          value: 'complaint',
          child: Text(isArabic ? 'شكوى' : 'Complaint'),
        ),
        DropdownMenuItem(
          value: 'inquiry',
          child: Text(isArabic ? 'استفسار' : 'Inquiry'),
        ),
        DropdownMenuItem(
          value: 'suggestion',
          child: Text(isArabic ? 'اقتراح' : 'Suggestion'),
        ),
      ],
      onChanged: enabled ? onChanged : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return isArabic ? 'اختر موضوع الرسالة' : 'Please select a topic';
        }
        return null;
      },
      icon: const Icon(
        Icons.arrow_drop_down_rounded,
        color: Colors.grey,
        size: 28,
      ),
      dropdownColor: Colors.white,
      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
    );
  }
}
