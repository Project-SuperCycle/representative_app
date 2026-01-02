import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/representative_shipment_details/data/cubits/update_shipment_cubit/update_shipment_state.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/update_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_details/data/repos/rep_shipment_details_repo_imp.dart';

class UpdateShipmentCubit extends Cubit<UpdateShipmentState> {
  final RepShipmentDetailsRepoImp repShipmentDetailsRepo;
  UpdateShipmentCubit({required this.repShipmentDetailsRepo})
    : super(UpdateRepShipmentInitial());

  Future<void> updateShipmet({required UpdateShipmentModel updateModel}) async {
    emit(UpdateRepShipmentLoading());
    try {
      var result = await repShipmentDetailsRepo.updateShipment(
        updateModel: updateModel,
      );
      result.fold(
        (failure) {
          emit(UpdateRepShipmentFailure(errorMessage: failure.errMessage));
        },
        (message) {
          emit(UpdateRepShipmentSuccess(message: message));
        },
      );
    } catch (error) {
      emit(UpdateRepShipmentFailure(errorMessage: error.toString()));
    }
  }
}
