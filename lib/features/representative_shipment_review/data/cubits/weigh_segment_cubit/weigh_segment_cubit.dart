import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/weigh_segment_cubit/weigh_segment_state.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/weigh_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/repos/rep_shipment_review_repo_imp.dart';

class WeighSegmentCubit extends Cubit<WeighSegmentState> {
  final RepShipmentReviewRepoImp repShipmentReviewRepo;
  WeighSegmentCubit({required this.repShipmentReviewRepo})
    : super(WeighSegmentInitial());

  Future<void> weighSegment({required WeighSegmentModel weighModel}) async {
    emit(WeighSegmentLoading());
    try {
      var result = await repShipmentReviewRepo.weighSegment(
        weighModel: weighModel,
      );
      result.fold(
        (failure) {
          emit(WeighSegmentFailure(errorMessage: failure.errMessage));
        },
        (message) {
          emit(WeighSegmentSuccess(message: message));
        },
      );
    } catch (error) {
      emit(WeighSegmentFailure(errorMessage: error.toString()));
    }
  }
}
