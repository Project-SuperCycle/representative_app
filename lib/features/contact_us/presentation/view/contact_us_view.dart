import 'package:flutter/material.dart';
import 'package:supercycle/core/widgets/navbar/custom_curved_navigation_bar.dart';
import 'package:supercycle/features/contact_us/presentation/widget/contact_us_view_body.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContactUsViewBody(),
      bottomNavigationBar: CustomCurvedNavigationBar(currentIndex: 4),
    );
  }
}
