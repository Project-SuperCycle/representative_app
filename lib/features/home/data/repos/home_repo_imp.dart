import 'package:dartz/dartz.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/helpers/error_handler.dart';
import 'package:supercycle/core/services/api_endpoints.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/features/home/data/models/dosh_data_model.dart';
import 'package:supercycle/features/home/data/models/dosh_type_model.dart';
import 'package:supercycle/features/home/data/models/type_history_model.dart';
import 'package:supercycle/features/home/data/repos/home_repo.dart';
import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';

class HomeRepoImp implements HomeRepo {
  final ApiServices apiServices;

  HomeRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, List<DoshTypeModel>>> fetchDoshTypes() {
    return ErrorHandler.handleApiResponse<List<DoshTypeModel>>(
      apiCall: () => apiServices.get(endPoint: ApiEndpoints.doshPricesCurrent),
      errorContext: 'fetch dosh types',
      responseParser: (response) {
        final List data = response['data'];
        return data.map((e) => DoshTypeModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, List<TypeHistoryModel>>> fetchTypeHistory({
    required String typeId,
  }) {
    return ErrorHandler.handleApiResponse<List<TypeHistoryModel>>(
      apiCall: () => apiServices.get(
        endPoint: ApiEndpoints.doshPricesHistory,
        query: {"typeId": typeId},
      ),
      errorContext: 'fetch type history',
      responseParser: (response) {
        final List history = response['data']?['history'];
        return history.map((e) => TypeHistoryModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, List<DoshDataModel>>> fetchTypesData() {
    return ErrorHandler.handleApiResponse<List<DoshDataModel>>(
      apiCall: () => apiServices.get(endPoint: ApiEndpoints.doshTypesData),
      errorContext: 'fetch dosh types data',
      responseParser: (response) {
        final List data = response['data'];
        return data.map((e) => DoshDataModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, List<ShipmentModel>>> fetchTodayShipmets({
    required Map<String, dynamic> query,
  }) {
    return ErrorHandler.handleApiResponse<List<ShipmentModel>>(
      apiCall: () =>
          apiServices.get(endPoint: ApiEndpoints.getAllShipments, query: query),
      errorContext: 'fetch today shipments',
      responseParser: (response) {
        final List data = response['data'];
        final shipments = data.map((e) => ShipmentModel.fromJson(e)).toList();

        return _getTodayShipments(shipments);
      },
    );
  }

  /// 🔹 فلترة شحنات اليوم فقط
  List<ShipmentModel> _getTodayShipments(List<ShipmentModel> shipments) {
    final now = DateTime.now();

    return shipments.where((shipment) {
      final pickupDate = shipment.requestedPickupAt;

      return pickupDate.year == now.year &&
          pickupDate.month == now.month &&
          pickupDate.day == now.day;
    }).toList();
  }
}
