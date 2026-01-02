import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_state.dart';
import 'package:supercycle/features/shipments_calendar/data/repos/shipments_calendar_repo_imp.dart';

class ShipmentsCalendarCubit extends Cubit<ShipmentsCalendarState> {
  final ShipmentsCalendarRepoImp shipmentsCalendarRepo;

  ShipmentsCalendarCubit({required this.shipmentsCalendarRepo})
    : super(ShipmentsCalendarInitial());

  Future<void> getAllShipments({required Map<String, dynamic> query}) async {
    emit(GetAllShipmentsLoading());
    try {
      var result = await shipmentsCalendarRepo.getAllShipments(query: query);
      result.fold(
        (failure) {
          emit(GetAllShipmentsFailure(errorMessage: failure.errMessage));
        },
        (shipments) {
          emit(GetAllShipmentsSuccess(shipments: shipments));
          // Store user globally
        },
      );
    } catch (error) {
      emit(GetAllShipmentsFailure(errorMessage: error.toString()));
    }
  }

  Future<void> getShipmentsHistory({required int page}) async {
    emit(GetAllShipmentsLoading());
    try {
      var result = await shipmentsCalendarRepo.getShipmentsHistory(page: page);
      result.fold(
        (failure) {
          emit(GetAllShipmentsFailure(errorMessage: failure.errMessage));
        },
        (shipments) {
          emit(GetAllShipmentsSuccess(shipments: shipments));
          // Store user globally
        },
      );
    } catch (error) {
      emit(GetAllShipmentsFailure(errorMessage: error.toString()));
    }
  }

  Future<void> getAllRepShipments({required Map<String, dynamic> query}) async {
    emit(GetAllShipmentsLoading());
    try {
      var result = await shipmentsCalendarRepo.getAllRepShipments(query: query);
      result.fold(
        (failure) {
          emit(GetAllShipmentsFailure(errorMessage: failure.errMessage));
        },
        (shipments) {
          emit(GetAllShipmentsSuccess(shipments: shipments));
          // Store user globally
        },
      );
    } catch (error) {
      emit(GetAllShipmentsFailure(errorMessage: error.toString()));
    }
  }

  Future<void> getShipmentById({
    required String shipmentId,
    required String type,
  }) async {
    emit(GetShipmentLoading());
    try {
      var result = await shipmentsCalendarRepo.getShipmentById(
        shipmentId: shipmentId,
        type: type,
      );
      result.fold(
        (failure) {
          emit(GetShipmentFailure(errorMessage: failure.errMessage));
        },
        (shipment) {
          emit(GetShipmentSuccess(shipment: shipment));
          // Store user globally
        },
      );
    } catch (error) {
      emit(GetShipmentFailure(errorMessage: error.toString()));
    }
  }
}
