import 'package:dartz/dartz.dart';
import 'package:representative_app/core/errors/failures.dart';
import 'package:representative_app/core/models/shipment/single_shipment_model.dart';
import 'package:representative_app/features/shipments_calendar/data/models/shipment_model.dart';

abstract class ShipmentsCalendarRepo {
  Future<Either<Failure, List<ShipmentModel>>> getAllShipments({
    required Map<String, dynamic> query,
  });

  Future<Either<Failure, List<ShipmentModel>>> getShipmentsHistory({
    required int page,
  });

  Future<Either<Failure, List<ShipmentModel>>> getAllRepShipments({
    required Map<String, dynamic> query,
  });

  Future<Either<Failure, SingleShipmentModel>> getShipmentById({
    required String shipmentId,
    required String type,
  });
}
