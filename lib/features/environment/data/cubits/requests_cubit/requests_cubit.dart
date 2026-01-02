import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/environment/data/repos/environment_repo_imp.dart';
import 'package:supercycle/features/environment/data/models/environmental_redeem_model.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  final EnvironmentRepoImp environmentRepoImp;

  RequestsCubit({required this.environmentRepoImp}) : super(RequestsInitial());

  Future<void> getTraderEcoRequests({int page = 1}) async {
    emit(RequestsLoading());
    try {
      var result = await environmentRepoImp.getTraderEcoRequests(page: page);
      result.fold(
        (failure) {
          emit(RequestsFailure(errMessage: failure.errMessage));
        },
        (requests) {
          emit(RequestsSuccess(requests: requests));
        },
      );
    } catch (error) {
      emit(RequestsFailure(errMessage: error.toString()));
    }
  }
}
