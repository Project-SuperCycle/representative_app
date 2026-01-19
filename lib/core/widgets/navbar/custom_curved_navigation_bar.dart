import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/services/auth_manager_services.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';

class CustomCurvedNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final GlobalKey<CurvedNavigationBarState>? navigationKey;

  const CustomCurvedNavigationBar({
    super.key,
    this.currentIndex = 1, // تغيير من 2 إلى 1 (الصفحة الرئيسية)
    this.onTap,
    this.navigationKey,
  });

  @override
  State<CustomCurvedNavigationBar> createState() =>
      _CustomCurvedNavigationBarState();
}

class _CustomCurvedNavigationBarState extends State<CustomCurvedNavigationBar> {
  late int _currentIndex;
  bool isUserLoggedIn = false;
  final AuthManager _authManager = AuthManager();

  @override
  void initState() {
    super.initState();
    _currentIndex = _getIndexFromCurrentRoute();
    _loadUserData();
    _authManager.authStateChangeNotifier.addListener(_onAuthStateChanged);
  }

  /// الحصول على الـ index من الـ route الحالي
  int _getIndexFromCurrentRoute() {
    final currentRoute = _getCurrentRoute();

    if (currentRoute.contains(EndPoints.homeView) || currentRoute == '/') {
      return 1;
    } else if (currentRoute.contains(EndPoints.shipmentsCalendarView)) {
      return 0;
    } else if (currentRoute.contains(EndPoints.contactUsView)) {
      return 2;
    }

    // ✅ الحل: بدل ما نرجع widget.currentIndex، نرجع 1 (الصفحة الرئيسية) كـ fallback آمن
    // لو الصفحة مش جزء من الـ navigation (زي صفحة التفاصيل)
    return 1; // default safe fallback
  }

  @override
  void didUpdateWidget(CustomCurvedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newIndex = _getIndexFromCurrentRoute();
    if (_currentIndex != newIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final newIndex = _getIndexFromCurrentRoute();
        if (_currentIndex != newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _authManager.authStateChangeNotifier.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (mounted) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    LoginedUserModel? user = await StorageServices.getUserData();
    if (mounted) {
      setState(() {
        isUserLoggedIn = (user != null);
      });
    }
  }

  String _getCurrentRoute() {
    try {
      final router = GoRouter.of(context);
      final location =
          router.routerDelegate.currentConfiguration.last.matchedLocation;
      return location;
    } catch (e) {
      return '/';
    }
  }

  String? _getTargetRoute(int index) {
    switch (index) {
      case 0:
        return isUserLoggedIn
            ? EndPoints.shipmentsCalendarView
            : EndPoints.signInView;
      case 1:
        return EndPoints.homeView;
      case 2:
        return EndPoints.contactUsView;
      default:
        return null;
    }
  }

  void _handleTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (widget.onTap != null) {
      widget.onTap!(index);
    }

    final currentRoute = _getCurrentRoute();
    final targetRoute = _getTargetRoute(index);

    if (targetRoute != null && currentRoute == targetRoute) {
      return;
    }

    _navigateToScreen(index);
  }

  void _navigateToScreen(int index) {
    if (!mounted) return;

    final router = GoRouter.of(context);

    try {
      switch (index) {
        case 0:
          if (isUserLoggedIn) {
            router.push(EndPoints.shipmentsCalendarView);
          } else {
            _showLoginRequired('جدول الشحنات');
            router.push(EndPoints.signInView);
          }
          break;

        case 1:
          router.pushReplacement(EndPoints.homeView);
          break;

        case 2:
          router.push(EndPoints.contactUsView);
          break;
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showWarning(
          context,
          'حدث خطأ أثناء التنقل: ${e.toString()}',
        );
      }
    }
  }

  void _showLoginRequired(String featureName) {
    if (!mounted) return;
    CustomSnackBar.showWarning(
      context,
      'يرجى تسجيل الدخول للوصول إلى $featureName',
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ إضافة validation للـ index قبل بناء الـ widget
    final safeIndex = _currentIndex.clamp(0, 2); // تأكد إن الـ index بين 0 و 2

    return CurvedNavigationBar(
      index: safeIndex, // استخدام safeIndex بدل _currentIndex
      key: widget.navigationKey,
      color: Colors.white,
      backgroundColor: AppColors.primaryColor,
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      items: <Widget>[
        _buildNavigationItem(
          asset: AppAssets.calendarIcon,
          isSvg: true,
          label: 'الجدول',
        ),
        _buildNavigationItem(
          asset: AppAssets.homeIcon,
          isSvg: false,
          height: 30,
          label: 'الرئيسية',
        ),
        _buildNavigationItem(
          asset: AppAssets.chatIcon,
          isSvg: true,
          label: 'اتصل بنا',
        ),
      ],
      onTap: _handleTap,
    );
  }

  Widget _buildNavigationItem({
    required String asset,
    required bool isSvg,
    required String label,
    double? height,
  }) {
    Widget iconWidget;

    if (isSvg) {
      iconWidget = SvgPicture.asset(
        asset,
        fit: BoxFit.cover,
        height: height ?? 24,
      );
    } else {
      iconWidget = Image.asset(asset, height: height ?? 24, fit: BoxFit.cover);
    }

    return Tooltip(message: label, child: iconWidget);
  }
}
