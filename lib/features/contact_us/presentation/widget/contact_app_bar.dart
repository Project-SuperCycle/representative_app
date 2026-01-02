import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/utils/contact_strings.dart';

class ContactAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isArabic;
  final bool isLoading;
  final VoidCallback onLanguageToggle;
  final VoidCallback onBack;

  const ContactAppBar({
    super.key,
    required this.isArabic,
    required this.isLoading,
    required this.onLanguageToggle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.translate,
          color: isLoading ? Colors.white60 : Colors.white,
        ),
        onPressed: isLoading ? null : onLanguageToggle,
        tooltip: ContactStrings.get('switchToEnglish', isArabic),
      ),
      title: Text(
        ContactStrings.get('title', isArabic),
        style: AppStyles.styleSemiBold20(
          context,
        ).copyWith(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
