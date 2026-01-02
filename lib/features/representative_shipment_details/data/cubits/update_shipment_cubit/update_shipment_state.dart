import 'package:equatable/equatable.dart';

sealed class UpdateShipmentState extends Equatable {
  const UpdateShipmentState();
}

final class UpdateRepShipmentInitial extends UpdateShipmentState {
  @override
  List<Object> get props => [];
}

// UPDATE SHIPMENT
final class UpdateRepShipmentLoading extends UpdateShipmentState {
  @override
  List<Object> get props => [];
}

final class UpdateRepShipmentSuccess extends UpdateShipmentState {
  final String message;
  const UpdateRepShipmentSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class UpdateRepShipmentFailure extends UpdateShipmentState {
  final String errorMessage;
  const UpdateRepShipmentFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}
