import 'package:dartz/dartz.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/helpers/error_handler.dart';
import 'package:supercycle/core/services/api_endpoints.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/features/trader_shipment_details/data/repos/shipment_details_repo.dart';

class ShipmentDetailsRepoImp implements ShipmentDetailsRepo {
  final ApiServices apiServices;
  ShipmentDetailsRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, String>> cancelShipment({required String shipmentId}) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final response = await apiServices.post(
          endPoint: ApiEndpoints.cancelShipment.replaceFirst(
            '{id}',
            shipmentId,
          ),
          data: {},
        );
        return response['message'];
      },
      errorContext: 'cancel shipment',
    );
  }
}
