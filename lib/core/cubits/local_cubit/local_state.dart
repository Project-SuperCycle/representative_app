part of 'local_cubit.dart';

@immutable
sealed class LocalState {}

final class LocalInitial extends LocalState {}

class ChangeLocalState extends LocalState {
  final Locale locale;

  ChangeLocalState({required this.locale});
}
