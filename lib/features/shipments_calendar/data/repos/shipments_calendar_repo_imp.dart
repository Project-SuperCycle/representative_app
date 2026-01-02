import 'package:dartz/dartz.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/helpers/error_handler.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/core/services/api_endpoints.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';
import 'package:supercycle/features/shipments_calendar/data/repos/shipments_calendar_repo.dart';

class ShipmentsCalendarRepoImp implements ShipmentsCalendarRepo {
  final ApiServices apiServices;
  ShipmentsCalendarRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, List<ShipmentModel>>> getAllShipments({
    required Map<String, dynamic> query,
  }) {
    return ErrorHandler.handleApiCall<List<ShipmentModel>>(
      apiCall: () async {
        final response = await apiServices.get(
          endPoint: ApiEndpoints.getAllShipments,
          query: query,
        );

        final data = response['data'];
        List<dynamic> shipmentsData = _extractShipmentsData(data);

        return shipmentsData.map((e) => ShipmentModel.fromJson(e)).toList();
      },
      errorContext: 'get all shipments',
    );
  }

  @override
  Future<Either<Failure, List<ShipmentModel>>> getShipmentsHistory({
    required int page,
  }) {
    return ErrorHandler.handleApiCall<List<ShipmentModel>>(
      apiCall: () async {
        final response = await apiServices.get(
          endPoint: ApiEndpoints.getShipmentsHistory,
          query: {"page": page},
        );

        final data = response['result']['data'] as List<dynamic>;
        final meta = response['result']['totalPages'];
        StorageServices.storeData("totalShipmentsHistoryPages", meta);

        return data.map((e) => ShipmentModel.fromJson(e)).toList();
      },
      errorContext: 'get shipments history',
    );
  }

  @override
  Future<Either<Failure, List<ShipmentModel>>> getAllRepShipments({
    required Map<String, dynamic> query,
  }) {
    return ErrorHandler.handleApiCall<List<ShipmentModel>>(
      apiCall: () async {
        final response = await apiServices.get(
          endPoint: ApiEndpoints.getRepShipments,
          query: query,
        );

        final data = response['data'];
        List<dynamic> shipmentsData = _extractShipmentsData(data);

        return shipmentsData.map((e) => ShipmentModel.fromJson(e)).toList();
      },
      errorContext: 'get all rep shipments',
    );
  }

  @override
  Future<Either<Failure, SingleShipmentModel>> getShipmentById({
    required String shipmentId,
    required String type,
  }) {
    return ErrorHandler.handleApiCall<SingleShipmentModel>(
      apiCall: () async {
        final response = await apiServices.get(
          endPoint: ApiEndpoints.getShipmentById.replaceFirst(
            '{id}',
            shipmentId,
          ),
          query: {"type": type},
        );

        final data = response['data'];
        return SingleShipmentModel.fromJson(data);
      },
      errorContext: 'get shipment by id',
    );
  }

  /// Extract shipments list from API response (handles pagination / different keys)
  List<dynamic> _extractShipmentsData(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('data')) return data['data'] as List<dynamic>;
      if (data.containsKey('items')) return data['items'] as List<dynamic>;
      if (data.containsKey('shipments')) {
        return data['shipments'] as List<dynamic>;
      }
      throw ServerFailure('Unknown response structure', 422);
    } else if (data is List) {
      return data;
    } else {
      throw ServerFailure('Unexpected data type: ${data.runtimeType}', 422);
    }
  }
}
