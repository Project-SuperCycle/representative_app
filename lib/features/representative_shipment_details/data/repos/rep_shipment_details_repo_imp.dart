import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:representative_app/core/errors/failures.dart';
import 'package:representative_app/core/functions/shipment_manager.dart';
import 'package:representative_app/core/helpers/error_handler.dart';
import 'package:representative_app/core/services/api_endpoints.dart';
import 'package:representative_app/core/services/api_services.dart';
import 'package:representative_app/features/representative_shipment_details/data/models/accept_shipment_model.dart';
import 'package:representative_app/features/representative_shipment_details/data/models/reject_shipment_model.dart';
import 'package:representative_app/features/representative_shipment_details/data/models/shipment_cash_item.dart';
import 'package:representative_app/features/representative_shipment_details/data/models/update_shipment_model.dart';
import 'package:representative_app/features/representative_shipment_details/data/repos/rep_shipment_details_repo.dart';

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

  @override
  Future<Either<Failure, String>> confirmExternalCash({
    required String shipmentId,
    required File receiptImage,
  }) async {
    // TODO: implement confirmExternalCash
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final formData = await _confirmExternalCashFormData(
          receiptImage: receiptImage,
        );

        final response = await apiServices.postFormData(
          endPoint: ApiEndpoints.financeExternalCash.replaceFirst(
            '{id}',
            shipmentId,
          ),
          data: formData,
        );

        if (response['status'] != 'success') {
          if (response['message'] == null) {
            throw ServerFailure('Invalid response: Missing message', 422);
          }
          throw ServerFailure(response['message'], 422);
        }

        return 'تم استلام النقدية بنجاح';
      },
      errorContext: 'confirm external cash',
    );
  }

  @override
  Future<Either<Failure, String>> confirmMealCash({
    required List<String> shipments,
    required File receiptImage,
  }) async {
    // TODO: implement confirmMealCash
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final formData = await _confirmMealCashFormData(
          shipments: shipments,
          receiptImage: receiptImage,
        );

        final response = await apiServices.postFormData(
          endPoint: ApiEndpoints.financeMealCash,
          data: formData,
        );

        if (response['status'] != 'success') {
          if (response['message'] == null) {
            throw ServerFailure('Invalid response: Missing message', 422);
          }
          throw ServerFailure(response['message'], 422);
        }

        return 'تم استلام النقدية بنجاح';
      },
      errorContext: 'confirm meal cash',
    );
  }

  @override
  Future<Either<Failure, List<ShipmentCashItem>>> getMealShipments({
    required String shipmentId,
  }) async {
    // TODO: implement getMealShipments
    return ErrorHandler.handleApiCall<List<ShipmentCashItem>>(
      apiCall: () async {
        final response = await apiServices.get(
          endPoint: ApiEndpoints.financeMealShipments,
        );

        final data = response['data']['eligibleShipments'];

        return data.map((e) => ShipmentCashItem.fromJson(e)).toList();
      },
      errorContext: 'get all shipments',
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

  Future<FormData> _confirmExternalCashFormData({
    required File receiptImage,
  }) async {
    final imagesFiles = await _mapImagesToMultipart([receiptImage]);

    return FormData.fromMap({'paymentProof': imagesFiles.first});
  }

  Future<FormData> _confirmMealCashFormData({
    required List<String> shipments,
    required File receiptImage,
  }) async {
    final imagesFiles = await _mapImagesToMultipart([receiptImage]);

    return FormData.fromMap({
      'shipmentIds': shipments,
      'images': imagesFiles.first,
    });
  }
}
