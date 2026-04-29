import 'package:representative_app/features/representative_shipment_details/data/models/shipment_cash_item.dart';

sealed class GetMealShipmentsState {}

final class GetMealShipmentsInitial extends GetMealShipmentsState {}

final class GetMealShipmentsLoading extends GetMealShipmentsState {
  List<Object> get props => [];
}

final class GetMealShipmentsSuccess extends GetMealShipmentsState {
  final List<ShipmentCashItem> shipments;
  GetMealShipmentsSuccess({required this.shipments});
  List<Object> get props => [];
}

final class GetMealShipmentsFailure extends GetMealShipmentsState {
  final String errorMessage;
  GetMealShipmentsFailure({required this.errorMessage});
  List<Object> get props => [];
}
