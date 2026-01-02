import 'package:dartz/dartz.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/deliver_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/fail_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/start_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/weigh_segment_model.dart';

abstract class RepShipmentReviewRepo {
  Future<Either<Failure, String>> startSegment({
    required StartSegmentModel startModel,
  });

  Future<Either<Failure, String>> weighSegment({
    required WeighSegmentModel weighModel,
  });

  Future<Either<Failure, String>> deliverSegment({
    required DeliverSegmentModel deliverModel,
  });

  Future<Either<Failure, String>> failSegment({
    required FailSegmentModel failModel,
  });
}
