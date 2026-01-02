import 'package:equatable/equatable.dart';

sealed class RejectShipmentState extends Equatable {
  const RejectShipmentState();
}

final class RejectRepShipmentInitial extends RejectShipmentState {
  @override
  List<Object> get props => [];
}

// REJECT SHIPMENT
final class RejectRepShipmentLoading extends RejectShipmentState {
  @override
  List<Object> get props => [];
}

final class RejectRepShipmentSuccess extends RejectShipmentState {
  final String message;
  const RejectRepShipmentSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class RejectRepShipmentFailure extends RejectShipmentState {
  final String errorMessage;
  const RejectRepShipmentFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}
