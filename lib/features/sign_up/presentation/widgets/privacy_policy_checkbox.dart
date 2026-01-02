import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/generated/l10n.dart' show S;

class PrivacyPolicyCheckbox extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  final bool initialValue;

  const PrivacyPolicyCheckbox({
    super.key,
    this.onChanged,
    this.initialValue = false,
  });

  @override
  State<PrivacyPolicyCheckbox> createState() => _PrivacyPolicyCheckboxState();
}

class _PrivacyPolicyCheckboxState extends State<PrivacyPolicyCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'سياسة الخصوصية والأحكام',
            style: AppStyles.styleSemiBold20(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. جمع البيانات',
                  style: AppStyles.styleSemiBold16(
                    context,
                  ).copyWith(color: AppColors.primaryColor),
                ),
                SizedBox(height: 8),
                Text(
                  'نحن نجمع البيانات الشخصية التي تقدمها لنا بشكل طوعي عند استخدام التطبيق، مثل الاسم والبريد الإلكتروني.',
                  style: AppStyles.styleRegular14(context),
                ),
                SizedBox(height: 16),

                Text(
                  '2. استخدام البيانات',
                  style: AppStyles.styleSemiBold16(
                    context,
                  ).copyWith(color: AppColors.primaryColor),
                ),
                SizedBox(height: 8),
                Text(
                  'نستخدم بياناتك لتحسين خدماتنا وتقديم تجربة مستخدم أفضل وإرسال التحديثات المهمة.',
                  style: AppStyles.styleRegular14(context),
                ),
                SizedBox(height: 16),

                Text(
                  '3. حماية البيانات',
                  style: AppStyles.styleSemiBold16(
                    context,
                  ).copyWith(color: AppColors.primaryColor),
                ),
                SizedBox(height: 8),
                Text(
                  'نحن ملتزمون بحماية بياناتك الشخصية وعدم مشاركتها مع أطراف ثالثة دون موافقتك الصريحة.',
                  style: AppStyles.styleRegular14(context),
                ),
                SizedBox(height: 16),

                Text(
                  '4. الكوكيز وتقنيات التتبع',
                  style: AppStyles.styleSemiBold16(
                    context,
                  ).copyWith(color: AppColors.primaryColor),
                ),
                SizedBox(height: 8),
                Text(
                  'قد نستخدم الكوكيز وتقنيات مماثلة لتحسين أداء التطبيق وفهم كيفية استخدامك له.',
                  style: AppStyles.styleRegular14(context),
                ),
                SizedBox(height: 16),

                Text(
                  '5. حقوقك',
                  style: AppStyles.styleSemiBold16(
                    context,
                  ).copyWith(color: AppColors.primaryColor),
                ),
                SizedBox(height: 8),
                Text(
                  'لديك الحق في الوصول إلى بياناتك الشخصية وتعديلها أو حذفها في أي وقت من خلال التواصل معنا.',
                  style: AppStyles.styleRegular14(context),
                ),
                SizedBox(height: 16),

                Text(
                  '6. التواصل',
                  style: AppStyles.styleSemiBold16(
                    context,
                  ).copyWith(color: AppColors.primaryColor),
                ),
                SizedBox(height: 8),
                Text(
                  'إذا كانت لديك أي أسئلة حول سياسة الخصوصية، يرجى التواصل معنا عبر البريد الإلكتروني أو من خلال التطبيق.',
                  style: AppStyles.styleRegular14(context),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'موافق',
                style: AppStyles.styleBold16(
                  context,
                ).copyWith(color: AppColors.primaryColor),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(isChecked);
            }
          },
          activeColor: Colors.blue,
          checkColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        // Text and Icon Button
        Expanded(
          child: Row(
            children: [
              // Agreement text
              Expanded(
                child: Text(
                  S.of(context).privacy_policy_required,
                  style: AppStyles.styleMedium14(
                    context,
                  ).copyWith(color: Colors.grey),
                ),
              ),
              SizedBox(width: 8),
              // Info icon button
              IconButton(
                onPressed: _showPrivacyPolicyDialog,
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 25,
                ),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
                tooltip: 'عرض تفاصيل السياسة',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
