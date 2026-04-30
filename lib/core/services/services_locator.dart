import 'package:get_it/get_it.dart';
import 'package:representative_app/core/repos/shipment_notes_repo_imp.dart';
import 'package:representative_app/core/services/api_services.dart';
import 'package:representative_app/core/services/dosh_types_manager.dart';
import 'package:representative_app/features/finances/data/repos/representative_finances_repo_imp.dart';
import 'package:representative_app/features/forget_password/data/repos/forget_password_repo_imp.dart';
import 'package:representative_app/features/home/data/repos/home_repo_imp.dart';
import 'package:representative_app/features/notifications/data/repos/notifications_repo_imp.dart';
import 'package:representative_app/features/representative_shipment_details/data/repos/rep_shipment_details_repo_imp.dart';
import 'package:representative_app/features/representative_shipment_review/data/repos/rep_shipment_review_repo_imp.dart';
import 'package:representative_app/features/shipment_edit/data/repos/shipment_edit_repo_imp.dart';
import 'package:representative_app/features/shipments_calendar/data/repos/shipments_calendar_repo_imp.dart';
import 'package:representative_app/features/sign_in/data/repos/signin_repo_imp.dart';

GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<ApiServices>(ApiServices());
  getIt.registerSingleton<DoshTypesManager>(DoshTypesManager());

  getIt.registerSingleton<SignInRepoImp>(
    SignInRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<HomeRepoImp>(
    HomeRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<ShipmentNotesRepoImp>(
    ShipmentNotesRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<ShipmentsCalendarRepoImp>(
    ShipmentsCalendarRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<ShipmentEditRepoImp>(
    ShipmentEditRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<RepShipmentDetailsRepoImp>(
    RepShipmentDetailsRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<RepShipmentReviewRepoImp>(
    RepShipmentReviewRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<ForgetPasswordRepoImp>(
    ForgetPasswordRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<NotificationsRepoImp>(
    NotificationsRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<RepresentativeFinancesRepoImp>(
    RepresentativeFinancesRepoImp(apiServices: getIt.get<ApiServices>()),
  );
}
