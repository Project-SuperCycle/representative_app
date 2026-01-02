import 'package:equatable/equatable.dart';

sealed class AcceptShipmentState extends Equatable {
  const AcceptShipmentState();
}

final class AcceptRepShipmentInitial extends AcceptShipmentState {
  @override
  List<Object> get props => [];
}

// ACCEPT SHIPMENT
final class AcceptRepShipmentLoading extends AcceptShipmentState {
  @override
  List<Object> get props => [];
}

final class AcceptRepShipmentSuccess extends AcceptShipmentState {
  final String message;
  const AcceptRepShipmentSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class AcceptRepShipmentFailure extends AcceptShipmentState {
  final String errorMessage;
  const AcceptRepShipmentFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}
