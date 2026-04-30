import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:representative_app/features/finances/data/models/finance_payment_model.dart';
import 'package:representative_app/features/finances/data/repos/representative_finances_repo_imp.dart';

part 'get_finances_state.dart';

class GetFinancesCubit extends Cubit<GetFinancesState> {
  final RepresentativeFinancesRepoImp repo;

  GetFinancesCubit({required this.repo}) : super(GetFinancesInitial());

  Future<void> getRepFinances({required int page}) async {
    emit(GetFinancesLoading());
    try {
      var result = await repo.getRepresentativePayments(page: page);
      result.fold(
        (failure) {
          emit(GetFinancesFailure(errMessage: failure.errMessage));
        },
        (data) {
          emit(GetFinancesSuccess(finances: data));
        },
      );
    } catch (error) {
      emit(GetFinancesFailure(errMessage: error.toString()));
    }
  }
}
