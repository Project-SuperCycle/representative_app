sealed class ConfirmCashState {}

final class ConfirmCashInitial extends ConfirmCashState {}

final class ConfirmCashLoading extends ConfirmCashState {
  List<Object> get props => [];
}

final class ConfirmCashSuccess extends ConfirmCashState {
  final String message;
  ConfirmCashSuccess({required this.message});
  List<Object> get props => [];
}

final class ConfirmCashFailure extends ConfirmCashState {
  final String errorMessage;
  ConfirmCashFailure({required this.errorMessage});
  List<Object> get props => [];
}
