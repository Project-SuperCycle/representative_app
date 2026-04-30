import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:representative_app/core/helpers/custom_snack_bar.dart';
import 'package:representative_app/features/finances/data/cubits/get_finances_cubit.dart';
import 'package:representative_app/features/finances/presentation/widgets/history/finance_transaction_card.dart';
import 'package:representative_app/features/finances/presentation/widgets/loading/finance_transaction_loading_card.dart';
import 'package:representative_app/features/finances/presentation/widgets/loading/finances_transactions_empty.dart';

// ======== Transactions List Section ========
class TransactionsListSection extends StatelessWidget {
  const TransactionsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetFinancesCubit, GetFinancesState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is GetFinancesFailure) {
          CustomSnackBar.showError(context, state.errMessage);
        }
      },
      builder: (context, state) {
        if (state is GetFinancesLoading) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => FinanceTransactionLoadingCard(),
          );
        }
        if (state is GetFinancesSuccess && state.finances.isEmpty) {
          return Center(child: FinancesTransactionsEmpty());
        }

        if (state is GetFinancesSuccess && state.finances.isNotEmpty) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.finances.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                FinanceTransactionCard(transaction: state.finances[index]),
          );
        }

        return Center(child: FinancesTransactionsEmpty());
      },
    );
  }
}
