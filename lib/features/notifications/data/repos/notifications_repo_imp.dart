import 'package:dartz/dartz.dart';
import 'package:representative_app/core/errors/failures.dart';
import 'package:representative_app/core/helpers/error_handler.dart';
import 'package:representative_app/core/models/notifications_model.dart';
import 'package:representative_app/core/services/api_endpoints.dart';
import 'package:representative_app/core/services/api_services.dart';
import 'package:representative_app/features/notifications/data/repos/notifications_repo.dart';

class NotificationsRepoImp implements NotificationsRepo {
  final ApiServices apiServices;

  NotificationsRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, String>> deleteNotification({
    required String notificationId,
  }) {
    // TODO: implement deleteNotification
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final response = await apiServices.delete(
          endPoint: ApiEndpoints.deleteNotification.replaceFirst(
            '{id}',
            notificationId,
          ),
        );

        if (response['status'] != "success") {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['status'];
      },
      errorContext: 'delete notification',
    );
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> fetchNotifications() {
    // TODO: implement fetchNotifications
    return ErrorHandler.handleApiResponse<List<NotificationModel>>(
      apiCall: () => apiServices.get(endPoint: ApiEndpoints.getNotifications),
      errorContext: 'fetch notifications',
      responseParser: (response) {
        final List data = response['data']['items'];
        return data.map((e) => NotificationModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, String>> readNotification({
    required String notificationId,
  }) {
    // TODO: implement readNotification
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final response = await apiServices.patch(
          endPoint: ApiEndpoints.readNotification.replaceFirst(
            '{id}',
            notificationId,
          ),
        );

        if (response['status'] != "success") {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['status'];
      },
      errorContext: 'read notification',
    );
  }
}
