import 'package:dartz/dartz.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/accept_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/reject_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/update_shipment_model.dart';

abstract class RepShipmentDetailsRepo {
  Future<Either<Failure, String>> acceptShipment({
    required AcceptShipmentModel acceptModel,
  });

  Future<Either<Failure, String>> rejectShipment({
    required RejectShipmentModel rejectModel,
  });

  Future<Either<Failure, String>> updateShipment({
    required UpdateShipmentModel updateModel,
  });
}
