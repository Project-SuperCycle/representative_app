import 'package:flutter/material.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/environment/data/models/trader_eco_info_model.dart';
import 'package:supercycle/features/environment/presentation/widgets/trees_tab/eco_transaction_card.dart';

class EnvironmentalTransactionsTab extends StatefulWidget {
  final TraderEcoInfoModel ecoInfoModel;

  const EnvironmentalTransactionsTab({super.key, required this.ecoInfoModel});

  @override
  State<EnvironmentalTransactionsTab> createState() =>
      _EnvironmentalTransactionsTabState();
}

class _EnvironmentalTransactionsTabState
    extends State<EnvironmentalTransactionsTab> {
  // Pagination settings
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  bool _isLoading = false;

  int get _totalPages =>
      (widget.ecoInfoModel.transactions.length / _itemsPerPage).ceil();

  int get _startIndex => (_currentPage - 1) * _itemsPerPage;

  int get _endIndex {
    final end = _startIndex + _itemsPerPage;
    return end > widget.ecoInfoModel.transactions.length
        ? widget.ecoInfoModel.transactions.length
        : end;
  }

  List<dynamic> get _currentPageTransactions {
    if (widget.ecoInfoModel.transactions.isEmpty) return [];
    return widget.ecoInfoModel.transactions.sublist(_startIndex, _endIndex);
  }

  Future<void> _goToPage(int page) async {
    if (page < 1 || page > _totalPages || page == _currentPage) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _currentPage = page;
      _isLoading = false;
    });
  }

  Future<void> _nextPage() async {
    if (_currentPage < _totalPages) {
      await _goToPage(_currentPage + 1);
    }
  }

  Future<void> _previousPage() async {
    if (_currentPage > 1) {
      await _goToPage(_currentPage - 1);
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ecoInfoModel.transactions.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: const Color(0xFF10B981),
      child: CustomScrollView(
        slivers: [
          // Header Section
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المعاملات البيئية',
                        style: AppStyles.styleSemiBold18(context),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withAlpha(50),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'إجمالي: ${widget.ecoInfoModel.transactions.length}',
                            style: AppStyles.styleSemiBold12(
                              context,
                            ).copyWith(color: const Color(0xFF10B981)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Transactions List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            sliver: _isLoading
                ? SliverToBoxAdapter(
                    child: SizedBox(
                      height: 400,
                      child: Center(child: CustomLoadingIndicator()),
                    ),
                  )
                : SliverList.builder(
                    itemBuilder: (context, index) {
                      return EcoTransactionCard(
                        transaction: _currentPageTransactions[index],
                      );
                    },
                    itemCount: _currentPageTransactions.length,
                  ),
          ),

          // Pagination Controls
          SliverToBoxAdapter(child: _buildPaginationControls()),

          // Bottom Spacing
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.grey[300], thickness: 0.6),
          ),

          // Navigation controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous button
              _buildNavigationButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: _currentPage > 1 ? _previousPage : null,
                tooltip: 'الصفحة السابقة',
              ),

              const SizedBox(width: 12),

              // Page indicator
              _buildPageIndicator(),

              const SizedBox(width: 12),

              // Next button
              _buildNavigationButton(
                icon: Icons.arrow_forward_ios_rounded,
                onPressed: _currentPage < _totalPages ? _nextPage : null,
                tooltip: 'الصفحة التالية',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    final isEnabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: isEnabled ? const Color(0xFF10B981) : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Icon(
                icon,
                color: isEnabled ? Colors.white : Colors.grey[500],
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF10B981).withAlpha(150),
          width: 1.5,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '$_currentPage',
          style: AppStyles.styleSemiBold16(context).copyWith(
            color: const Color(0xFF10B981),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'لا توجد معاملات',
            style: AppStyles.styleSemiBold16(
              context,
            ).copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم عرض معاملاتك البيئية هنا',
            style: AppStyles.styleSemiBold12(
              context,
            ).copyWith(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
