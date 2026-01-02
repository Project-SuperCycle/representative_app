import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/representative_shipment_details/data/cubits/accept_shipment_cubit/accept_shipment_state.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/accept_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_details/data/repos/rep_shipment_details_repo_imp.dart';

class AcceptShipmentCubit extends Cubit<AcceptShipmentState> {
  final RepShipmentDetailsRepoImp repShipmentDetailsRepo;
  AcceptShipmentCubit({required this.repShipmentDetailsRepo})
    : super(AcceptRepShipmentInitial());

  Future<void> acceptShipment({
    required AcceptShipmentModel acceptModel,
  }) async {
    emit(AcceptRepShipmentLoading());
    try {
      var result = await repShipmentDetailsRepo.acceptShipment(
        acceptModel: acceptModel,
      );
      result.fold(
        (failure) {
          emit(AcceptRepShipmentFailure(errorMessage: failure.errMessage));
        },
        (message) {
          emit(AcceptRepShipmentSuccess(message: message));
        },
      );
    } catch (error) {
      emit(AcceptRepShipmentFailure(errorMessage: error.toString()));
    }
  }
}
