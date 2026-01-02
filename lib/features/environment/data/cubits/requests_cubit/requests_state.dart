part of 'requests_cubit.dart';

sealed class RequestsState extends Equatable {
  const RequestsState();
}

final class RequestsInitial extends RequestsState {
  @override
  List<Object> get props => [];
}

final class RequestsLoading extends RequestsState {
  @override
  List<Object> get props => [];
}

final class RequestsSuccess extends RequestsState {
  final List<EnvironmentalRedeemModel> requests;
  const RequestsSuccess({required this.requests});
  @override
  List<Object> get props => [];
}

final class RequestsFailure extends RequestsState {
  final String errMessage;
  const RequestsFailure({required this.errMessage});
  @override
  List<Object> get props => [];
}
