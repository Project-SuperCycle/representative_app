import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/core/services/user_profile_services.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchUserProfile({required BuildContext context}) async {
    emit(ProfileLoading());
    try {
      await UserProfileService.navigateToProfileCached(context);
      emit(ProfileSuccess());
    } catch (error) {
      emit(ProfileFailure(message: error.toString()));
    }
  }
}
