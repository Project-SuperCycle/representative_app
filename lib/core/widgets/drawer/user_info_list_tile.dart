import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_assets.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/home/data/managers/profile_cubit/profile_cubit.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';

class UserInfoListTile extends StatefulWidget {
  const UserInfoListTile({super.key});

  @override
  State<UserInfoListTile> createState() => _UserInfoListTileState();
}

class _UserInfoListTileState extends State<UserInfoListTile> {
  String userName = '';
  String businessType = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    LoginedUserModel? user = await StorageServices.getUserData();
    setState(() {
      if (user != null) {
        if (user.role == "representative") {
          userName = user.displayName ?? '';
          businessType = "مندوب";
        } else {
          userName = user.doshMangerName ?? '';
          businessType = user.rawBusinessType ?? '';
        }
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Card(
        color: const Color(0xFFFAFAFA),
        elevation: 0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomLoadingIndicator(),
          ),
        ),
      );
    }

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Card(
          color: const Color(0xFFFAFAFA),
          elevation: 0,
          child: Center(
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: (state is ProfileLoading)
                    ? SizedBox(
                        width: 35,
                        height: 35,
                        child: CustomLoadingIndicator(),
                      )
                    : GestureDetector(
                        onTap: () => (userName.isEmpty)
                            ? GoRouter.of(context).push(EndPoints.signInView)
                            : BlocProvider.of<ProfileCubit>(
                                context,
                              ).fetchUserProfile(context: context),
                        child: Image.asset(
                          AppAssets.defaultAvatar,
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
              title: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  userName,
                  style: AppStyles.styleSemiBold16(context),
                ),
              ),
              subtitle: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  businessType,
                  style: AppStyles.styleRegular12(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
