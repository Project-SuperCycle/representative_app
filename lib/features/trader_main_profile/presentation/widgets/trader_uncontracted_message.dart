import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class TraderUncontractedMessage extends StatelessWidget {
  final String phoneNumber;
  final String whatsappNumber;
  final VoidCallback? onContactPressed;

  const TraderUncontractedMessage({
    super.key,
    this.phoneNumber = '+201100068736',
    this.whatsappNumber = '+201100068736',
    this.onContactPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.orange.shade400, Colors.deepOrange.shade500],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlpha(100),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(25),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(25),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Icon with animation
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.handshake_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                Text(
                  'انضم لشركاء الدَشت',
                  textAlign: TextAlign.right,
                  style: AppStyles.styleBold24(
                    context,
                  ).copyWith(color: Colors.white),
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  'نرحب بتعاونك معنا! إذا كنت تاجراً وترغب في التعاقد معنا وتوريد شحنات دشت، نحن هنا لخدمتك',
                  textAlign: TextAlign.right,
                  style: AppStyles.styleRegular16(
                    context,
                  ).copyWith(color: Colors.white.withAlpha(450)),
                ),

                const SizedBox(height: 24),

                // Benefits Row
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBenefit(context, Icons.speed, 'تواصل سريع'),
                      _buildBenefit(context, Icons.payment, 'أسعار تنافسية'),
                      _buildBenefit(context, Icons.support_agent, 'دعم 24/7'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // WhatsApp Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchWhatsApp(whatsappNumber),
                        icon: const Icon(
                          Icons.chat,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'واتساب',
                            style: AppStyles.styleBold14(
                              context,
                            ).copyWith(color: Colors.white),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Call Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _makePhoneCall(phoneNumber),
                        icon: const Icon(
                          Icons.phone,
                          size: 20,
                          color: AppColors.primaryColor,
                        ),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'اتصل بنا',
                            style: AppStyles.styleBold14(
                              context,
                            ).copyWith(color: AppColors.primaryColor),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: AppStyles.styleSemiBold12(
                context,
              ).copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchWhatsApp(String number) async {
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$number?text=${Uri.encodeComponent("مرحباً، أرغب في الاستفسار عن التعاقد مع دشت")}',
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri phoneUri = Uri.parse('tel:$number');

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}
