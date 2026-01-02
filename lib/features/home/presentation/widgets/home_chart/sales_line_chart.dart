import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/services/dosh_types_manager.dart';
import 'package:supercycle/core/services/services_locator.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/home/data/managers/home_cubit/home_cubit.dart';
import 'package:supercycle/features/home/data/models/dosh_data_model.dart';
import 'package:supercycle/features/home/data/models/type_history_model.dart';
import 'package:supercycle/generated/l10n.dart';

// Data model for chart (wrapper around TypeHistoryModel)
class ChartPriceData {
  final String month;
  final double price;
  const ChartPriceData({required this.month, required this.price});

  factory ChartPriceData.fromTypeHistory(TypeHistoryModel typeHistory) {
    return ChartPriceData(
      month: _formatMonth(typeHistory.month),
      price: double.tryParse(typeHistory.price.toString()) ?? 0.0,
    );
  }

  static String _formatMonth(String monthString) {
    if (!monthString.contains('-')) return monthString;
    final parts = monthString.split('-');
    if (parts.length < 2) return monthString;
    final monthNum = int.tryParse(parts[1]);
    if (monthNum == null || monthNum < 1 || monthNum > 12) return monthString;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[monthNum - 1];
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({
    required this.priceData,
    this.priceFormatter,
    this.priceInterval,
    this.maxPrice,
    this.minPrice,
    this.showAllMonths = true,
  });

  final List<ChartPriceData> priceData;
  final String Function(double)? priceFormatter;
  final double? priceInterval;
  final double? maxPrice;
  final double? minPrice;
  final bool showAllMonths;

  @override
  Widget build(BuildContext context) {
    return LineChart(chartData, duration: const Duration(milliseconds: 250));
  }

  LineChartData get chartData {
    final max = _getMaxPrice();
    final min = _getMinPrice();
    return LineChartData(
      lineTouchData: _buildLineTouchData(),
      gridData: const FlGridData(show: false),
      titlesData: _buildTitlesData(),
      borderData: _buildBorderData(),
      lineBarsData: [_buildLineChartBarData()],
      minX: 0,
      maxX: (priceData.length - 1).toDouble(),
      maxY: max * 1.1,
      minY: min * 0.9,
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (_) => Colors.blueGrey.withValues(alpha: 0.8),
        getTooltipItems: (spots) => spots.map((spot) {
          final index = spot.x.toInt();
          if (index < 0 || index >= priceData.length) return null;
          final price =
              priceFormatter?.call(spot.y) ?? '\$${spot.y.toStringAsFixed(1)}';
          return LineTooltipItem(
            '${priceData[index].month}\n$price',
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          );
        }).toList(),
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(sideTitles: _buildBottomTitles()),
      leftTitles: AxisTitles(sideTitles: _buildLeftTitles()),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  SideTitles _buildLeftTitles() {
    final max = _getMaxPrice();
    final min = _getMinPrice();
    return SideTitles(
      showTitles: true,
      interval: priceInterval ?? ((max - min) / 4),
      reservedSize: 50,
      getTitlesWidget: (value, meta) {
        const style = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          fontFamily: 'Cairo',
          color: Colors.grey,
        );
        final price =
            priceFormatter?.call(value) ?? '\$${value.toStringAsFixed(1)}';
        return SideTitleWidget(
          meta: meta,
          child: Text(price, style: style, textAlign: TextAlign.center),
        );
      },
    );
  }

  SideTitles _buildBottomTitles() {
    return SideTitles(
      showTitles: true,
      reservedSize: 30,
      interval: showAllMonths ? 1 : null,
      getTitlesWidget: (value, meta) {
        const style = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          fontFamily: 'Cairo',
          color: Colors.grey,
        );
        final index = value.toInt();
        if (index < 0 || index >= priceData.length) {
          return const SizedBox.shrink();
        }
        if (!showAllMonths && index % 3 != 0 && index != priceData.length - 1) {
          return const SizedBox.shrink();
        }
        return SideTitleWidget(
          meta: meta,
          space: 10,
          child: Text(priceData[index].month.toUpperCase(), style: style),
        );
      },
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
          width: 3,
        ),
        left: const BorderSide(color: Colors.transparent),
        right: const BorderSide(color: Colors.transparent),
        top: const BorderSide(color: Colors.transparent),
      ),
    );
  }

  LineChartBarData _buildLineChartBarData() {
    return LineChartBarData(
      isCurved: true,
      color: AppColors.primaryColor,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        color: AppColors.primaryColor.withValues(alpha: 0.1),
      ),
      spots: priceData
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.price))
          .toList(),
    );
  }

  double _getMaxPrice() {
    if (priceData.isEmpty) return 4.0;
    if (maxPrice != null) return maxPrice!;
    return priceData.map((e) => e.price).reduce((a, b) => a > b ? a : b);
  }

  double _getMinPrice() {
    if (minPrice != null) return minPrice!;
    if (priceData.isEmpty) return 0.0;
    final dataMin = priceData
        .map((e) => e.price)
        .reduce((a, b) => a < b ? a : b);
    return dataMin > 0 ? dataMin * 0.9 : 0.0;
  }
}

