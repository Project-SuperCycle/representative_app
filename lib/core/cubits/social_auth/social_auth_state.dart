part of 'social_auth_cubit.dart';

sealed class SocialAuthState extends Equatable {
  const SocialAuthState();
}

final class SocialAuthInitial extends SocialAuthState {
  @override
  List<Object> get props => [];
}

final class SocialAuthLoading extends SocialAuthState {
  @override
  List<Object> get props => [];
}

final class SocialAuthSuccess extends SocialAuthState {
  final SocialAuthResponseModel socialAuth;
  const SocialAuthSuccess({required this.socialAuth});
  @override
  List<Object> get props => [];
}

final class SocialAuthFailure extends SocialAuthState {
  final String message;
  const SocialAuthFailure({required this.message});
  @override
  List<Object> get props => [];
}
