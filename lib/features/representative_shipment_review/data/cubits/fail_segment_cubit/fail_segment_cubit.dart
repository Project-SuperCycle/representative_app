import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/fail_segment_cubit/fail_segment_state.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/fail_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/repos/rep_shipment_review_repo_imp.dart';

class FailSegmentCubit extends Cubit<FailSegmentState> {
  final RepShipmentReviewRepoImp repShipmentReviewRepo;
  FailSegmentCubit({required this.repShipmentReviewRepo})
    : super(FailSegmentInitial());

  Future<void> failSegment({required FailSegmentModel failModel}) async {
    emit(FailSegmentLoading());
    try {
      var result = await repShipmentReviewRepo.failSegment(
        failModel: failModel,
      );
      result.fold(
        (failure) {
          emit(FailSegmentFailure(errorMessage: failure.errMessage));
        },
        (message) {
          emit(FailSegmentSuccess(message: message));
        },
      );
    } catch (error) {
      emit(FailSegmentFailure(errorMessage: error.toString()));
    }
  }
}
