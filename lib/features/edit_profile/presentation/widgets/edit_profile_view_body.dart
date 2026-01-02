import 'package:flutter/material.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/widgets/language_selection_widget.dart';

class EditProfileViewBody extends StatefulWidget {
  const EditProfileViewBody({super.key});

  @override
  State<EditProfileViewBody> createState() => _EditProfileViewBodyState();
}

class _EditProfileViewBodyState extends State<EditProfileViewBody> {
  String userName = "Ahmed Ali";
  String userEmail = "ahmed@example.com";
  String userPhone = "+20 123 456 7890";

  String _selectedLanguage = "ar";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildInfoCard(
                    title: "المعلومات الشخصية",
                    children: [
                      _buildInfoTile(
                        icon: Icons.person,
                        title: "الاسم",
                        subtitle: userName,
                        onTap: () => _editField("الاسم", userName),
                      ),
                      _buildInfoTile(
                        icon: Icons.email,
                        title: "البريد الإلكتروني",
                        subtitle: userEmail,
                        onTap: () => _editField("البريد الإلكتروني", userEmail),
                      ),
                      _buildInfoTile(
                        icon: Icons.phone,
                        title: "رقم الهاتف",
                        subtitle: userPhone,
                        onTap: () => _editField("رقم الهاتف", userPhone),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoCard(
                    title: "الإعدادات",
                    children: [
                      _buildInfoTile(
                        icon: Icons.notifications,
                        title: "الإشعارات",
                        subtitle: "تفعيل الإشعارات",
                        trailing: Switch(
                          value: true,
                          activeThumbColor: AppColors.primaryColor,
                          onChanged: (_) {},
                        ),
                      ),
                      _buildInfoTile(
                        icon: Icons.language,
                        title: "اللغة",
                        subtitle: _selectedLanguage == "ar"
                            ? "العربية"
                            : "English",
                        onTap: _showLanguageDialog,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== HEADER ====================

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: const BoxDecoration(
        gradient: kGradientContainer,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "تعديل الملف الشخصي",
                    style: AppStyles.styleSemiBold18(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== INFO CARD ====================

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppStyles.styleSemiBold18(context)),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha(50),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryColor),
      ),
      title: Text(title, style: AppStyles.styleSemiBold14(context)),
      subtitle: Text(
        subtitle,
        style: AppStyles.styleSemiBold12(
          context,
        ).copyWith(color: AppColors.subTextColor),
      ),
      trailing:
          trailing ??
          (onTap != null
              ? const Icon(Icons.arrow_forward_ios, size: 16)
              : null),
      onTap: onTap,
    );
  }

  // ==================== DIALOGS ====================

  void _editField(String fieldName, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "تعديل $fieldName",
          style: AppStyles.styleSemiBold18(context),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: fieldName,
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () {
              setState(() {
                if (fieldName == "الاسم") userName = controller.text;
                if (fieldName == "البريد الإلكتروني") {
                  userEmail = controller.text;
                }
                if (fieldName == "رقم الهاتف") {
                  userPhone = controller.text;
                }
              });
              Navigator.pop(context);
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("اختر اللغة", style: AppStyles.styleSemiBold18(context)),
        content: StatefulBuilder(
          builder: (context, setLocalState) {
            return LanguageSelectionWidget(
              value: _selectedLanguage,
              onChanged: (lang) {
                setLocalState(() {
                  _selectedLanguage = lang;
                });
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  // ==================== NAV ====================
}
