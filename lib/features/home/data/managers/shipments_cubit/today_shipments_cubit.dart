import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:representative_app/features/home/data/repos/home_repo_imp.dart';
import 'package:representative_app/features/shipments_calendar/data/models/shipment_model.dart';

part 'today_shipments_state.dart';

class TodayShipmentsCubit extends Cubit<TodayShipmentsState> {
  final HomeRepoImp homeRepo;

  static const String _cacheKey = 'today_shipments_cache';
  static const String _cacheDateKey = 'today_shipments_cache_date';

  List<ShipmentModel>? _cachedTodayShipments;

  // Getter للوصول للـ cached data من الخارج
  List<ShipmentModel>? get cachedTodayShipments => _cachedTodayShipments;

  TodayShipmentsCubit({required this.homeRepo}) : super(TodayShipmentsInitial()) {
    // تحميل الـ cached data عند إنشاء الـ Cubit
    _loadCachedData();
  }

  /// ✅ تحميل البيانات المحفوظة من SharedPreferences
  Future<void> _loadCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedDate = prefs.getString(_cacheDateKey);
      final cachedJson = prefs.getString(_cacheKey);

      // التحقق من أن الـ cache لنفس اليوم
      final today = DateTime.now();
      final todayString = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      if (cachedDate == todayString && cachedJson != null && cachedJson.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(cachedJson);
        _cachedTodayShipments = jsonList.map((e) => ShipmentModel.fromJson(e)).toList();

        // إذا كان هناك بيانات محفوظة، أرسلها للـ UI فورًا
        if (_cachedTodayShipments != null && _cachedTodayShipments!.isNotEmpty) {
          emit(TodayShipmentsSuccess(shipments: _cachedTodayShipments!));
        }
      } else {
        // إذا كان التاريخ مختلف، امسح الـ cache القديم
        await _clearCache();
      }
    } catch (e) {
      // في حالة حدوث خطأ في القراءة، نتجاهله ونجلب البيانات من API
      print('Error loading cached data: $e');
    }
  }

  /// ✅ حفظ البيانات في SharedPreferences
  Future<void> _saveCachedData(List<ShipmentModel> shipments) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now();
      final todayString = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      // حفظ التاريخ والبيانات
      await prefs.setString(_cacheDateKey, todayString);

      final jsonList = shipments.map((e) => e.toJson()).toList();
      await prefs.setString(_cacheKey, json.encode(jsonList));

      _cachedTodayShipments = shipments;
    } catch (e) {
      print('Error saving cached data: $e');
    }
  }

  /// ✅ مسح الـ cache
  Future<void> _clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove(_cacheDateKey);
      _cachedTodayShipments = null;
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  /// ✅ جلب البيانات الأولية (تُستدعى مرة واحدة عند فتح الصفحة)
  Future<void> fetchInitialData() async {
    // إذا كان هناك بيانات محفوظة، لا نحتاج لـ fetch جديد
    if (_cachedTodayShipments != null && _cachedTodayShipments!.isNotEmpty) {
      // البيانات موجودة بالفعل، تم عرضها في _loadCachedData
      return;
    }

    // إذا لم تكن هناك بيانات محفوظة، نجلبها من API
    await _fetchFromApi();
  }

  /// ✅ جلب البيانات من API (استخدام داخلي)
  Future<void> _fetchFromApi() async {
    emit(TodayShipmentsLoading());

    try {
      final today = DateTime.now();
      final todayDate = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      final query = {"from": todayDate, "to": todayDate};

      final result = await homeRepo.fetchTodayShipments(query: query);

      result.fold(
            (failure) {
          emit(TodayShipmentsFailure(message: failure.errMessage));
        },
            (shipments) async {
          // حفظ البيانات في الذاكرة المؤقتة
          await _saveCachedData(shipments);

          if (shipments.isEmpty) {
            emit(TodayShipmentsEmpty());
          } else {
            emit(TodayShipmentsSuccess(shipments: shipments));
          }
        },
      );
    } catch (error) {
      emit(TodayShipmentsFailure(message: error.toString()));
    }
  }

  /// ✅ تحديث البيانات (Refresh) - يُستدعى عند السحب للتحديث
  Future<void> refreshData() async {
    await _fetchFromApi();
  }

  /// ✅ مسح الـ cache يدويًا (إذا لزم الأمر)
  Future<void> clearAllCache() async {
    await _clearCache();
    emit(TodayShipmentsInitial());
  }
}