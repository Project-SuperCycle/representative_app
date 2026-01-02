import 'package:equatable/equatable.dart';

sealed class DeliverSegmentState extends Equatable {
  const DeliverSegmentState();
}

final class DeliverSegmentInitial extends DeliverSegmentState {
  @override
  List<Object> get props => [];
}

// DELIVER SEGMENT
final class DeliverSegmentLoading extends DeliverSegmentState {
  @override
  List<Object> get props => [];
}

final class DeliverSegmentSuccess extends DeliverSegmentState {
  final String message;
  const DeliverSegmentSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class DeliverSegmentFailure extends DeliverSegmentState {
  final String errorMessage;
  const DeliverSegmentFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}
