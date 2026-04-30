import 'package:dartz/dartz.dart';
import 'package:representative_app/core/constants/storage_constants.dart';
import 'package:representative_app/core/errors/failures.dart';
import 'package:representative_app/core/helpers/error_handler.dart';
import 'package:representative_app/core/services/api_endpoints.dart';
import 'package:representative_app/core/services/api_services.dart';
import 'package:representative_app/core/services/storage_services.dart';
import 'package:representative_app/features/finances/data/models/finance_payment_model.dart';
import 'package:representative_app/features/finances/data/repos/representative_finances_repo.dart';

class RepresentativeFinancesRepoImp implements RepresentativeFinancesRepo {
  final ApiServices apiServices;

  RepresentativeFinancesRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, List<FinancePaymentModel>>> getRepresentativePayments({
    required int page,
  }) async {
    // TODO: implement getMealShipments
    return ErrorHandler.handleApiCall<List<FinancePaymentModel>>(
      apiCall: () async {
        final response = await apiServices.get(
          endPoint: ApiEndpoints.repFinances,
          query: {'page': page},
        );

        final List data = response['data'];
        final int meta = response['meta']['totalPages'];
        StorageServices.storeData(StorageConstants.FINANCES_PAGES, meta);
        return data.map((e) => FinancePaymentModel.fromJson(e)).toList();
      },
      errorContext: 'get all finances',
    );
  }
}
