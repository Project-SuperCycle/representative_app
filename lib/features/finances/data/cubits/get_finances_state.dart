part of 'get_finances_cubit.dart';

@immutable
sealed class GetFinancesState {}

final class GetFinancesInitial extends GetFinancesState {}

final class GetFinancesLoading extends GetFinancesState {}

final class GetFinancesSuccess extends GetFinancesState {
  final List<FinancePaymentModel> finances;

  GetFinancesSuccess({required this.finances});
}

final class GetFinancesFailure extends GetFinancesState {
  final String errMessage;

  GetFinancesFailure({required this.errMessage});
}
