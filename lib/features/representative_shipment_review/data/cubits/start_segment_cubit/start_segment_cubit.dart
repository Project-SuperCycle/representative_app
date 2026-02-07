import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/features/representative_shipment_review/data/cubits/start_segment_cubit/start_segment_state.dart';
import 'package:representative_app/features/representative_shipment_review/data/models/start_segment_model.dart';
import 'package:representative_app/features/representative_shipment_review/data/repos/rep_shipment_review_repo_imp.dart';

class StartSegmentCubit extends Cubit<StartSegmentState> {
  final RepShipmentReviewRepoImp repShipmentReviewRepo;

  StartSegmentCubit({required this.repShipmentReviewRepo})
      : super(StartSegmentInitial());

  Future<void> startSegment({required StartSegmentModel startModel}) async {
    // ✅ Pass segmentId to loading state
    emit(StartSegmentLoading(segmentId: startModel.segmentID));

    try {
      var result = await repShipmentReviewRepo.startSegment(
        startModel: startModel,
      );

      result.fold(
            (failure) {
          // ✅ Pass segmentId to failure state
          emit(StartSegmentFailure(
            errorMessage: failure.errMessage,
            segmentId: startModel.segmentID,
          ));
        },
            (message) {
          // ✅ Pass segmentId to success state
          emit(StartSegmentSuccess(
            message: message,
            segmentId: startModel.segmentID,
          ));
        },
      );
    } catch (error) {
      // ✅ Pass segmentId to failure state
      emit(StartSegmentFailure(
        errorMessage: error.toString(),
        segmentId: startModel.segmentID,
      ));
    }
  }
}