class SalesLineChart extends StatefulWidget {
  final String Function(double)? priceFormatter;
  final double? priceInterval;
  final double? maxPrice;
  final double? minPrice;
  final bool showAllMonths;

  const SalesLineChart({
    super.key,
    this.priceFormatter,
    this.priceInterval,
    this.maxPrice,
    this.minPrice,
    this.showAllMonths = true,
  });

  @override
  State<SalesLineChart> createState() => SalesLineChartState();
}

class SalesLineChartState extends State<SalesLineChart> {
  String? _selectedTypeId;
  String? _selectedTypeName;
  List<DoshDataModel> _doshData = [];
  bool _isInitialized = false;

  List<String> get _typeOptions {
    try {
      final typesList =
          getIt<DoshTypesManager>().typesList
              .map((type) => type.name)
              .where((name) => name.isNotEmpty)
              .toSet()
              .toList()
            ..sort();
      return typesList;
    } catch (_) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();

    // عرض الداتا المخزنة لو موجودة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<HomeCubit>();

      // عرض TypesData المخزنة
      if (cubit.cachedTypesData != null && cubit.cachedTypesData!.isNotEmpty) {
        cubit.emit(FetchTypesDataSuccess(doshData: cubit.cachedTypesData!));
      }

      // عرض TypeHistory المخزنة
      if (cubit.cachedTypeHistory != null &&
          cubit.cachedTypeHistory!.isNotEmpty) {
        cubit.emit(FetchTypeHistorySuccess(history: cubit.cachedTypeHistory!));
      }
    });
  }

  void _loadTypeHistory([String? typeId]) {
    final id = typeId ?? _selectedTypeId ?? '68a8567bf5a2951a1ee9e982';
    BlocProvider.of<HomeCubit>(context).fetchTypeHistory(typeId: id);
  }

  void _handleDropdownChange(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }

    // إذا كانت _doshData فارغة، استخدم DoshTypesManager
    if (_doshData.isEmpty) {
      try {
        final typesList = getIt<DoshTypesManager>().typesList;

        if (typesList.isEmpty) {
          return;
        }

        // البحث عن النوع المحدد في DoshTypesManager
        final selectedType = typesList.firstWhere(
          (e) => e.name == value,
          orElse: () {
            return typesList.first;
          },
        );

        setState(() {
          _selectedTypeId = selectedType.id;
          _selectedTypeName = selectedType.name;
        });

        _loadTypeHistory(selectedType.id);
        return;
      } catch (e) {
        Logger().e("Error accessing DoshTypesManager: $e");
        return;
      }
    }

    // إذا كانت _doshData موجودة، استخدمها
    try {
      final selectedType = _doshData.firstWhere(
        (e) => e.name == value,
        orElse: () {
          return _doshData.first;
        },
      );

      setState(() {
        _selectedTypeId = selectedType.id;
        _selectedTypeName = selectedType.name;
      });

      _loadTypeHistory(selectedType.id);
    } catch (e) {
      Logger().e("Error in _handleDropdownChange: $e");
    }
  }

  void _initializeSelection(List<DoshDataModel> data) {
    if (_isInitialized || data.isEmpty) return;

    setState(() {
      _doshData = data;
      _selectedTypeId = data.first.id;
      _selectedTypeName = data.first.name;
      _isInitialized = true;
    });

    // لا تعمل fetch هنا لو الداتا موجودة في الـ cache
    final cubit = context.read<HomeCubit>();
    if (cubit.cachedTypeHistory == null || cubit.cachedTypeHistory!.isEmpty) {
      _loadTypeHistory(_selectedTypeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 10),
                child: _buildChart(),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            S.of(context).price_indicator,
            style: AppStyles.styleSemiBold20(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: _buildDropdown(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is FetchTypesDataSuccess) {
          _initializeSelection(state.doshData);
        } else if (state is FetchTypesDataFailure) {
          _showErrorSnackBar(context, state.message);
        }
      },
      buildWhen: (prev, curr) =>
          curr is FetchTypesDataSuccess ||
          curr is FetchTypesDataFailure ||
          curr is FetchTypesDataLoading,
      builder: (context, state) {
        if (state is FetchTypesDataLoading) {
          return _buildLoadingDropdown();
        }

        final options = _doshData.isNotEmpty
            ? _doshData.map((e) => e.name).toList()
            : _typeOptions;

        final currentValue =
            (_selectedTypeName != null && options.contains(_selectedTypeName))
            ? _selectedTypeName
            : (options.isNotEmpty ? options.first : null);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            initialValue: currentValue,
            isExpanded: true,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.recycling, color: Colors.green, size: 20),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              _handleDropdownChange(value);
            },
            icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.grey),
            decoration: InputDecoration(
              hintText: S.of(context).select_type,
              hintStyle: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Widget _buildLoadingDropdown() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withAlpha(100)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          curr is FetchTypeHistorySuccess ||
          curr is FetchTypeHistoryFailure ||
          curr is FetchTypeHistoryLoading,
      builder: (context, state) {
        if (state is FetchTypeHistoryLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (state is FetchTypeHistoryFailure) {
          return _buildErrorWidget(state.message);
        }

        if (state is FetchTypeHistorySuccess) {
          if (state.history.isEmpty) return _buildNoDataWidget();

          final chartData = state.history
              .map(ChartPriceData.fromTypeHistory)
              .toList();

          return _LineChart(
            priceData: chartData,
            priceFormatter: widget.priceFormatter,
            priceInterval: widget.priceInterval,
            maxPrice: widget.maxPrice,
            minPrice: widget.minPrice,
            showAllMonths: widget.showAllMonths,
          );
        }

        return _buildInitialWidget();
      },
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return _buildStatusWidget(
      icon: Icons.error_outline,
      iconColor: Colors.red.withValues(alpha: 0.7),
      title: 'No Data Available',
      titleColor: Colors.red,
      message: errorMessage,
      messageColor: Colors.red.withValues(alpha: 0.8),
      buttonText: 'Retry',
    );
  }

  Widget _buildNoDataWidget() {
    return _buildStatusWidget(
      icon: Icons.analytics_outlined,
      iconColor: Colors.grey.withValues(alpha: 0.7),
      title: 'No data available',
      titleColor: Colors.grey,
      buttonText: 'Load Data',
    );
  }

  Widget _buildInitialWidget() {
    return _buildStatusWidget(
      icon: Icons.show_chart,
      iconColor: AppColors.primaryColor.withValues(alpha: 0.7),
      title: 'Chart ready to load',
      titleColor: AppColors.primaryColor.withValues(alpha: 0.8),
      buttonText: 'Load Chart',
    );
  }

  Widget _buildStatusWidget({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Color titleColor,
    String? message,
    Color? messageColor,
    required String buttonText,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: iconColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: messageColor, fontSize: 12),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadTypeHistory,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    CustomSnackBar.showError(context, message);
  }
}
