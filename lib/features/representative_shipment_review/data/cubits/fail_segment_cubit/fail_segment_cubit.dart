import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/features/representative_shipment_review/data/cubits/fail_segment_cubit/fail_segment_state.dart';
import 'package:representative_app/features/representative_shipment_review/data/models/fail_segment_model.dart';
import 'package:representative_app/features/representative_shipment_review/data/repos/rep_shipment_review_repo_imp.dart';

class FailSegmentCubit extends Cubit<FailSegmentState> {
  final RepShipmentReviewRepoImp repShipmentReviewRepo;

  FailSegmentCubit({required this.repShipmentReviewRepo})
      : super(FailSegmentInitial());

  Future<void> failSegment({required FailSegmentModel failModel}) async {
    // ✅ Pass segmentId to loading state
    emit(FailSegmentLoading(segmentId: failModel.segmentID));

    try {
      var result = await repShipmentReviewRepo.failSegment(
        failModel: failModel,
      );

      result.fold(
            (failure) {
          // ✅ Pass segmentId to failure state
          emit(FailSegmentFailure(
            errorMessage: failure.errMessage,
            segmentId: failModel.segmentID,
          ));
        },
            (message) {
          // ✅ Pass segmentId to success state
          emit(FailSegmentSuccess(
            message: message,
            segmentId: failModel.segmentID,
          ));
        },
      );
    } catch (error) {
      // ✅ Pass segmentId to failure state
      emit(FailSegmentFailure(
        errorMessage: error.toString(),
        segmentId: failModel.segmentID,
      ));
    }
  }
}