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
    this.currentIndex = 2,
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
    // الاستماع لتغييرات حالة المصادقة
    _authManager.authStateChangeNotifier.addListener(_onAuthStateChanged);
  }

  /// الحصول على الـ index من الـ route الحالي
  int _getIndexFromCurrentRoute() {
    final currentRoute = _getCurrentRoute();

    if (currentRoute.contains(EndPoints.calculatorView)) {
      return 0;
    } else if (currentRoute.contains(EndPoints.salesProcessView)) {
      return 1;
    } else if (currentRoute.contains(EndPoints.homeView) ||
        currentRoute == '/') {
      return 2;
    } else if (currentRoute.contains(EndPoints.shipmentsCalendarView)) {
      return 3;
    } else if (currentRoute.contains(EndPoints.contactUsView)) {
      return 4;
    }

    return widget.currentIndex; // default fallback
  }

  @override
  void didUpdateWidget(CustomCurvedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // تحديث الـ index بناءً على الـ route الحالي
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
    // تحديث الـ index كل ما الـ route يتغير
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

  /// يتم استدعاؤها عند تغيير حالة المصادقة
  void _onAuthStateChanged() {
    if (mounted) {
      _loadUserData();
    }
  }

  /// تحميل بيانات المستخدم
  Future<void> _loadUserData() async {
    LoginedUserModel? user = await StorageServices.getUserData();
    if (mounted) {
      setState(() {
        isUserLoggedIn = (user != null);
      });
    }
  }

  /// الحصول على الـ route الحالي
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

  /// تحديد الـ route المطلوب بناءً على الـ index
  String? _getTargetRoute(int index) {
    switch (index) {
      case 0:
        return EndPoints.calculatorView;
      case 1:
        return isUserLoggedIn
            ? EndPoints.salesProcessView
            : EndPoints.signInView;
      case 2:
        return EndPoints.homeView;
      case 3:
        return isUserLoggedIn
            ? EndPoints.shipmentsCalendarView
            : EndPoints.signInView;
      case 4:
        return EndPoints.contactUsView;
      default:
        return null;
    }
  }

  /// معالجة النقر على الـ navigation item
  void _handleTap(int index) {
    // تحديث الـ index الحالي
    setState(() {
      _currentIndex = index;
    });

    // استدعاء callback إذا كان موجود
    if (widget.onTap != null) {
      widget.onTap!(index);
    }

    // التحقق من الـ route الحالي
    final currentRoute = _getCurrentRoute();
    final targetRoute = _getTargetRoute(index);

    // لو على نفس الصفحة، لا تعمل navigation
    if (targetRoute != null && currentRoute == targetRoute) {
      return;
    }

    // التنقل للصفحة المطلوبة
    _navigateToScreen(index);
  }

  /// التنقل للصفحة المحددة
  void _navigateToScreen(int index) {
    if (!mounted) return;

    final router = GoRouter.of(context);

    try {
      switch (index) {
        case 0:
          // حاسبة الشحنات - متاحة للجميع
          router.push(EndPoints.calculatorView);
          break;

        case 1:
          // عملية البيع - تتطلب تسجيل دخول
          if (isUserLoggedIn) {
            router.push(EndPoints.salesProcessView);
          } else {
            _showLoginRequired('عملية البيع');
            router.push(EndPoints.signInView);
          }
          break;

        case 2:
          // الصفحة الرئيسية - متاحة للجميع
          router.pushReplacement(EndPoints.homeView);
          break;

        case 3:
          // جدول الشحنات - يتطلب تسجيل دخول
          if (isUserLoggedIn) {
            router.push(EndPoints.shipmentsCalendarView);
          } else {
            _showLoginRequired('جدول الشحنات');
            router.push(EndPoints.signInView);
          }
          break;

        case 4:
          // اتصل بنا - متاح للجميع
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

  /// عرض رسالة تطلب تسجيل الدخول
  void _showLoginRequired(String featureName) {
    if (!mounted) return;
    CustomSnackBar.showWarning(
      context,
      'يرجى تسجيل الدخول للوصول إلى $featureName',
    );
  }

  @override
  Widget build(BuildContext context) {
    // تحديث الـ index كل ما الـ widget يعمل rebuild
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

    return CurvedNavigationBar(
      index: _currentIndex,
      key: widget.navigationKey,
      color: Colors.white,
      backgroundColor: AppColors.primaryColor,
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      items: <Widget>[
        _buildNavigationItem(
          asset: AppAssets.calculatorIcon,
          isSvg: true,
          label: 'حاسبة',
        ),
        _buildNavigationItem(
          asset: AppAssets.boxIcon,
          isSvg: true,
          height: 30,
          label: 'عملية بيع',
        ),
        _buildNavigationItem(
          asset: AppAssets.homeIcon,
          isSvg: false,
          height: 30,
          label: 'الرئيسية',
        ),
        _buildNavigationItem(
          asset: AppAssets.calendarIcon,
          isSvg: true,
          label: 'الجدول',
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

  /// بناء عنصر الـ navigation
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

    // إضافة Tooltip للـ accessibility
    return Tooltip(message: label, child: iconWidget);
  }
}
