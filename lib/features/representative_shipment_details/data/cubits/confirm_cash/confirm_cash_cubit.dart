import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/features/representative_shipment_details/data/cubits/confirm_cash/confirm_cash_state.dart';
import 'package:representative_app/features/representative_shipment_details/data/repos/rep_shipment_details_repo_imp.dart';

class ConfirmCashCubit extends Cubit<ConfirmCashState> {
  final RepShipmentDetailsRepoImp repo;
  ConfirmCashCubit({required this.repo}) : super(ConfirmCashInitial());

  Future<void> confirmExternalCash({
    required String shipmentId,
    required File image,
  }) async {
    emit(ConfirmCashLoading());
    try {
      var result = await repo.confirmExternalCash(
        shipmentId: shipmentId,
        receiptImage: image,
      );
      result.fold(
        (failure) {
          emit(ConfirmCashFailure(errorMessage: failure.errMessage));
        },
        (data) {
          emit(ConfirmCashSuccess(message: data));
        },
      );
    } catch (error) {
      emit(ConfirmCashFailure(errorMessage: error.toString()));
    }
  }

  Future<void> confirmMealCash({
    required List<String> shipments,
    required File image,
  }) async {
    emit(ConfirmCashLoading());
    try {
      var result = await repo.confirmMealCash(
        shipments: shipments,
        receiptImage: image,
      );
      result.fold(
        (failure) {
          emit(ConfirmCashFailure(errorMessage: failure.errMessage));
        },
        (data) {
          emit(ConfirmCashSuccess(message: data));
        },
      );
    } catch (error) {
      emit(ConfirmCashFailure(errorMessage: error.toString()));
    }
  }
}
