import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/shipment_edit/data/repos/shipment_edit_repo_imp.dart';

part 'shipment_edit_state.dart';

class ShipmentEditCubit extends Cubit<ShipmentEditState> {
  final ShipmentEditRepoImp shipmentEditRepo;

  ShipmentEditCubit({required this.shipmentEditRepo})
    : super(ShipmentEditInitial());

  Future<void> editShipment({
    required FormData shipment,
    required String id,
  }) async {
    emit(EditShipmentLoading());
    try {
      var result = await shipmentEditRepo.editShipment(
        shipment: shipment,
        id: id,
      );
      result.fold(
        (failure) {
          emit(EditShipmentFailure(errorMessage: failure.errMessage));
        },
        (message) {
          emit(EditShipmentSuccess(message: message));
        },
      );
    } catch (error) {
      emit(EditShipmentFailure(errorMessage: error.toString()));
    }
  }
}
