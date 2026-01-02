import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/helpers/error_handler.dart';
import 'package:supercycle/core/services/api_endpoints.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/core/services/user_profile_services.dart';
import 'package:supercycle/features/sales_process/data/repos/sales_process_repo.dart';

class SalesProcessRepoImp implements SalesProcessRepo {
  final ApiServices apiServices;

  SalesProcessRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, String>> createShipment({required FormData shipment}) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final response = await apiServices.postFormData(
          endPoint: ApiEndpoints.createShipment,
          data: shipment,
        );

        if (response['message'] == null) {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        // Side effect after successful shipment creation
        await UserProfileService.fetchAndStoreUserProfile();

        return response['message'];
      },
      errorContext: 'create shipment',
    );
  }
}
