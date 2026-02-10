part of 'today_shipments_cubit.dart';

abstract class TodayShipmentsState extends Equatable {
  const TodayShipmentsState();

  @override
  List<Object?> get props => [];
}

class TodayShipmentsInitial extends TodayShipmentsState {}

class TodayShipmentsLoading extends TodayShipmentsState {}

class TodayShipmentsSuccess extends TodayShipmentsState {
  final List<ShipmentModel> shipments;

  const TodayShipmentsSuccess({required this.shipments});

  @override
  List<Object?> get props => [shipments];
}

class TodayShipmentsEmpty extends TodayShipmentsState {}

class TodayShipmentsFailure extends TodayShipmentsState {
  final String message;

  const TodayShipmentsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}