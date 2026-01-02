import 'package:dio/dio.dart';
import 'package:supercycle/core/services/storage_services.dart';

class ApiServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://supercycle-api-855015056699.europe-west1.run.app',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json', 'lang': 'ar'},
    ),
  );

  // Function to set the correct Content-Type
  Options getDioOptions({bool isMultipart = false}) {
    return Options(
      headers: {
        'Content-Type': isMultipart
            ? 'multipart/form-data'
            : 'application/json',
      },
    );
  }

  ApiServices() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<String?> _getToken() async {
    final token = await StorageServices.getUserToken();
    if (token != null) {
      return token;
    }
    return null;
  }

  // GET METHOD
  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    Response<dynamic> response = await _dio.get<dynamic>(
      endPoint,
      queryParameters: query,
      data: data,
    );
    return response.data;
  }

  // POST METHOD
  Future<Map<String, dynamic>> post({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    Response<dynamic> response = await _dio.post<dynamic>(endPoint, data: data);
    return response.data;
  }

  // POST METHOD WITH FORM DATA
  Future<Map<String, dynamic>> postFormData({
    required String endPoint,
    required FormData data,
  }) async {
    Response<dynamic> response = await _dio.post<dynamic>(
      endPoint,
      data: data,
      options: getDioOptions(isMultipart: true),
    );
    return response.data;
  }

  // PATCH METHOD
  Future<Map<String, dynamic>> patch({
    required String endPoint,
    Map<String, dynamic>? data,
  }) async {
    Response<dynamic> response = await _dio.patch<dynamic>(
      endPoint,
      data: data,
    );
    return response.data;
  }

  // PATCH METHOD WITH FORM DATA
  Future<Map<String, dynamic>> patchFormData({
    required String endPoint,
    required FormData data,
  }) async {
    Response<dynamic> response = await _dio.patch<dynamic>(
      endPoint,
      data: data,
      options: getDioOptions(isMultipart: true),
    );
    return response.data;
  }

  // DELETE METHOD
  Future<Map<String, dynamic>> delete({required String endPoint}) async {
    Response<dynamic> response = await _dio.delete<dynamic>(endPoint);
    return response.data;
  }
}
