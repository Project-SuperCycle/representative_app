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
  @override
  List<Object> get props => [];
}

final class FailSegmentSuccess extends FailSegmentState {
  final String message;
  const FailSegmentSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class FailSegmentFailure extends FailSegmentState {
  final String errorMessage;
  const FailSegmentFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}
