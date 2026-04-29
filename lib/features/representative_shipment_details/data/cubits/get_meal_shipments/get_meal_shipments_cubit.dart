import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/features/representative_shipment_details/data/cubits/get_meal_shipments/get_meal_shipments_state.dart';
import 'package:representative_app/features/representative_shipment_details/data/repos/rep_shipment_details_repo_imp.dart';

class GetMealShipmentsCubit extends Cubit<GetMealShipmentsState> {
  final RepShipmentDetailsRepoImp repo;
  GetMealShipmentsCubit({required this.repo})
    : super(GetMealShipmentsInitial());

  Future<void> getMealShipments({required String shipmentId}) async {
    emit(GetMealShipmentsLoading());
    try {
      var result = await repo.getMealShipments(shipmentId: shipmentId);
      result.fold(
        (failure) {
          emit(GetMealShipmentsFailure(errorMessage: failure.errMessage));
        },
        (data) {
          emit(GetMealShipmentsSuccess(shipments: data));
        },
      );
    } catch (error) {
      emit(GetMealShipmentsFailure(errorMessage: error.toString()));
    }
  }
}
