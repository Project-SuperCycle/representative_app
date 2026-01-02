import 'package:equatable/equatable.dart';

sealed class AddNotesState extends Equatable {
  const AddNotesState();
}

final class AddNotesInitial extends AddNotesState {
  @override
  List<Object> get props => [];
}

final class AddNotesLoading extends AddNotesState {
  @override
  List<Object> get props => [];
}

final class AddNotesSuccess extends AddNotesState {
  final String message;
  const AddNotesSuccess({required this.message});
  @override
  List<Object> get props => [];
}

final class AddNotesFailure extends AddNotesState {
  final String errorMessage;
  const AddNotesFailure({required this.errorMessage});
  @override
  List<Object> get props => [];
}
