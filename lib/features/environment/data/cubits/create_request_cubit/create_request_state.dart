part of 'create_request_cubit.dart';

sealed class CreateRequestState extends Equatable {
  const CreateRequestState();
}

final class CreateRequestInitial extends CreateRequestState {
  @override
  List<Object> get props => [];
}

final class CreateRequestLoading extends CreateRequestState {
  @override
  List<Object> get props => [];
}

final class CreateRequestSuccess extends CreateRequestState {
  final String message;
  const CreateRequestSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class CreateRequestFailure extends CreateRequestState {
  final String errMessage;
  const CreateRequestFailure({required this.errMessage});
  @override
  List<Object> get props => [];
}
