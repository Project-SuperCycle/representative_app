import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/core/constants.dart';
import 'package:representative_app/core/constants/storage_constants.dart';
import 'package:representative_app/core/services/storage_services.dart';
import 'package:representative_app/core/utils/app_styles.dart';
import 'package:representative_app/features/finances/data/cubits/get_finances_cubit.dart';
import 'package:representative_app/features/finances/presentation/widgets/history/pagination_footer.dart';
import 'package:representative_app/features/finances/presentation/widgets/history/transactions_list_section.dart';

class RepresentativeFinancesViewBody extends StatefulWidget {
  const RepresentativeFinancesViewBody({
    super.key,
    required this.onDrawerPressed,
  });

  final VoidCallback onDrawerPressed;

  @override
  State<RepresentativeFinancesViewBody> createState() =>
      _RepresentativeFinancesViewBodyState();
}

int _currentPage = 1;
int _totalPages = 1;

class _RepresentativeFinancesViewBodyState
    extends State<RepresentativeFinancesViewBody> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFinanceTransactions();
  }

  void getFinanceTransactions() async {
    BlocProvider.of<GetFinancesCubit>(
      context,
    ).getRepFinances(page: _currentPage);

    int pages = await StorageServices.readData(StorageConstants.FINANCES_PAGES);
    setState(() {
      _totalPages = pages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: kGradientBackground),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Drawer Button
                  GestureDetector(
                    onTap: widget.onDrawerPressed,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    'المعاملات المالية',
                    textDirection: TextDirection.rtl,
                    style: AppStyles.styleBold20(
                      context,
                    ).copyWith(color: Colors.white),
                  ),

                  // Placeholder لتوازن الـ Row
                  Flexible(child: const SizedBox(width: 40)),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const TransactionsListSection(),
                    const SizedBox(height: 20),
                    PaginationFooter(
                      currentPage: _currentPage,
                      totalPages: _totalPages,
                      onPageChanged: (page) {
                        setState(() => _currentPage = page);
                        getFinanceTransactions();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
