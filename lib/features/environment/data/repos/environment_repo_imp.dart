import 'package:dartz/dartz.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/helpers/error_handler.dart';
import 'package:supercycle/core/services/api_endpoints.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/features/environment/data/models/trader_eco_info_model.dart';
import 'package:supercycle/features/environment/data/repos/environment_repo.dart';
import 'package:supercycle/features/environment/data/models/environmental_redeem_model.dart';

class EnvironmentRepoImp implements EnvironmentRepo {
  final ApiServices apiServices;

  EnvironmentRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, TraderEcoInfoModel>> getTraderEcoInfo() {
    return ErrorHandler.handleApiResponse<TraderEcoInfoModel>(
      apiCall: () => apiServices.get(endPoint: ApiEndpoints.getTraderEcoInfo),
      errorContext: 'get trader eco info',
      responseParser: (response) {
        final data = response['data'];
        return TraderEcoInfoModel.fromJson(data);
      },
    );
  }

  @override
  Future<Either<Failure, String>> createTraderEcoRequest({
    required int quantity,
  }) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final response = await apiServices.post(
          endPoint: ApiEndpoints.createTraderEcoRequest,
          data: {
            "rewardItemId": "68f39e4ab208ebb112d58b89",
            "quantity": quantity,
          },
        );

        if (response['message'] == null) {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['message'];
      },
      errorContext: 'create trader eco request',
    );
  }

  @override
  Future<Either<Failure, List<EnvironmentalRedeemModel>>> getTraderEcoRequests({
    required int page,
  }) {
    return ErrorHandler.handleApiResponse<List<EnvironmentalRedeemModel>>(
      apiCall: () => apiServices.get(
        endPoint: ApiEndpoints.getTraderEcoRequests,
        query: {"page": page},
      ),
      errorContext: 'get trader eco requests',
      responseParser: (response) {
        final List data = response['data'];
        final int meta = response['meta']['totalPages'];
        StorageServices.storeData("totalRequests", meta);
        return data.map((e) => EnvironmentalRedeemModel.fromJson(e)).toList();
      },
    );
  }
}
