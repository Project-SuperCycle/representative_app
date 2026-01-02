import 'package:equatable/equatable.dart';

sealed class WeighSegmentState extends Equatable {
  const WeighSegmentState();
}

final class WeighSegmentInitial extends WeighSegmentState {
  @override
  List<Object> get props => [];
}

// WEIGH SEGMENT
final class WeighSegmentLoading extends WeighSegmentState {
  @override
  List<Object> get props => [];
}

final class WeighSegmentSuccess extends WeighSegmentState {
  final String message;
  const WeighSegmentSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class WeighSegmentFailure extends WeighSegmentState {
  final String errorMessage;
  const WeighSegmentFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}
