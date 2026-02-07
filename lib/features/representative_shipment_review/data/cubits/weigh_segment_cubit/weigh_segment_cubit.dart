import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:representative_app/features/representative_shipment_review/data/cubits/weigh_segment_cubit/weigh_segment_state.dart';
import 'package:representative_app/features/representative_shipment_review/data/models/weigh_segment_model.dart';
import 'package:representative_app/features/representative_shipment_review/data/repos/rep_shipment_review_repo_imp.dart';

class WeighSegmentCubit extends Cubit<WeighSegmentState> {
  final RepShipmentReviewRepoImp repShipmentReviewRepo;

  WeighSegmentCubit({required this.repShipmentReviewRepo})
      : super(WeighSegmentInitial());

  Future<void> weighSegment({required WeighSegmentModel weighModel}) async {
    // ✅ Pass segmentId to loading state
    emit(WeighSegmentLoading(segmentId: weighModel.segmentID));

    try {
      var result = await repShipmentReviewRepo.weighSegment(
        weighModel: weighModel,
      );

      result.fold(
            (failure) {
          // ✅ Pass segmentId to failure state
          emit(WeighSegmentFailure(
            errorMessage: failure.errMessage,
            segmentId: weighModel.segmentID,
          ));
        },
            (message) {
          // ✅ Pass segmentId to success state
          emit(WeighSegmentSuccess(
            message: message,
            segmentId: weighModel.segmentID,
          ));
        },
      );
    } catch (error) {
      // ✅ Pass segmentId to failure state
      emit(WeighSegmentFailure(
        errorMessage: error.toString(),
        segmentId: weighModel.segmentID,
      ));
    }
  }
}