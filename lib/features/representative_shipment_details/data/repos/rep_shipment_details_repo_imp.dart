import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/functions/shipment_manager.dart';
import 'package:supercycle/core/helpers/error_handler.dart';
import 'package:supercycle/core/services/api_endpoints.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/accept_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/reject_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/update_shipment_model.dart';
import 'package:supercycle/features/representative_shipment_details/data/repos/rep_shipment_details_repo.dart';

class RepShipmentDetailsRepoImp implements RepShipmentDetailsRepo {
  final ApiServices apiServices;

  RepShipmentDetailsRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, String>> acceptShipment({
    required AcceptShipmentModel acceptModel,
  }) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final formData = await _acceptFormData(acceptModel: acceptModel);

        final response = await apiServices.postFormData(
          endPoint: ApiEndpoints.acceptRepShipment.replaceFirst(
            '{id}',
            acceptModel.shipmentID,
          ),
          data: formData,
        );

        if (response['message'] == null) {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['message'];
      },
      errorContext: 'accept shipment',
    );
  }

  @override
  Future<Either<Failure, String>> rejectShipment({
    required RejectShipmentModel rejectModel,
  }) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final formData = await _rejectFormData(rejectModel: rejectModel);

        final response = await apiServices.postFormData(
          endPoint: ApiEndpoints.rejectRepShipment.replaceFirst(
            '{id}',
            rejectModel.shipmentID,
          ),
          data: formData,
        );

        if (response['message'] == null) {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['message'];
      },
      errorContext: 'reject shipment',
    );
  }

  @override
  Future<Either<Failure, String>> updateShipment({
    required UpdateShipmentModel updateModel,
  }) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final formData = await _updateFormData(updateModel: updateModel);

        final response = await apiServices.postFormData(
          endPoint: ApiEndpoints.updateRepShipment.replaceFirst(
            '{id}',
            updateModel.shipmentID,
          ),
          data: formData,
        );

        if (response['message'] == null) {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['message'];
      },
      errorContext: 'update shipment',
    );
  }

  // =======================
  // FormData Helpers
  // =======================

  Future<FormData> _acceptFormData({
    required AcceptShipmentModel acceptModel,
  }) async {
    final imagesFiles = await _mapImagesToMultipart(acceptModel.images);

    return FormData.fromMap({...acceptModel.toMap(), 'images': imagesFiles});
  }

  Future<FormData> _rejectFormData({
    required RejectShipmentModel rejectModel,
  }) async {
    final imagesFiles = await _mapImagesToMultipart(rejectModel.images);

    return FormData.fromMap({...rejectModel.toMap(), 'images': imagesFiles});
  }

  Future<FormData> _updateFormData({
    required UpdateShipmentModel updateModel,
  }) async {
    final imagesFiles = await _mapImagesToMultipart(updateModel.images);

    return FormData.fromMap({...updateModel.toMap(), 'images': imagesFiles});
  }

  Future<List<MultipartFile>> _mapImagesToMultipart(List<File> images) async {
    return ShipmentManager.createMultipartImages(images: images);
  }
}
