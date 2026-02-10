import 'package:dartz/dartz.dart';
import 'package:representative_app/core/errors/failures.dart' show Failure;
import 'package:representative_app/features/home/data/models/dosh_data_model.dart'
    show DoshDataModel;
import 'package:representative_app/features/home/data/models/dosh_type_model.dart';
import 'package:representative_app/features/home/data/models/type_history_model.dart';
import 'package:representative_app/features/shipments_calendar/data/models/shipment_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<DoshTypeModel>>> fetchDoshTypes();

  Future<Either<Failure, List<TypeHistoryModel>>> fetchTypeHistory({
    required String typeId,
  });

  Future<Either<Failure, List<DoshDataModel>>> fetchTypesData();

  Future<Either<Failure, List<ShipmentModel>>> fetchTodayShipments({
    required Map<String, dynamic> query,
  });
}
