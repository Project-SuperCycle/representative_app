import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/utils/calendar_utils.dart';
import 'package:supercycle/core/widgets/drawer/custom_drawer.dart';
import 'package:supercycle/core/widgets/shipment/shipment_logo.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_cubit.dart';
import 'package:supercycle/features/shipments_calendar/data/cubits/shipments_calendar_cubit/shipments_calendar_state.dart';
import 'package:supercycle/features/shipments_calendar/data/models/shipment_model.dart';
import 'package:supercycle/features/shipments_calendar/presentation/widget/shipment_calendar_details.dart';
import 'package:supercycle/features/shipments_calendar/presentation/widget/shipments_calendar_grid.dart';
import 'package:supercycle/features/shipments_calendar/presentation/widget/shipments_calendar_header.dart';
import 'package:supercycle/features/shipments_calendar/presentation/widget/shipments_calender_title.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';

class ShipmentsCalendarViewBody extends StatefulWidget {
  const ShipmentsCalendarViewBody({super.key});

  @override
  ShipmentsCalendarViewBodyState createState() =>
      ShipmentsCalendarViewBodyState();
}

class ShipmentsCalendarViewBodyState extends State<ShipmentsCalendarViewBody> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _currentDate = DateTime.now();
  DateTime? _selectedDate;
  List<ShipmentModel> shipments = [];
  String? userRole;

  @override
  void initState() {
    super.initState();
    loadUserCalender();
  }

  void loadUserCalender() async {
    LoginedUserModel? user = await StorageServices.getUserData();
    if (user != null) {
      setState(() {
        userRole = user.role;
      });
      _fetchShipmentsForMonth(_currentDate);
    }
  }

  void _fetchShipmentsForMonth(DateTime date) {
    // حساب أول يوم في الشهر
    final firstDayOfMonth = DateTime(date.year, date.month, 1);

    // حساب آخر يوم في الشهر
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    // تنسيق التواريخ بصيغة مناسبة (مثلاً: yyyy-MM-dd)
    final fromDate =
        "${firstDayOfMonth.year}-${firstDayOfMonth.month.toString().padLeft(2, '0')}-${firstDayOfMonth.day.toString().padLeft(2, '0')}";
    final toDate =
        "${lastDayOfMonth.year}-${lastDayOfMonth.month.toString().padLeft(2, '0')}-${lastDayOfMonth.day.toString().padLeft(2, '0')}";

    final query = {"from": fromDate, "to": toDate};

    if (userRole == "representative") {
      BlocProvider.of<ShipmentsCalendarCubit>(
        context,
      ).getAllRepShipments(query: query);
    } else {
      BlocProvider.of<ShipmentsCalendarCubit>(
        context,
      ).getAllShipments(query: query);
    }
  }

  void _refreshShipments() {
    _fetchShipmentsForMonth(_currentDate);
  }

  static const String _imageUrl =
      "https://moe-ye.net/wp-content/uploads/2021/08/IMG-20210808-WA0001.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(gradient: kGradientBackground),
        child: SafeArea(
          child: Column(
            children: [
              Column(
                children: [const ShipmentLogo(), const SizedBox(height: 20)],
              ),
              Expanded(
                child:
                    BlocConsumer<
                      ShipmentsCalendarCubit,
                      ShipmentsCalendarState
                    >(
                      listener: (context, state) {
                        if (state is GetAllShipmentsSuccess) {
                          setState(() {
                            shipments = state.shipments;
                          });
                        }
                        if (state is GetAllShipmentsFailure) {
                          setState(() {
                            shipments = [];
                          });
                        }
                      },
                      builder: (context, state) {
                        return _buildMainContent(
                          shipments: shipments,
                          isLoading: state is GetAllShipmentsLoading,
                          errorMessage: state is GetAllShipmentsFailure
                              ? state.errorMessage
                              : null,
                        );
                      },
                      buildWhen: (previous, current) =>
                          current is GetAllShipmentsSuccess ||
                          current is GetAllShipmentsFailure ||
                          current is GetAllShipmentsLoading,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent({
    required List<ShipmentModel> shipments,
    required bool isLoading,
    String? errorMessage,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            _refreshShipments();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                ShipmentsCalenderTitle(),
                const SizedBox(height: 20),

                // Show loading or error or content
                if (isLoading)
                  const SizedBox(
                    height: 400,
                    child: Center(child: CustomLoadingIndicator()),
                  )
                else if (errorMessage != null)
                  SizedBox(
                    height: 400,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            errorMessage,
                            style: AppStyles.styleMedium18(
                              context,
                            ).copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _refreshShipments,
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة المحاولة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      ShipmentsCalendarHeader(
                        currentDate: _currentDate,
                        onPreviousMonth: _navigateToPreviousMonth,
                        onNextMonth: _navigateToNextMonth,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        height: 320,
                        child: ShipmentsCalendarGrid(
                          shipments: shipments,
                          currentDate: _currentDate,
                          selectedDate: _selectedDate,
                          onDateSelected: _onDateSelected,
                        ),
                      ),
                      if (_selectedDate != null)
                        ShipmentsCalendarDetails(
                          shipments: shipments,
                          selectedDate: _selectedDate!,
                          imageUrl: _imageUrl,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPreviousMonth() {
    setState(() {
      _currentDate = CalendarUtils.getPreviousMonth(_currentDate);
      _selectedDate = null;
    });
    _fetchShipmentsForMonth(_currentDate);
  }

  void _navigateToNextMonth() {
    setState(() {
      _currentDate = CalendarUtils.getNextMonth(_currentDate);
      _selectedDate = null;
    });
    _fetchShipmentsForMonth(_currentDate);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }
}
