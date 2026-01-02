part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

final class ProfileLoading extends ProfileState {
  @override
  List<Object> get props => [];
}

final class ProfileSuccess extends ProfileState {
  const ProfileSuccess();
  @override
  List<Object> get props => [];
}

final class ProfileFailure extends ProfileState {
  final String message;
  const ProfileFailure({required this.message});
  @override
  List<Object> get props => [];
}
