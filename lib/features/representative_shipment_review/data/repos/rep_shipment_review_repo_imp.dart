import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/functions/shipment_manager.dart';
import 'package:supercycle/core/helpers/error_handler.dart';
import 'package:supercycle/core/services/api_endpoints.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/deliver_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/fail_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/start_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/weigh_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/repos/rep_shipment_review_repo.dart';

class RepShipmentReviewRepoImp implements RepShipmentReviewRepo {
  final ApiServices apiServices;

  RepShipmentReviewRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, String>> startSegment({
    required StartSegmentModel startModel,
  }) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final response = await apiServices.post(
          endPoint: ApiEndpoints.startShipmentSegment
              .replaceFirst('{shipmentId}', startModel.shipmentID)
              .replaceFirst('{segmentId}', startModel.segmentID),
          data: {},
        );

        if (response['message'] == null) {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['message'];
      },
      errorContext: 'start shipment segment',
    );
  }

  @override
  Future<Either<Failure, String>> weighSegment({
    required WeighSegmentModel weighModel,
  }) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final formData = await _weighFormData(weighModel: weighModel);

        final response = await apiServices.postFormData(
          endPoint: ApiEndpoints.weighShipmentSegment
              .replaceFirst('{shipmentId}', weighModel.shipmentID)
              .replaceFirst('{segmentId}', weighModel.segmentID),
          data: formData,
        );

        if (response['message'] == null) {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['message'];
      },
      errorContext: 'weigh shipment segment',
    );
  }

  @override
  Future<Either<Failure, String>> deliverSegment({
    required DeliverSegmentModel deliverModel,
  }) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final formData = await _deliverFormData(deliverModel: deliverModel);

        final response = await apiServices.postFormData(
          endPoint: ApiEndpoints.deliverShipmentSegment
              .replaceFirst('{shipmentId}', deliverModel.shipmentID)
              .replaceFirst('{segmentId}', deliverModel.segmentID),
          data: formData,
        );

        if (response['message'] == null) {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['message'];
      },
      errorContext: 'deliver shipment segment',
    );
  }

  @override
  Future<Either<Failure, String>> failSegment({
    required FailSegmentModel failModel,
  }) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final formData = await _failFormData(failModel: failModel);

        final response = await apiServices.postFormData(
          endPoint: ApiEndpoints.failShipmentSegment
              .replaceFirst('{shipmentId}', failModel.shipmentID)
              .replaceFirst('{segmentId}', failModel.segmentID),
          data: formData,
        );

        if (response['message'] == null) {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['message'];
      },
      errorContext: 'fail shipment segment',
    );
  }

  // =======================
  // FormData Helpers
  // =======================

  Future<FormData> _weighFormData({
    required WeighSegmentModel weighModel,
  }) async {
    final imagesFiles = await _mapImagesToMultipart(weighModel.images);

    return FormData.fromMap({...weighModel.toMap(), 'images': imagesFiles});
  }

  Future<FormData> _deliverFormData({
    required DeliverSegmentModel deliverModel,
  }) async {
    final imagesFiles = await _mapImagesToMultipart(deliverModel.images);

    return FormData.fromMap({...deliverModel.toMap(), 'images': imagesFiles});
  }

  Future<FormData> _failFormData({required FailSegmentModel failModel}) async {
    final imagesFiles = await _mapImagesToMultipart(failModel.images);

    return FormData.fromMap({...failModel.toMap(), 'images': imagesFiles});
  }

  Future<List<MultipartFile>> _mapImagesToMultipart(List<File> images) async {
    return ShipmentManager.createMultipartImages(images: images);
  }
}
