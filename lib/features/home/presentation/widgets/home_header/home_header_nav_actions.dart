import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart' show AppAssets;
import 'package:supercycle/core/widgets/notifications/notifications_overlay.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';

class HomeHeaderNavActions extends StatefulWidget {
  const HomeHeaderNavActions({
    super.key,
    required this.onDrawerPressed,
    this.onNotificationPressed,
  });

  final VoidCallback onDrawerPressed;
  final VoidCallback? onNotificationPressed;

  @override
  State<HomeHeaderNavActions> createState() => _HomeHeaderNavActionsState();
}

class _HomeHeaderNavActionsState extends State<HomeHeaderNavActions> {
  bool isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkUserLogin();
  }

  void _checkUserLogin() async {
    LoginedUserModel? user = await StorageServices.getUserData();
    if (mounted) {
      setState(() {
        isUserLoggedIn = (user != null);
      });
    }
  }

  void _onNotificationPressed() {
    if (widget.onNotificationPressed != null) {
      widget.onNotificationPressed!();
    } else {
      NotificationsOverlay.toggle(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isUserLoggedIn
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: [
        _buildDrawerButton(),
        SizedBox(width: 15),
        if (isUserLoggedIn) _buildNotificationButton(),
      ],
    );
  }

  Widget _buildDrawerButton() {
    return GestureDetector(
      onTap: widget.onDrawerPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(50),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          AppAssets.drawerIcon,
          width: 20,
          height: 20,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: _onNotificationPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(50),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset(
              AppAssets.notificationIcon,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
