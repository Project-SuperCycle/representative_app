import 'package:dartz/dartz.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/helpers/error_handler.dart';
import 'package:supercycle/core/services/api_endpoints.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/core/models/create_notes_model.dart';
import 'package:supercycle/features/trader_shipment_details/data/repos/shipment_notes_repo.dart';

class ShipmentNotesRepoImp implements ShipmentNotesRepo {
  final ApiServices apiServices;
  ShipmentNotesRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, String>> addNotes({
    required CreateNotesModel notes,
    required String shipmentId,
  }) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final response = await apiServices.post(
          endPoint: ApiEndpoints.addNotes.replaceFirst('{id}', shipmentId),
          data: notes.toJson(),
        );
        return response['message'];
      },
      errorContext: 'add shipment notes',
    );
  }

  @override
  Future<Either<Failure, List<String>>> getAllNotes({
    required String shipmentId,
  }) {
    return ErrorHandler.handleApiCall<List<String>>(
      apiCall: () async {
        final response = await apiServices.get(
          endPoint: ApiEndpoints.getAllNotes.replaceFirst('{id}', shipmentId),
        );
        var data = response['data'] as List<dynamic>;
        return data.map<String>((note) => note['content'].toString()).toList();
      },
      errorContext: 'get shipment notes',
    );
  }
}
