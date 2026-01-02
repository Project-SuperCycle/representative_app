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
  @override
  List<Object> get props => [];
}

final class StartSegmentSuccess extends StartSegmentState {
  final String message;
  const StartSegmentSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class StartSegmentFailure extends StartSegmentState {
  final String errorMessage;
  const StartSegmentFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}
