import 'package:flutter/material.dart';
import 'package:supercycle/core/constants.dart';
import '../controllers/form_controller.dart';
import 'agent_contact_info.dart';
import 'contact_form.dart';

class ContactBody extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final FormController formController;
  final bool isArabic;
  final bool isLoading;
  final VoidCallback onSubmit;

  const ContactBody({
    super.key,
    required this.animationController,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.formController,
    required this.isArabic,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(gradient: kGradientBackground),
      child: SafeArea(
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Column(
                  children: [
                    AgentContactInfo(isArabic: isArabic),
                    Expanded(
                      child: ContactForm(
                        formController: formController,
                        isArabic: isArabic,
                        isLoading: isLoading,
                        onSubmit: onSubmit,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
