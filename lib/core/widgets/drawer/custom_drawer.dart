import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/services/auth_manager_services.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/widgets/drawer/user_info_list_tile.dart';
import 'package:supercycle/features/environment/data/cubits/eco_cubit/eco_cubit.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, this.isInProfilePage = false});

  final bool isInProfilePage;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isUserLoggedIn = false;
  LoginedUserModel? user;
  final AuthManager _authManager = AuthManager();

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // الاستماع لتغييرات حالة المصادقة
    _authManager.authStateChangeNotifier.addListener(_onAuthStateChanged);
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
    final userData = await StorageServices.getUserData();
    if (mounted) {
      setState(() {
        user = userData;
        isUserLoggedIn = (userData != null);
      });
    }
  }

  /// تسجيل الخروج بشكل محسّن
  Future<void> _performLogout(BuildContext context) async {
    // إغلاق الـ dialog
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    // إغلاق الـ drawer
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    // تنفيذ عملية تسجيل الخروج
    final success = await _authManager.logout();

    if (success && context.mounted) {
      // التنقل إلى الصفحة الرئيسية وإعادة بناء كل شيء
      context.go(EndPoints.homeView);

      // إظهار رسالة نجاح
      CustomSnackBar.showSuccess(context, 'تم تسجيل الخروج بنجاح');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouter.of(
      context,
    ).routeInformationProvider.value.uri.path;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: MediaQuery.sizeOf(context).width * .75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.of(context).padding.top + 10),
            ),

            const SliverToBoxAdapter(child: UserInfoListTile()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.grey[300], thickness: 1),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildDrawerItem(
                    icon: Icons.home_rounded,
                    title: 'الرئيسية',
                    isActive: currentLocation == EndPoints.homeView,
                    onTap: () {
                      Navigator.pop(context);
                      context.pushReplacement(EndPoints.homeView);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_today_rounded,
                    title: 'جدول الشحنات',
                    isActive:
                        currentLocation == EndPoints.shipmentsCalendarView,
                    onTap: () {
                      Navigator.pop(context);
                      if (isUserLoggedIn) {
                        context.push(EndPoints.shipmentsCalendarView);
                      } else {
                        context.push(EndPoints.signInView);
                      }
                    },
                  ),

                  _buildDrawerItem(
                    icon: Icons.calculate_rounded,
                    title: 'حاسبة الشحنات',
                    isActive: currentLocation == EndPoints.calculatorView,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(EndPoints.calculatorView);
                    },
                  ),

                  if (user != null && user!.isEcoParticipant == true)
                    BlocConsumer<EcoCubit, EcoState>(
                      listener: (context, state) {
                        if (state is GetEcoDataSuccess) {
                          context.push(EndPoints.environmentalImpactView);
                        }
                      },
                      builder: (context, state) {
                        return (state is GetEcoDataLoading)
                            ? SizedBox(
                                width: 40,
                                height: 40,
                                child: const CustomLoadingIndicator(),
                              )
                            : _buildDrawerItem(
                                icon: Icons.eco_rounded,
                                title: 'الأثر البيئي',
                                isActive:
                                    currentLocation ==
                                    EndPoints.environmentalImpactView,
                                onTap: () {
                                  context.read<EcoCubit>().getTraderEcoInfo();
                                },
                              );
                      },
                    ),

                  _buildDrawerItem(
                    icon: Icons.notifications_rounded,
                    title: 'الإشعارات',
                    isActive: false,
                    onTap: () {
                      Navigator.pop(context);

                      CustomSnackBar.showSuccess(
                        context,
                        'صفحة الإشعارات قريباً',
                      );
                    },
                  ),

                  _buildDrawerItem(
                    icon: Icons.support_agent_rounded,
                    title: 'الدعم والمساعدة',
                    isActive: currentLocation == EndPoints.contactUsView,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(EndPoints.contactUsView);
                    },
                  ),
                ],
              ),
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: Colors.grey[300], thickness: 1),
                  ),

                  _buildBottomItem(
                    icon: Icons.settings_rounded,
                    asset: AppAssets.settingsIcon,
                    title: 'الإعدادات',
                    onTap: () {
                      Navigator.pop(context);
                      CustomSnackBar.showSuccess(
                        context,
                        'صفحة الإعدادات قريباً',
                      );
                    },
                  ),

                  if (isUserLoggedIn)
                    _buildBottomItem(
                      icon: Icons.logout_rounded,
                      asset: AppAssets.logoutIcon,
                      title: 'تسجيل الخروج',
                      isLogout: true,
                      onTap: () => _showLogoutDialog(context),
                    )
                  else
                    _buildBottomItem(
                      icon: Icons.login_rounded,
                      asset: AppAssets.loginIcon,
                      title: 'تسجيل الدخول',
                      onTap: () {
                        Navigator.pop(context);
                        context.push(EndPoints.signInView);
                      },
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isActive
            ? const Color(0xFF10B981).withAlpha(25)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? const Color(0xFF10B981) : Colors.grey[600],
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: isActive
                        ? AppStyles.styleBold16(
                            context,
                          ).copyWith(color: const Color(0xFF10B981))
                        : AppStyles.styleMedium16(
                            context,
                          ).copyWith(color: Colors.grey[700]),
                  ),
                ),
                if (isActive)
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomItem({
    required IconData icon,
    required String asset,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Image.asset(
                  asset,
                  width: 24,
                  height: 24,
                  color: isLogout ? Colors.red : const Color(0xFF10B981),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: AppStyles.styleMedium16(
                      context,
                    ).copyWith(color: isLogout ? Colors.red : Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'تسجيل الخروج',
                  style: AppStyles.styleBold20(context),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  'هل أنت متأكد من تسجيل الخروج من حسابك؟',
                  style: AppStyles.styleMedium14(
                    context,
                  ).copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 50,
                        child: TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: Text(
                            'إلغاء',
                            style: AppStyles.styleSemiBold16(
                              context,
                            ).copyWith(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _performLogout(dialogContext),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'تسجيل الخروج',
                            style: AppStyles.styleSemiBold16(
                              context,
                            ).copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
