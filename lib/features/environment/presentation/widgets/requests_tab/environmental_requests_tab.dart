import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/environment/data/cubits/requests_cubit/requests_cubit.dart';
import 'package:supercycle/features/environment/presentation/widgets/requests_tab/enviromental_request_card.dart';
import 'package:supercycle/features/environment/data/models/environmental_redeem_model.dart';

class EnvironmentalRequestsTab extends StatefulWidget {
  const EnvironmentalRequestsTab({super.key});

  @override
  State<EnvironmentalRequestsTab> createState() =>
      _EnvironmentalRequestsTabState();
}

class _EnvironmentalRequestsTabState extends State<EnvironmentalRequestsTab> {
  // Pagination settings
  int _currentPage = 1;
  List<EnvironmentalRedeemModel> _requests = [];
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    _getTotalPages();
    // Fetch requests when tab is opened
    _fetchRequests(_currentPage);
  }

  void _fetchRequests(int page) {
    context.read<RequestsCubit>().getTraderEcoRequests(page: page);
  }

  void _loadNextPage() {
    if (!_isLoadingMore && _currentPage < totalPages) {
      setState(() {
        _isLoadingMore = true;
        _currentPage++;
      });
      _fetchRequests(_currentPage);
    }
  }

  void _loadPreviousPage() {
    if (_currentPage > 1 && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
        _currentPage--;
      });
      _fetchRequests(_currentPage);
    }
  }

  void _getTotalPages() async {
    final pages = await StorageServices.readData("totalRequests");
    setState(() {
      totalPages = pages ?? 1;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _currentPage = 1;
    });
    _fetchRequests(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestsCubit, RequestsState>(
      listener: (context, state) {
        if (state is RequestsSuccess) {
          setState(() {
            _requests = state.requests;
            _isLoadingMore = false;
            _hasMoreData = _currentPage < totalPages;
          });
        }
        if (state is RequestsFailure) {
          setState(() {
            _isLoadingMore = false;
          });

          CustomSnackBar.showError(context, state.errMessage);
        }
      },
      builder: (context, state) {
        // Loading state - only for initial load
        if (state is RequestsLoading && _requests.isEmpty) {
          return const Center(child: CustomLoadingIndicator());
        }

        // Success state or has cached data
        if (_requests.isNotEmpty) {
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
                              'الطلبات البيئية',
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
                              child: Text(
                                'صفحة $_currentPage من $totalPages',
                                style: AppStyles.styleSemiBold12(
                                  context,
                                ).copyWith(color: const Color(0xFF10B981)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Requests List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  sliver: SliverList.builder(
                    itemBuilder: (context, index) {
                      return EcoRequestCard(request: _requests[index]);
                    },
                    itemCount: _requests.length,
                  ),
                ),

                // Pagination Controls
                SliverToBoxAdapter(child: _buildPaginationControls()),

                // Loading indicator when loading more
                if (_isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CustomLoadingIndicator()),
                    ),
                  ),

                // Bottom Spacing
                const SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ),
          );
        }

        // Empty state
        return _buildEmptyState();
      },
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
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
                onPressed: _currentPage > 1 && !_isLoadingMore
                    ? _loadPreviousPage
                    : null,
                tooltip: 'الصفحة السابقة',
              ),

              const SizedBox(width: 16),

              // Page Number with Total Pages
              _buildPageIndicator(),

              const SizedBox(width: 16),

              // Next button
              _buildNavigationButton(
                icon: Icons.arrow_forward_ios_rounded,
                onPressed: _currentPage < totalPages && !_isLoadingMore
                    ? _loadNextPage
                    : null,
                tooltip: 'الصفحة التالية',
              ),
            ],
          ),
        ],
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
          '$_currentPage / $totalPages',
          style: AppStyles.styleSemiBold16(context).copyWith(
            color: const Color(0xFF10B981),
            fontWeight: FontWeight.bold,
          ),
        ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'لا توجد طلبات',
            style: AppStyles.styleSemiBold16(
              context,
            ).copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم عرض طلباتك البيئية هنا',
            style: AppStyles.styleSemiBold12(
              context,
            ).copyWith(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
