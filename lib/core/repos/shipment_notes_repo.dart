import 'package:dartz/dartz.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/models/create_notes_model.dart';

abstract class ShipmentNotesRepo {
  Future<Either<Failure, String>> addNotes({
    required CreateNotesModel notes,
    required String shipmentId,
  });

  Future<Either<Failure, List<String>>> getAllNotes({
    required String shipmentId,
  });
}
