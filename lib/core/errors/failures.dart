import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;
  final int statusCode;

  const Failure(this.errMessage, this.statusCode);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage, super.statusCode);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
          'Connection timeout. Please check your internet.',
          408, // Request Timeout
        );
      case DioExceptionType.sendTimeout:
        return ServerFailure(
          'Request timeout. Please try again.',
          408, // Request Timeout
        );
      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          'Server is taking too long to respond. Try again.',
          504, // Gateway Timeout
        );
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure(
          'Request was canceled.',
          499, // Client Closed Request (Nginx convention)
        );
      case DioExceptionType.unknown:
      case DioExceptionType.connectionError:
        return _handleConnectionError(dioError);
      default:
        return ServerFailure(
          'Unexpected error occurred. Please try again.',
          520, // Unknown Error (Cloudflare convention)
        );
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    final actualStatusCode = statusCode ?? 500;

    if (response is Map<String, dynamic>) {
      final errorMessage = response['message'] ?? 'Unknown error';
      switch (actualStatusCode) {
        case 400:
          return ServerFailure(errorMessage, 400); // Bad Request
        case 401:
          return ServerFailure(errorMessage, 401); // Unauthorized
        case 403:
          return ServerFailure(errorMessage, 403); // Forbidden
        case 404:
          return ServerFailure(errorMessage, 404); // Not Found
        case 409:
          return ServerFailure(errorMessage, 409); // Conflict
        case 422:
          return ServerFailure(errorMessage, 422); // Unprocessable Entity
        case 429:
          return ServerFailure(errorMessage, 429); // Too Many Requests
        case 500:
          return ServerFailure('Server error. Please try later.', 500);
        case 502:
          return ServerFailure('Bad Gateway. Please try later.', 502);
        case 503:
          return ServerFailure('Service unavailable. Please try later.', 503);
        case 504:
          return ServerFailure('Gateway timeout. Please try later.', 504);
        default:
          return ServerFailure(
            'Unexpected server error. Try again.',
            actualStatusCode,
          );
      }
    }
    return ServerFailure('Unexpected response format.', actualStatusCode);
  }

  static ServerFailure _handleConnectionError(DioException dioError) {
    final errorMessage = dioError.message?.toLowerCase() ?? '';

    if (errorMessage.contains('socket exception') ||
        errorMessage.contains('network is unreachable') ||
        errorMessage.contains('failed host lookup')) {
      return ServerFailure(
        'No Internet Connection.',
        0, // Network Error (custom code)
      );
    }

    if (errorMessage.contains('connection refused')) {
      return ServerFailure(
        'Connection refused. Server might be down.',
        503, // Service Unavailable
      );
    }

    return ServerFailure(
      'Network error occurred. Please check your connection.',
      0, // Network Error (custom code)
    );
  }
}
