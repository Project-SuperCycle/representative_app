import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/features/representative_shipment_review/data/cubits/deliver_segment_cubit/deliver_segment_state.dart';
import 'package:representative_app/features/representative_shipment_review/data/models/deliver_segment_model.dart';
import 'package:representative_app/features/representative_shipment_review/data/repos/rep_shipment_review_repo_imp.dart';

class DeliverSegmentCubit extends Cubit<DeliverSegmentState> {
  final RepShipmentReviewRepoImp repShipmentReviewRepo;

  DeliverSegmentCubit({required this.repShipmentReviewRepo})
      : super(DeliverSegmentInitial());

  Future<void> deliverSegment({
    required DeliverSegmentModel deliverModel,
  }) async {
    // ✅ Pass segmentId to loading state
    emit(DeliverSegmentLoading(segmentId: deliverModel.segmentID));

    try {
      var result = await repShipmentReviewRepo.deliverSegment(
        deliverModel: deliverModel,
      );

      result.fold(
            (failure) {
          // ✅ Pass segmentId to failure state
          emit(DeliverSegmentFailure(
            errorMessage: failure.errMessage,
            segmentId: deliverModel.segmentID,
          ));
        },
            (message) {
          // ✅ Pass segmentId to success state
          emit(DeliverSegmentSuccess(
            message: message,
            segmentId: deliverModel.segmentID,
          ));
        },
      );
    } catch (error) {
      // ✅ Pass segmentId to failure state
      emit(DeliverSegmentFailure(
        errorMessage: error.toString(),
        segmentId: deliverModel.segmentID,
      ));
    }
  }
}