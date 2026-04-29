import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:representative_app/core/errors/failures.dart';
import 'package:representative_app/features/representative_shipment_details/data/models/accept_shipment_model.dart';
import 'package:representative_app/features/representative_shipment_details/data/models/reject_shipment_model.dart';
import 'package:representative_app/features/representative_shipment_details/data/models/shipment_cash_item.dart';
import 'package:representative_app/features/representative_shipment_details/data/models/update_shipment_model.dart';

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

  // ─── Cash ──────────────────────────────────────────────────────────────────
  Future<Either<Failure, String>> confirmExternalCash({
    required String shipmentId,
    required File receiptImage,
  });

  Future<Either<Failure, String>> confirmMealCash({
    required List<String> shipments,
    required File receiptImage,
  });

  Future<Either<Failure, List<ShipmentCashItem>>> getMealShipments({
    required String shipmentId,
  });
}
