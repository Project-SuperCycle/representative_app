import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:representative_app/core/errors/failures.dart';
import 'package:representative_app/core/helpers/error_handler.dart';
import 'package:representative_app/core/services/api_endpoints.dart';
import 'package:representative_app/core/services/api_services.dart';
import 'package:representative_app/features/shipment_edit/data/repos/shipment_edit_repo.dart';

class ShipmentEditRepoImp implements ShipmentEditRepo {
  final ApiServices apiServices;

  ShipmentEditRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, String>> editShipment({
    required FormData shipment,
    required String id,
  }) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final response = await apiServices.patchFormData(
          endPoint: ApiEndpoints.editShipment.replaceFirst('{id}', id),
          data: shipment,
        );

        if (response['message'] == null) {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['message'];
      },
      errorContext: 'edit shipment',
    );
  }
}
