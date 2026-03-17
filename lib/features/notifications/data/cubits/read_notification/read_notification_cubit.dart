import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/features/notifications/data/repos/notifications_repo_imp.dart';

import 'read_notification_state.dart';

class ReadNotificationCubit extends Cubit<ReadNotificationState> {
  final NotificationsRepoImp repo;

  ReadNotificationCubit({required this.repo})
    : super(ReadNotificationInitial());

  Future<void> readNotification({required String id}) async {
    emit(ReadNotificationLoading());
    final result = await repo.readNotification(notificationId: id);

    result.fold(
      (f) => emit(ReadNotificationFailure(errorMessage: f.errMessage)),
      (_) => emit(ReadNotificationSuccess(message: "تم قراءة الإشعار", id: id)),
    );
  }
}
