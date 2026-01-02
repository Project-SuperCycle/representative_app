part of 'shipment_cubit.dart';

sealed class ShipmentState extends Equatable {
  const ShipmentState();
}

final class ShipmentInitial extends ShipmentState {
  @override
  List<Object> get props => [];
}

// UPDATE SHIPMENT
final class UpdateShipmentLoading extends ShipmentState {
  @override
  List<Object> get props => [];
}

final class UpdateShipmentSuccess extends ShipmentState {
  final String message;
  const UpdateShipmentSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class UpdateShipmentFailure extends ShipmentState {
  final String errorMessage;
  const UpdateShipmentFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}

// CANCEL SHIPMENT
final class CancelShipmentLoading extends ShipmentState {
  @override
  List<Object> get props => [];
}

final class CancelShipmentSuccess extends ShipmentState {
  final String message;
  const CancelShipmentSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class CancelShipmentFailure extends ShipmentState {
  final String errorMessage;
  const CancelShipmentFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}
