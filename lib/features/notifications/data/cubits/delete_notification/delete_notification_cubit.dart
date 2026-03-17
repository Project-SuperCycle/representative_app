import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/features/notifications/data/repos/notifications_repo_imp.dart';

import 'delete_notification_state.dart';

class DeleteNotificationCubit extends Cubit<DeleteNotificationState> {
  final NotificationsRepoImp repo;

  DeleteNotificationCubit({required this.repo})
    : super(DeleteNotificationInitial());

  Future<void> deleteNotification({required String id}) async {
    emit(DeleteNotificationLoading());
    final result = await repo.deleteNotification(notificationId: id);

    result.fold(
      (f) => emit(DeleteNotificationFailure(errorMessage: f.errMessage)),
      (_) => emit(DeleteNotificationSuccess(message: "تم حذف الإشعار", id: id)),
    );
  }
}
