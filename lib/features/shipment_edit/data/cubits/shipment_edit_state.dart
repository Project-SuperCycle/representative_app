part of 'shipment_edit_cubit.dart';

sealed class ShipmentEditState extends Equatable {
  const ShipmentEditState();
}

final class ShipmentEditInitial extends ShipmentEditState {
  @override
  List<Object> get props => [];
}

final class EditShipmentLoading extends ShipmentEditState {
  @override
  List<Object> get props => [];
}

final class EditShipmentSuccess extends ShipmentEditState {
  final String message;
  const EditShipmentSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class EditShipmentFailure extends ShipmentEditState {
  final String errorMessage;
  const EditShipmentFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}
