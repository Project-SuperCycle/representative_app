import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:supercycle/core/errors/failures.dart';

/// Helper class لمعالجة الأخطاء بشكل مركزي
class ErrorHandler {
  static final Logger _logger = Logger();

  /// معالجة الأخطاء وإرجاع <Either<Failure, T
  ///
  /// استخدام:
  /// ```dart
  /// return await ErrorHandler.handleApiCall(
  ///   apiCall: () async {
  ///     final response = await apiServices.post(...);
  ///     return YourModel.fromJson(response);
  ///   },
  ///   errorContext: 'user login',
  /// );
  /// ```
  static Future<Either<Failure, T>> handleApiCall<T>({
    required Future<T> Function() apiCall,
    required String errorContext,
    Map<String, dynamic>? additionalErrorHandling,
  }) async {
    try {
      final result = await apiCall();
      return right(result);
    } on DioException catch (dioError) {
      return left(ServerFailure.fromDioError(dioError));
    } on FormatException catch (formatError) {
      _logger.e('❌ FormatException during $errorContext: $formatError');
      return left(ServerFailure(formatError.toString(), 422));
    } on TypeError catch (typeError) {
      _logger.e('❌ TypeError during $errorContext: $typeError');
      return left(
        ServerFailure('Data parsing error: ${typeError.toString()}', 422),
      );
    } catch (e) {
      _logger.e('❌ Unexpected error during $errorContext: ${e.toString()}');

      // معالجة أخطاء مخصصة إضافية
      if (additionalErrorHandling != null) {
        for (var entry in additionalErrorHandling.entries) {
          if (e.toString().contains(entry.key)) {
            return left(ServerFailure(entry.value as String, 400));
          }
        }
      }

      return left(
        ServerFailure('Unexpected error occurred: ${e.toString()}', 520),
      );
    }
  }

  /// معالجة استجابة API مع التحقق من الأخطاء الشائعة
  ///
  /// استخدام:
  /// ```dart
  /// return await ErrorHandler.handleApiResponse<LoginedUserModel>(
  ///   apiCall: () => apiServices.post(endPoint: ApiEndpoints.login, data: data),
  ///   errorContext: 'user login',
  ///   responseParser: (response) {
  ///     var data = response['data'];
  ///     var token = response['token'];
  ///     return LoginedUserModel.fromJson(data);
  ///   },
  ///   onSuccess: (model, response) async {
  ///     await _saveUserData(model, response['token']);
  ///   },
  ///   customErrorChecks: (response) {
  ///     if (response['token'] == null && response['Code'] == 403) {
  ///       return ServerFailure.fromResponse(403, response);
  ///     }
  ///     return null;
  ///   },
  /// );
  /// ```
  static Future<Either<Failure, T>> handleApiResponse<T>({
    required Future<Map<String, dynamic>> Function() apiCall,
    required String errorContext,
    required T Function(Map<String, dynamic> response) responseParser,
    Future<void> Function(T model, Map<String, dynamic> response)? onSuccess,
    Failure? Function(Map<String, dynamic> response)? customErrorChecks,
    Map<String, dynamic>? additionalErrorHandling,
  }) async {
    return await handleApiCall<T>(
      apiCall: () async {
        final response = await apiCall();

        // التحقق من الأخطاء المخصصة أولاً
        if (customErrorChecks != null) {
          final customError = customErrorChecks(response);
          if (customError != null) {
            throw customError;
          }
        }

        // التحقق من وجود البيانات
        if (response['data'] == null) {
          throw ServerFailure('Invalid response: Missing user data', 422);
        }

        // تحليل الاستجابة
        final model = responseParser(response);

        // تنفيذ عمليات إضافية عند النجاح
        if (onSuccess != null) {
          await onSuccess(model, response);
        }

        return model;
      },
      errorContext: errorContext,
      additionalErrorHandling: additionalErrorHandling,
    );
  }

  /// معالجة مبسطة للـ API calls التي لا تحتاج معالجة معقدة
  ///
  /// استخدام:
  /// ```dart
  /// return await ErrorHandler.simpleApiCall<String>(
  ///   apiCall: () => SocialAuthService.signInWithGoogle(),
  ///   errorContext: 'Google sign in',
  ///   errorMessage: 'حدث خطأ أثناء تسجيل الدخول بـ Google',
  /// );
  /// ```
  static Future<Either<Failure, T>> simpleApiCall<T>({
    required Future<T> Function() apiCall,
    required String errorContext,
    String? errorMessage,
    Map<String, String>? specificErrorMessages,
  }) async {
    try {
      final result = await apiCall();
      return right(result);
    } catch (e) {
      _logger.e('❌ Error during $errorContext: $e');

      // التحقق من رسائل أخطاء محددة
      if (specificErrorMessages != null) {
        for (var entry in specificErrorMessages.entries) {
          if (e.toString().contains(entry.key)) {
            return left(ServerFailure(entry.value, 400));
          }
        }
      }

      // رسالة خطأ افتراضية
      final message = errorMessage ?? 'An error occurred during $errorContext';
      return left(ServerFailure(message, 520));
    }
  }

  /// تسجيل الأخطاء فقط دون إرجاع Either
  static void logError(
    String context,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    _logger.e(
      '❌ Error in $context: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// التحقق من وجود البيانات المطلوبة في الاستجابة
  static Failure? validateResponseData(
    Map<String, dynamic> response,
    List<String> requiredFields,
  ) {
    for (var field in requiredFields) {
      if (response[field] == null) {
        return ServerFailure('Invalid response: Missing $field', 422);
      }
    }
    return null;
  }
}
