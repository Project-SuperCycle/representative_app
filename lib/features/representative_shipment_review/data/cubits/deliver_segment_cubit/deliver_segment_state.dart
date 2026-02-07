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
  final String segmentId; // ✅ Added
  const DeliverSegmentLoading({required this.segmentId});

  @override
  List<Object> get props => [segmentId];
}

final class DeliverSegmentSuccess extends DeliverSegmentState {
  final String message;
  final String segmentId; // ✅ Added

  const DeliverSegmentSuccess({
    required this.message,
    required this.segmentId,
  });

  @override
  List<Object> get props => [message, segmentId];
}

final class DeliverSegmentFailure extends DeliverSegmentState {
  final String errorMessage;
  final String segmentId; // ✅ Added

  const DeliverSegmentFailure({
    required this.errorMessage,
    required this.segmentId,
  });

  @override
  List<Object> get props => [errorMessage, segmentId];
}