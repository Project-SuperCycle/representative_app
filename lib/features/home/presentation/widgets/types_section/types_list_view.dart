import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/services/dosh_types_manager.dart';
import 'package:supercycle/core/services/services_locator.dart';
import 'package:supercycle/features/home/data/managers/home_cubit/home_cubit.dart';
import 'package:supercycle/features/home/presentation/widgets/types_section/type_card_item.dart';

class TypesListView extends StatefulWidget {
  const TypesListView({super.key});

  @override
  State<TypesListView> createState() => _TypesListViewState();
}

class _TypesListViewState extends State<TypesListView> {
  @override
  void initState() {
    super.initState();
    // عند فتح الـ widget، اعرض الداتا المخزنة لو موجودة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<HomeCubit>();
      if (cubit.cachedDoshTypes != null && cubit.cachedDoshTypes!.isNotEmpty) {
        // عمل emit للداتا المخزنة عشان الـ UI يعرضها
        cubit.emit(FetchDoshTypesSuccess(doshTypes: cubit.cachedDoshTypes!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is FetchDoshTypesFailure) {
          CustomSnackBar.showError(context, state.message);
        }
        if (state is FetchDoshTypesSuccess) {
          List<DoshItem> typesList = state.doshTypes
              .map((e) => DoshItem(id: e.id, name: e.name, price: e.maxPrice))
              .toList();
          getIt<DoshTypesManager>().setTypesList(typesList);
        }
      },
      builder: (context, state) {
        if (state is FetchDoshTypesLoading) {
          return const Center(child: CustomLoadingIndicator());
        }

        if (state is FetchDoshTypesSuccess) {
          if (state.doshTypes.isEmpty) {
            return const Center(child: Text('No Dosh Types'));
          }
          final items = state.doshTypes;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items
                  .map(
                    (item) => IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        child: TypeCardItem(typeModel: item),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        }

        return Container();
      },
      buildWhen: (previous, current) =>
          current is FetchDoshTypesSuccess ||
          current is FetchDoshTypesFailure ||
          current is FetchDoshTypesLoading,
    );
  }
}
