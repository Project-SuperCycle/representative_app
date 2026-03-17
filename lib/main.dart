import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:representative_app/core/cubits/add_notes_cubit/add_notes_cubit.dart';
import 'package:representative_app/core/cubits/local_cubit/local_cubit.dart';
import 'package:representative_app/core/repos/shipment_notes_repo_imp.dart';
import 'package:representative_app/core/routes/routes.dart';
import 'package:representative_app/core/services/notifications/local_notifications_service.dart';
import 'package:representative_app/core/services/notifications/push_notifications_service.dart';
import 'package:representative_app/core/services/services_locator.dart';
import 'package:representative_app/core/utils/app_styles.dart';
import 'package:representative_app/features/forget_password/data/cubits/forget_password_cubit.dart';
import 'package:representative_app/features/forget_password/data/repos/forget_password_repo_imp.dart';
import 'package:representative_app/features/home/data/managers/home_cubit/home_cubit.dart';
import 'package:representative_app/features/home/data/managers/profile_cubit/profile_cubit.dart';
import 'package:representative_app/features/home/data/managers/shipments_cubit/today_shipments_cubit.dart';
import 'package:representative_app/features/home/data/repos/home_repo_imp.dart';
import 'package:representative_app/features/notifications/data/cubits/delete_notification/delete_notification_cubit.dart';
import 'package:representative_app/features/notifications/data/cubits/get_notifications/get_notifications_cubit.dart';
import 'package:representative_app/features/notifications/data/cubits/read_notification/read_notification_cubit.dart';
import 'package:representative_app/features/notifications/data/repos/notifications_repo_imp.dart';
import 'package:representative_app/features/representative_shipment_details/data/cubits/accept_shipment_cubit/accept_shipment_cubit.dart';
import 'package:representative_app/features/representative_shipment_details/data/cubits/reject_shipment_cubit/reject_shipment_cubit.dart';
import 'package:representative_app/features/representative_shipment_details/data/cubits/update_shipment_cubit/update_shipment_cubit.dart';
import 'package:representative_app/features/representative_shipment_details/data/repos/rep_shipment_details_repo_imp.dart';
import 'package:representative_app/features/representative_shipment_review/data/cubits/deliver_segment_cubit/deliver_segment_cubit.dart';
import 'package:representative_app/features/representative_shipment_review/data/cubits/fail_segment_cubit/fail_segment_cubit.dart';
import 'package:representative_app/features/representative_shipment_review/data/cubits/start_segment_cubit/start_segment_cubit.dart';
import 'package:representative_app/features/representative_shipment_review/data/cubits/weigh_segment_cubit/weigh_segment_cubit.dart';
import 'package:representative_app/features/representative_shipment_review/data/repos/rep_shipment_review_repo_imp.dart';
import 'package:representative_app/features/shipment_edit/data/cubits/shipment_edit_cubit.dart';
import 'package:representative_app/features/shipment_edit/data/repos/shipment_edit_repo_imp.dart';
import 'package:representative_app/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_cubit.dart';
import 'package:representative_app/features/shipments_calendar/data/repos/shipments_calendar_repo_imp.dart';
import 'package:representative_app/features/sign_in/data/cubits/sign-in-cubit/sign_in_cubit.dart';
import 'package:representative_app/features/sign_in/data/repos/signin_repo_imp.dart';
import 'package:representative_app/firebase_options.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await _initNonCriticalServices();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocalCubit()),
        BlocProvider(
          create: (context) =>
              SignInCubit(signInRepo: getIt.get<SignInRepoImp>()),
        ),

        BlocProvider(
          create: (context) => HomeCubit(homeRepo: getIt.get<HomeRepoImp>()),
        ),
        BlocProvider(
          create: (context) => ShipmentsCalendarCubit(
            shipmentsCalendarRepo: getIt.get<ShipmentsCalendarRepoImp>(),
          ),
        ),
        BlocProvider(
          create: (context) => ShipmentEditCubit(
            shipmentEditRepo: getIt.get<ShipmentEditRepoImp>(),
          ),
        ),
        BlocProvider(
          create: (context) => AcceptShipmentCubit(
            repShipmentDetailsRepo: getIt.get<RepShipmentDetailsRepoImp>(),
          ),
        ),
        BlocProvider(
          create: (context) => RejectShipmentCubit(
            repShipmentDetailsRepo: getIt.get<RepShipmentDetailsRepoImp>(),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateShipmentCubit(
            repShipmentDetailsRepo: getIt.get<RepShipmentDetailsRepoImp>(),
          ),
        ),
        BlocProvider(
          create: (context) => StartSegmentCubit(
            repShipmentReviewRepo: getIt.get<RepShipmentReviewRepoImp>(),
          ),
        ),
        BlocProvider(
          create: (context) => WeighSegmentCubit(
            repShipmentReviewRepo: getIt.get<RepShipmentReviewRepoImp>(),
          ),
        ),
        BlocProvider(
          create: (context) => DeliverSegmentCubit(
            repShipmentReviewRepo: getIt.get<RepShipmentReviewRepoImp>(),
          ),
        ),
        BlocProvider(
          create: (context) => FailSegmentCubit(
            repShipmentReviewRepo: getIt.get<RepShipmentReviewRepoImp>(),
          ),
        ),
        BlocProvider(
          create: (context) {
            final cubit = TodayShipmentsCubit(
              homeRepo: getIt.get<HomeRepoImp>(),
            );
            return cubit;
          },
        ),

        BlocProvider(
          create: (context) => ForgetPasswordCubit(
            forgetPasswordRepoImp: getIt.get<ForgetPasswordRepoImp>(),
          ),
        ),

        BlocProvider(
          create: (context) => AddNotesCubit(
            shipmentNotesRepo: getIt.get<ShipmentNotesRepoImp>(),
          ),
        ),

        BlocProvider(
          create: (context) =>
              GetNotificationsCubit(repo: getIt.get<NotificationsRepoImp>()),
        ),

        BlocProvider(
          create: (context) =>
              ReadNotificationCubit(repo: getIt.get<NotificationsRepoImp>()),
        ),

        BlocProvider(
          create: (context) =>
              DeleteNotificationCubit(repo: getIt.get<NotificationsRepoImp>()),
        ),

        BlocProvider(create: (context) => ProfileCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _initNonCriticalServices() async {
  try {
    await PushNotificationsService.init();
    await LocalNotificationsService.init();
  } catch (e, s) {
    debugPrint('❌ Services init failed: $e');
    debugPrintStack(stackTrace: s);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocalCubit()..getSavedLang(),
      child: BlocBuilder<LocalCubit, LocalState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Super Cycle',
            theme: ThemeData(scaffoldBackgroundColor: Colors.white),
            routerConfig: AppRouter.router,
            locale: (state is ChangeLocalState)
                ? const Locale('ar')
                : const Locale('ar'),
            builder: (context, child) {
              // دمج DevicePreview مع الـ Custom Banner
              child = DevicePreview.appBuilder(context, child);
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Banner(
                  message: 'تجريبية', // غير النص للي تحبه
                  location: BannerLocation.topStart, // أو topEnd
                  color: Color(0xff803C2B), // غير اللون للي تحبه
                  textStyle: AppStyles.styleBold12(context).copyWith(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                  child: child,
                ),
              );
            },
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    );
  }
}
