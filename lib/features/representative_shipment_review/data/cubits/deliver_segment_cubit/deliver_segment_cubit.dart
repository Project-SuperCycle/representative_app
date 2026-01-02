import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/deliver_segment_cubit/deliver_segment_state.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/deliver_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/repos/rep_shipment_review_repo_imp.dart';

class DeliverSegmentCubit extends Cubit<DeliverSegmentState> {
  final RepShipmentReviewRepoImp repShipmentReviewRepo;
  DeliverSegmentCubit({required this.repShipmentReviewRepo})
    : super(DeliverSegmentInitial());

  Future<void> deliverSegment({
    required DeliverSegmentModel deliverModel,
  }) async {
    emit(DeliverSegmentLoading());
    try {
      var result = await repShipmentReviewRepo.deliverSegment(
        deliverModel: deliverModel,
      );
      result.fold(
        (failure) {
          emit(DeliverSegmentFailure(errorMessage: failure.errMessage));
        },
        (message) {
          emit(DeliverSegmentSuccess(message: message));
        },
      );
    } catch (error) {
      emit(DeliverSegmentFailure(errorMessage: error.toString()));
    }
  }
}
