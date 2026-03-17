import 'package:dartz/dartz.dart';
import 'package:representative_app/core/errors/failures.dart' show Failure;
import 'package:representative_app/core/models/notifications_model.dart';

abstract class NotificationsRepo {
  Future<Either<Failure, List<NotificationModel>>> fetchNotifications();

  Future<Either<Failure, String>> readNotification({
    required String notificationId,
  });

  Future<Either<Failure, String>> deleteNotification({
    required String notificationId,
  });
}
