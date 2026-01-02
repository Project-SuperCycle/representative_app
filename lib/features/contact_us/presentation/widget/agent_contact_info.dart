import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/features/contact_us/presentation/widget/contact_info_chip.dart';

class AgentContactInfo extends StatelessWidget {
  final bool isArabic;

  const AgentContactInfo({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Image.asset(AppAssets.logoIcon, scale: 4.5),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppAssets.logoName,
                    fit: BoxFit.contain,
                    scale: 5.0,
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ContactInfoChip(
                        icon: Icons.phone,
                        text: '+20 123 456 7890',
                      ),
                      SizedBox(height: 8),
                      ContactInfoChip(
                        icon: Icons.email,
                        text: 'agent@company.com',
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
}
