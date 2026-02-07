import 'package:equatable/equatable.dart';

sealed class FailSegmentState extends Equatable {
  const FailSegmentState();
}

final class FailSegmentInitial extends FailSegmentState {
  @override
  List<Object> get props => [];
}

// FAIL SEGMENT
final class FailSegmentLoading extends FailSegmentState {
  final String segmentId; // ✅ Added
  const FailSegmentLoading({required this.segmentId});

  @override
  List<Object> get props => [segmentId];
}

final class FailSegmentSuccess extends FailSegmentState {
  final String message;
  final String segmentId; // ✅ Added

  const FailSegmentSuccess({
    required this.message,
    required this.segmentId,
  });

  @override
  List<Object> get props => [message, segmentId];
}

final class FailSegmentFailure extends FailSegmentState {
  final String errorMessage;
  final String segmentId; // ✅ Added

  const FailSegmentFailure({
    required this.errorMessage,
    required this.segmentId,
  });

  @override
  List<Object> get props => [errorMessage, segmentId];
}