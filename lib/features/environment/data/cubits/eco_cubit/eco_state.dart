part of 'eco_cubit.dart';

@immutable
sealed class EcoState extends Equatable {
  const EcoState();
}

final class EcoInitial extends EcoState {
  const EcoInitial();
  @override
  List<Object> get props => [];
}

// FETCH ECO Data STATES
final class GetEcoDataLoading extends EcoState {
  @override
  List<Object> get props => [];
}

final class GetEcoDataSuccess extends EcoState {
  final TraderEcoInfoModel ecoInfoModel;
  const GetEcoDataSuccess({required this.ecoInfoModel});
  @override
  List<Object> get props => [];
}

final class GetEcoDataFailure extends EcoState {
  final String errMessage;
  const GetEcoDataFailure({required this.errMessage});
  @override
  List<Object> get props => [];
}
