import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/services/auth_manager_services.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/home/data/managers/profile_cubit/profile_cubit.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';
import 'package:supercycle/generated/l10n.dart';

class UserProfileWelcomeCard extends StatefulWidget {
  const UserProfileWelcomeCard({super.key});

  @override
  State<UserProfileWelcomeCard> createState() => _UserProfileWelcomeCardState();
}

class _UserProfileWelcomeCardState extends State<UserProfileWelcomeCard> {
  String userName = '';
  String userRole = '';
  LoginedUserModel? user;
  bool _isNavigating = false;
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

        if (userData != null) {
          userName = userData.doshMangerName ?? userData.displayName ?? '';
          userRole = userData.role ?? '';
        } else {
          userName = '';
          userRole = '';
        }
      });
    }
  }

  void _handleProfileTap() async {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    if (user != null) {
      BlocProvider.of<ProfileCubit>(context).fetchUserProfile(context: context);
    } else {
      context.push(EndPoints.signInView);
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    });
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _handleProfileTap,
      child: ClipOval(
        child: Image.asset(
          AppAssets.defaultAvatar,
          height: 64,
          width: 64,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      textDirection: TextDirection.ltr,
      children: [
        Column(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              S.of(context).welcome,
              style: AppStyles.styleMedium14(
                context,
              ).copyWith(color: const Color(0xFFD1FAE5)),
            ),
            const SizedBox(height: 4),
            Text(
              userName.isEmpty ? 'ضيف' : userName,
              textDirection: TextDirection.ltr,
              style: AppStyles.styleBold18(
                context,
              ).copyWith(color: Colors.white),
            ),
          ],
        ),
        const SizedBox(width: 12),
        BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withAlpha(150),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 32,
                child: (state is ProfileLoading)
                    ? SizedBox(
                        width: 35,
                        height: 35,
                        child: CustomLoadingIndicator(),
                      )
                    : _buildProfileImage(),
              ),
            );
          },
          buildWhen: (previous, current) =>
              current is ProfileSuccess ||
              current is ProfileFailure ||
              current is ProfileLoading,
        ),
      ],
    );
  }
}
