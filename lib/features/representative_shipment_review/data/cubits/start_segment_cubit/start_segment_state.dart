import 'package:equatable/equatable.dart';

sealed class StartSegmentState extends Equatable {
  const StartSegmentState();
}

final class StartSegmentInitial extends StartSegmentState {
  @override
  List<Object> get props => [];
}

// START SEGMENT
final class StartSegmentLoading extends StartSegmentState {
  final String segmentId; // ✅ Added
  const StartSegmentLoading({required this.segmentId});

  @override
  List<Object> get props => [segmentId];
}

final class StartSegmentSuccess extends StartSegmentState {
  final String message;
  final String segmentId; // ✅ Added

  const StartSegmentSuccess({
    required this.message,
    required this.segmentId,
  });

  @override
  List<Object> get props => [message, segmentId];
}

final class StartSegmentFailure extends StartSegmentState {
  final String errorMessage;
  final String segmentId; // ✅ Added

  const StartSegmentFailure({
    required this.errorMessage,
    required this.segmentId,
  });

  @override
  List<Object> get props => [errorMessage, segmentId];
}