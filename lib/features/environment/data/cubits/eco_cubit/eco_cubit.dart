import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/environment/data/models/trader_eco_info_model.dart';
import 'package:supercycle/features/environment/data/repos/environment_repo_imp.dart';

part 'eco_state.dart';

class EcoCubit extends Cubit<EcoState> {
  final EnvironmentRepoImp environmentRepoImp;
  EcoCubit({required this.environmentRepoImp}) : super(EcoInitial());

  Future<void> getTraderEcoInfo() async {
    emit(GetEcoDataLoading());
    try {
      var result = await environmentRepoImp.getTraderEcoInfo();
      result.fold(
        (failure) {
          emit(GetEcoDataFailure(errMessage: failure.errMessage));
        },
        (ecoInfoModel) {
          emit(GetEcoDataSuccess(ecoInfoModel: ecoInfoModel));
          // Store user globally
        },
      );
    } catch (error) {
      emit(GetEcoDataFailure(errMessage: error.toString()));
    }
  }
}
