import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/core/models/social_auth_request_model.dart';
import 'package:supercycle/core/models/social_auth_response_model.dart';
import 'package:supercycle/core/repos/social_auth_repo_imp.dart';

part 'social_auth_state.dart';

class SocialAuthCubit extends Cubit<SocialAuthState> {
  final SocialAuthRepoImp socialAuthRepo;
  SocialAuthCubit({required this.socialAuthRepo}) : super(SocialAuthInitial());

  Future<void> socialAuth(SocialAuthRequestModel credentials) async {
    emit(SocialAuthLoading());
    try {
      var result = await socialAuthRepo.socialSignup(credentials: credentials);
      result.fold(
        (failure) {
          emit(SocialAuthFailure(message: failure.errMessage));
        },
        (socialAuth) {
          emit(SocialAuthSuccess(socialAuth: socialAuth));
        },
      );
    } catch (error) {
      emit(SocialAuthFailure(message: error.toString()));
    }
  }
}
