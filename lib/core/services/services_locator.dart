import 'package:get_it/get_it.dart';
import 'package:supercycle/core/repos/social_auth_repo_imp.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/core/services/dosh_types_manager.dart';
import 'package:supercycle/features/environment/data/repos/environment_repo_imp.dart';
import 'package:supercycle/features/forget_password/data/repos/forget_password_repo_imp.dart';
import 'package:supercycle/features/home/data/repos/home_repo_imp.dart';
import 'package:supercycle/features/representative_shipment_details/data/repos/rep_shipment_details_repo_imp.dart';
import 'package:supercycle/features/representative_shipment_review/data/repos/rep_shipment_review_repo_imp.dart';
import 'package:supercycle/features/sales_process/data/repos/sales_process_repo_imp.dart';
import 'package:supercycle/features/trader_shipment_details/data/repos/shipment_details_repo_imp.dart';
import 'package:supercycle/features/trader_shipment_details/data/repos/shipment_notes_repo_imp.dart';
import 'package:supercycle/features/shipment_edit/data/repos/shipment_edit_repo_imp.dart';
import 'package:supercycle/features/shipments_calendar/data/repos/shipments_calendar_repo_imp.dart';
import 'package:supercycle/features/sign_in/data/repos/signin_repo_imp.dart';
import 'package:supercycle/features/sign_up/data/repos/signup_repo_imp.dart';

GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<ApiServices>(ApiServices());
  getIt.registerSingleton<DoshTypesManager>(DoshTypesManager());

  getIt.registerSingleton<SignInRepoImp>(
    SignInRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<SignUpRepoImp>(
    SignUpRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<SocialAuthRepoImp>(
    SocialAuthRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<HomeRepoImp>(
    HomeRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<SalesProcessRepoImp>(
    SalesProcessRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<ShipmentDetailsRepoImp>(
    ShipmentDetailsRepoImp(apiServices: getIt.get<ApiServices>()),
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

  getIt.registerSingleton<EnvironmentRepoImp>(
    EnvironmentRepoImp(apiServices: getIt.get<ApiServices>()),
  );

  getIt.registerSingleton<ForgetPasswordRepoImp>(
    ForgetPasswordRepoImp(apiServices: getIt.get<ApiServices>()),
  );
}
