import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/home/data/models/dosh_data_model.dart';
import 'package:supercycle/features/home/data/models/dosh_type_model.dart'
    show DoshTypeModel;
import 'package:supercycle/features/home/data/models/type_history_model.dart';
import 'package:supercycle/features/home/data/repos/home_repo_imp.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepoImp homeRepo;

  // Flag للتحقق من أول fetch
  bool _isDataFetched = false;

  // تخزين الداتا في الـ Cubit
  List<DoshTypeModel>? cachedDoshTypes;
  List<DoshDataModel>? cachedTypesData;
  List<TypeHistoryModel>? cachedTypeHistory; // غيرها لـ List

  HomeCubit({required this.homeRepo}) : super(HomeInitial());

  // Method جديدة تعمل fetch مرة واحدة بس
  Future<void> fetchInitialData() async {
    if (_isDataFetched) {
      // لو الداتا موجودة، emit الـ success states تاني عشان الـ UI يعرضها
      if (cachedDoshTypes != null) {
        emit(FetchDoshTypesSuccess(doshTypes: cachedDoshTypes!));
      }
      if (cachedTypesData != null) {
        emit(FetchTypesDataSuccess(doshData: cachedTypesData!));
      }
      if (cachedTypeHistory != null) {
        emit(FetchTypeHistorySuccess(history: cachedTypeHistory!));
      }
      return;
    }

    _isDataFetched = true;

    // نفذ كل الـ fetch methods مرة واحدة
    await Future.wait([
      fetchDoshTypes(),
      fetchTypesData(),
      fetchTypeHistory(typeId: "68a8567bf5a2951a1ee9e982"),
    ]);
  }

  // Method إضافية لو عايز تعمل refresh manual
  Future<void> refreshData() async {
    _isDataFetched = false; // reset الـ flag
    cachedDoshTypes = null;
    cachedTypesData = null;
    cachedTypeHistory = null;
    await fetchInitialData();
  }

  Future<void> fetchDoshTypes() async {
    emit(FetchDoshTypesLoading());
    try {
      var result = await homeRepo.fetchDoshTypes();
      result.fold(
        (failure) {
          emit(FetchDoshTypesFailure(message: failure.errMessage));
        },
        (types) {
          cachedDoshTypes = types; // تخزين الداتا
          emit(FetchDoshTypesSuccess(doshTypes: types));
        },
      );
    } catch (error) {
      emit(FetchDoshTypesFailure(message: error.toString()));
    }
  }

  Future<void> fetchTypeHistory({required String typeId}) async {
    emit(FetchTypeHistoryLoading());
    try {
      var result = await homeRepo.fetchTypeHistory(typeId: typeId);
      result.fold(
        (failure) {
          emit(FetchTypeHistoryFailure(message: failure.errMessage));
        },
        (history) {
          cachedTypeHistory =
              history; // تخزين الداتا (هنا history لازم يكون List)
          emit(FetchTypeHistorySuccess(history: history));
        },
      );
    } catch (error) {
      emit(FetchTypeHistoryFailure(message: error.toString()));
    }
  }

  Future<void> fetchTypesData() async {
    emit(FetchTypesDataLoading());
    try {
      var result = await homeRepo.fetchTypesData();
      result.fold(
        (failure) {
          emit(FetchTypesDataFailure(message: failure.errMessage));
        },
        (data) {
          cachedTypesData = data; // تخزين الداتا
          emit(FetchTypesDataSuccess(doshData: data));
        },
      );
    } catch (error) {
      emit(FetchTypesDataFailure(message: error.toString()));
    }
  }
}
