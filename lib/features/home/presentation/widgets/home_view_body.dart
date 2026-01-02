import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/core/services/auth_manager_services.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/features/home/data/managers/home_cubit/home_cubit.dart';
import 'package:supercycle/features/home/presentation/widgets/home_chart/sales_chart_card.dart';
import 'package:supercycle/features/home/presentation/widgets/home_view_header.dart';
import 'package:supercycle/features/home/presentation/widgets/types_section/types_list_view.dart';
import 'package:supercycle/features/home/presentation/widgets/types_section/types_section_header.dart';
import 'package:supercycle/features/home/presentation/widgets/today_shipments_card.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key, required this.onDrawerPressed});
  final VoidCallback onDrawerPressed;

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  bool isUserLoggedIn = false;
  final AuthManager _authManager = AuthManager();

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // استدعاء البيانات الأولية
    var cubit = BlocProvider.of<HomeCubit>(context, listen: false);
    cubit.fetchInitialData();

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
      // إعادة تحميل بيانات الصفحة بعد تسجيل الخروج
      context.read<HomeCubit>().refreshData();
    }
  }

  /// تحميل بيانات المستخدم
  Future<void> _loadUserData() async {
    LoginedUserModel? loginedUser = await StorageServices.getUserData();
    if (mounted) {
      setState(() {
        isUserLoggedIn = (loginedUser != null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: () async {
          await _loadUserData();
          await context.read<HomeCubit>().refreshData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              HomeViewHeader(onDrawerPressed: widget.onDrawerPressed),
              const SizedBox(height: 10),

              // إظهار كارت الشحنات فقط للمستخدم المسجل
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
