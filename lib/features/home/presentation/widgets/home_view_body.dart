import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/core/services/auth_manager_services.dart';
import 'package:representative_app/core/services/storage_services.dart';
import 'package:representative_app/features/home/data/managers/home_cubit/home_cubit.dart';
import 'package:representative_app/features/home/data/managers/shipments_cubit/today_shipments_cubit.dart';
import 'package:representative_app/features/home/presentation/widgets/home_chart/sales_chart_card.dart';
import 'package:representative_app/features/home/presentation/widgets/home_view_header.dart';
import 'package:representative_app/features/home/presentation/widgets/today_shipments/today_shipments_card.dart';
import 'package:representative_app/features/home/presentation/widgets/types_section/types_list_view.dart';
import 'package:representative_app/features/home/presentation/widgets/types_section/types_section_header.dart';
import 'package:representative_app/features/sign_in/data/models/logined_user_model.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key, required this.onDrawerPressed});
  final VoidCallback onDrawerPressed;

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody>
    with AutomaticKeepAliveClientMixin {
  bool isUserLoggedIn = false;
  final AuthManager _authManager = AuthManager();

  // ✅ للحفاظ على حالة الـ Widget عند التنقل
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // ✅ استدعاء البيانات الأولية
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });

    // الاستماع لتغييرات حالة المصادقة
    _authManager.authStateChangeNotifier.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _authManager.authStateChangeNotifier.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  /// ✅ جلب البيانات الأولية
  void _fetchInitialData() {
    // جلب بيانات الـ Home
    context.read<HomeCubit>().fetchInitialData();

    // // جلب بيانات الشحنات إذا كان المستخدم مسجل دخول
    // if (isUserLoggedIn) {
    //   context.read<TodayShipmentsCubit>().fetchInitialData();
    // }
  }

  /// يتم استدعاؤها عند تغيير حالة المصادقة
  void _onAuthStateChanged() {
    if (mounted) {
      _loadUserData();
      // إعادة تحميل بيانات الصفحة بعد تسجيل الخروج
      _refreshAllData();
    }
  }

  /// ✅ تحميل بيانات المستخدم
  Future<void> _loadUserData() async {
    LoginedUserModel? loginedUser = await StorageServices.getUserData();
    if (mounted) {
      setState(() {
        isUserLoggedIn = (loginedUser != null);
      });
    }
  }

  /// ✅ تحديث جميع البيانات (Refresh)
  Future<void> _refreshAllData() async {
    await _loadUserData();

    // تحديث بيانات الـ Home
    await context.read<HomeCubit>().refreshData();

    // ✅ تحديث بيانات الشحنات إذا كان المستخدم مسجل دخول
    if (isUserLoggedIn) {
      await context.read<TodayShipmentsCubit>().refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ مهم لـ AutomaticKeepAliveClientMixin

    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: _refreshAllData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              HomeViewHeader(onDrawerPressed: widget.onDrawerPressed),
              const SizedBox(height: 10),

              // ✅ إظهار كارت الشحنات فقط للمستخدم المسجل
              if (isUserLoggedIn) const TodayShipmentsCard(),

              const SalesChartCard(),
              const SizedBox(height: 20),
              const TypesSectionHeader(),
              const SizedBox(height: 12),
              const TypesListView(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
