import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/representative_shipment_review/data/cubits/start_segment_cubit/start_segment_state.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/start_segment_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/repos/rep_shipment_review_repo_imp.dart';

class StartSegmentCubit extends Cubit<StartSegmentState> {
  final RepShipmentReviewRepoImp repShipmentReviewRepo;
  StartSegmentCubit({required this.repShipmentReviewRepo})
    : super(StartSegmentInitial());

  Future<void> startSegment({required StartSegmentModel startModel}) async {
    emit(StartSegmentLoading());
    try {
      var result = await repShipmentReviewRepo.startSegment(
        startModel: startModel,
      );
      result.fold(
        (failure) {
          emit(StartSegmentFailure(errorMessage: failure.errMessage));
        },
        (message) {
          emit(StartSegmentSuccess(message: message));
        },
      );
    } catch (error) {
      emit(StartSegmentFailure(errorMessage: error.toString()));
    }
  }
}
