import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/core/cubits/add_notes_cubit/add_notes_state.dart';
import 'package:representative_app/core/models/create_notes_model.dart';
import 'package:representative_app/core/repos/shipment_notes_repo_imp.dart';

class AddNotesCubit extends Cubit<AddNotesState> {
  final ShipmentNotesRepoImp shipmentNotesRepo;
  AddNotesCubit({required this.shipmentNotesRepo}) : super(AddNotesInitial());

  Future<void> addNotes({
    required CreateNotesModel notes,
    required String shipmentId,
  }) async {
    emit(AddNotesLoading());
    try {
      var result = await shipmentNotesRepo.addNotes(
        notes: notes,
        shipmentId: shipmentId,
      );
      result.fold(
        (failure) {
          emit(AddNotesFailure(errorMessage: failure.errMessage));
        },
        (message) {
          emit(AddNotesSuccess(message: message));
          // Store user globally
        },
      );
    } catch (error) {
      emit(AddNotesFailure(errorMessage: error.toString()));
    }
  }
}
