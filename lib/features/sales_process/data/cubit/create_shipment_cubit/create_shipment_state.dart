part of 'create_shipment_cubit.dart';

sealed class CreateShipmentState extends Equatable {
  const CreateShipmentState();
}

final class CreateShipmentInitial extends CreateShipmentState {
  @override
  List<Object> get props => [];
}

final class CreateShipmentLoading extends CreateShipmentState {
  @override
  List<Object> get props => [];
}

final class CreateShipmentSuccess extends CreateShipmentState {
  final String message;
  const CreateShipmentSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class CreateShipmentFailure extends CreateShipmentState {
  final String errorMessage;
  const CreateShipmentFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}
