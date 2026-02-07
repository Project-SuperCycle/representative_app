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
  final String segmentId; // ✅ Added
  const WeighSegmentLoading({required this.segmentId});

  @override
  List<Object> get props => [segmentId];
}

final class WeighSegmentSuccess extends WeighSegmentState {
  final String message;
  final String segmentId; // ✅ Added

  const WeighSegmentSuccess({
    required this.message,
    required this.segmentId,
  });

  @override
  List<Object> get props => [message, segmentId];
}

final class WeighSegmentFailure extends WeighSegmentState {
  final String errorMessage;
  final String segmentId; // ✅ Added

  const WeighSegmentFailure({
    required this.errorMessage,
    required this.segmentId,
  });

  @override
  List<Object> get props => [errorMessage, segmentId];
}