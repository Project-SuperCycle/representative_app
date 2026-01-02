part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

// FETCH DOSH TYPES STATES
final class FetchDoshTypesLoading extends HomeState {
  @override
  List<Object> get props => [];
}

final class FetchDoshTypesSuccess extends HomeState {
  final List<DoshTypeModel> doshTypes;
  const FetchDoshTypesSuccess({required this.doshTypes});
  @override
  List<Object> get props => [];
}

final class FetchDoshTypesFailure extends HomeState {
  final String message;
  const FetchDoshTypesFailure({required this.message});
  @override
  List<Object> get props => [];
}

// FETCH TYPE HISTORY STATES
final class FetchTypeHistoryLoading extends HomeState {
  @override
  List<Object> get props => [];
}

final class FetchTypeHistorySuccess extends HomeState {
  final List<TypeHistoryModel> history;
  const FetchTypeHistorySuccess({required this.history});
  @override
  List<Object> get props => [];
}

final class FetchTypeHistoryFailure extends HomeState {
  final String message;
  const FetchTypeHistoryFailure({required this.message});
  @override
  List<Object> get props => [];
}

// FETCH TYPES DATA STATES
final class FetchTypesDataLoading extends HomeState {
  @override
  List<Object> get props => [];
}

final class FetchTypesDataSuccess extends HomeState {
  final List<DoshDataModel> doshData;
  const FetchTypesDataSuccess({required this.doshData});
  @override
  List<Object> get props => [];
}

final class FetchTypesDataFailure extends HomeState {
  final String message;
  const FetchTypesDataFailure({required this.message});
  @override
  List<Object> get props => [];
}
