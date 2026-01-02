import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/features/home/data/repos/home_repo_imp.dart';
import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';

part 'today_shipments_state.dart';

class TodayShipmentsCubit extends Cubit<TodayShipmentsState> {
  final HomeRepoImp homeRepo;

  // Flag للتحقق من أول fetch (خليناها public)
  bool isDataFetched = false;

  // متغير لتخزين الشحنات
  List<ShipmentModel>? cachedTodayShipments;

  TodayShipmentsCubit({required this.homeRepo})
    : super(TodayShipmentsInitial());

  // Method جديدة تعمل fetch مرة واحدة بس
  Future<void> fetchInitialData() async {
    if (isDataFetched) {
      // لو الداتا موجودة، emit الـ success state تاني عشان الـ UI يعرضها
      if (cachedTodayShipments != null && cachedTodayShipments!.isNotEmpty) {
        emit(TodayShipmentsSuccess(shipments: cachedTodayShipments!));
      }
      return;
    }

    isDataFetched = true;

    // الحصول على تاريخ اليوم
    final today = DateTime.now();
    final todayDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final query = {"from": todayDate, "to": todayDate};

    // نفذ الـ fetch
    await fetchTodayShipments(query: query);
  }

  // Method إضافية لو عايز تعمل refresh manual
  Future<void> refreshData() async {
    isDataFetched = false; // reset الـ flag
    cachedTodayShipments = null;
    await fetchInitialData();
  }

  Future<void> fetchTodayShipments({
    required Map<String, dynamic> query,
  }) async {
    emit(TodayShipmentsLoading());
    try {
      var result = await homeRepo.fetchTodayShipmets(query: query);
      result.fold(
        (failure) {
          emit(TodayShipmentsFailure(message: failure.errMessage));
        },
        (shipments) {
          // تخزين الشحنات
          cachedTodayShipments = shipments;
          emit(TodayShipmentsSuccess(shipments: shipments));
        },
      );
    } catch (error) {
      emit(TodayShipmentsFailure(message: error.toString()));
    }
  }

  // دالة لمسح الـ cache (اختيارية - لو محتاج refresh)
  void clearCache() {
    isDataFetched = false;
    cachedTodayShipments = null;
  }
}
