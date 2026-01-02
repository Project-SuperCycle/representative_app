import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/environment/data/repos/environment_repo_imp.dart';

part 'create_request_state.dart';

class CreateRequestCubit extends Cubit<CreateRequestState> {
  final EnvironmentRepoImp environmentRepoImp;
  CreateRequestCubit({required this.environmentRepoImp})
    : super(CreateRequestInitial());

  Future<void> createTraderEcoRequest({required int quantity}) async {
    emit(CreateRequestLoading());
    try {
      var result = await environmentRepoImp.createTraderEcoRequest(
        quantity: quantity,
      );
      result.fold(
        (failure) {
          emit(CreateRequestFailure(errMessage: failure.errMessage));
        },
        (message) {
          emit(CreateRequestSuccess(message: message));
          // Store user globally
        },
      );
    } catch (error) {
      emit(CreateRequestFailure(errMessage: error.toString()));
    }
  }
}
