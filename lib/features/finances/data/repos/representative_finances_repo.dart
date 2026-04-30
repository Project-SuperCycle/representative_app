import 'package:dartz/dartz.dart';
import 'package:representative_app/core/errors/failures.dart';
import 'package:representative_app/features/finances/data/models/finance_payment_model.dart';

abstract class RepresentativeFinancesRepo {
  Future<Either<Failure, List<FinancePaymentModel>>> getRepresentativePayments({
    required int page,
  });
}
