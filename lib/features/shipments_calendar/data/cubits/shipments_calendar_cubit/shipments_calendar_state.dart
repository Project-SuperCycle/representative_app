import 'package:equatable/equatable.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';

sealed class ShipmentsCalendarState extends Equatable {
  const ShipmentsCalendarState();
}

final class ShipmentsCalendarInitial extends ShipmentsCalendarState {
  @override
  List<Object> get props => [];
}

// GET ALL SHIPMENTS
final class GetAllShipmentsLoading extends ShipmentsCalendarState {
  @override
  List<Object> get props => [];
}

final class GetAllShipmentsSuccess extends ShipmentsCalendarState {
  final List<ShipmentModel> shipments;
  const GetAllShipmentsSuccess({required this.shipments});
  @override
  List<Object> get props => [];
}

final class GetAllShipmentsFailure extends ShipmentsCalendarState {
  final String errorMessage;
  const GetAllShipmentsFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}

// GET SHIPMENT BY ID
final class GetShipmentLoading extends ShipmentsCalendarState {
  @override
  List<Object> get props => [];
}

final class GetShipmentSuccess extends ShipmentsCalendarState {
  final SingleShipmentModel shipment;
  const GetShipmentSuccess({required this.shipment});
  @override
  List<Object> get props => [];
}

final class GetShipmentFailure extends ShipmentsCalendarState {
  final String errorMessage;
  const GetShipmentFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}
