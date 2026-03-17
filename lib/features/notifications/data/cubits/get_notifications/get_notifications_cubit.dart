import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/core/models/notifications_model.dart';
import 'package:representative_app/features/notifications/data/cubits/get_notifications/get_notifications_state.dart';
import 'package:representative_app/features/notifications/data/repos/notifications_repo_imp.dart';

class GetNotificationsCubit extends Cubit<GetNotificationsState> {
  final NotificationsRepoImp repo;

  List<NotificationModel> notifications = [];

  GetNotificationsCubit({required this.repo})
    : super(GetNotificationsInitial());

  Future<void> getNotifications() async {
    emit(GetNotificationsLoading());
    final result = await repo.fetchNotifications();
    result.fold(
      (f) => emit(GetNotificationsFailure(errorMessage: f.errMessage)),
      (list) {
        notifications = list;
        emit(GetNotificationsSuccess(notifications: notifications));
      },
    );
  }

  // ✅ تحديث notification معين كـ مقروء
  void markAsRead(String id) {
    notifications = notifications.map((n) {
      if (n.id == id) return n.copyWith(seen: true);
      return n;
    }).toList();
    emit(GetNotificationsInitial()); // ✅ force state change
    emit(
      GetNotificationsSuccess(notifications: List.from(notifications)),
    ); // ✅ new list instance
  }

  // ✅ حذف notification من الـ list
  void removeNotification(String id) {
    notifications = notifications.where((n) => n.id != id).toList();
    emit(GetNotificationsInitial()); // ✅ force state change
    emit(GetNotificationsSuccess(notifications: List.from(notifications)));
  }
}
