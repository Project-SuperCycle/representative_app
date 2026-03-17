import 'package:equatable/equatable.dart';

sealed class DeleteNotificationState extends Equatable {
  const DeleteNotificationState();
}

final class DeleteNotificationInitial extends DeleteNotificationState {
  @override
  List<Object> get props => [];
}

// GET ALL SHIPMENTS
final class DeleteNotificationLoading extends DeleteNotificationState {
  @override
  List<Object> get props => [];
}

final class DeleteNotificationSuccess extends DeleteNotificationState {
  final String message;

  final String id;

  const DeleteNotificationSuccess({required this.message, required this.id});

  @override
  List<Object> get props => [];
}

final class DeleteNotificationFailure extends DeleteNotificationState {
  final String errorMessage;

  const DeleteNotificationFailure({required this.errorMessage});

  @override
  List<Object> get props => [];
}
