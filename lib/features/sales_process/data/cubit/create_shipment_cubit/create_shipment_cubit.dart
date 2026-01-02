import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/sales_process/data/repos/sales_process_repo_imp.dart';

part 'create_shipment_state.dart';

class CreateShipmentCubit extends Cubit<CreateShipmentState> {
  final SalesProcessRepoImp shipmentReviewRepo;
  CreateShipmentCubit({required this.shipmentReviewRepo})
    : super(CreateShipmentInitial());

  Future<void> createShipment({required FormData shipment}) async {
    emit(CreateShipmentLoading());
    try {
      var result = await shipmentReviewRepo.createShipment(shipment: shipment);
      result.fold(
        (failure) {
          emit(CreateShipmentFailure(errorMessage: failure.errMessage));
        },
        (message) {
          emit(CreateShipmentSuccess(message: message));
          // Store user globally
        },
      );
    } catch (error) {
      emit(CreateShipmentFailure(errorMessage: error.toString()));
    }
  }
}
