part of 'today_shipments_cubit.dart';

sealed class TodayShipmentsState extends Equatable {
  const TodayShipmentsState();
}

final class TodayShipmentsInitial extends TodayShipmentsState {
  @override
  List<Object> get props => [];
}

// FETCH TODAY SHIPMENTS STATES
final class TodayShipmentsLoading extends TodayShipmentsState {
  @override
  List<Object> get props => [];
}

final class TodayShipmentsSuccess extends TodayShipmentsState {
  final List<ShipmentModel> shipments;
  const TodayShipmentsSuccess({required this.shipments});
  @override
  List<Object> get props => [];
}

final class TodayShipmentsFailure extends TodayShipmentsState {
  final String message;
  const TodayShipmentsFailure({required this.message});
  @override
  List<Object> get props => [];
}
