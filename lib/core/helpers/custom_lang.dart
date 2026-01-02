import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supercycle/core/cubits/local_cubit/local_cubit.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/generated/l10n.dart';

import 'custom_dropdown.dart';

class CustomLang extends StatelessWidget {
  const CustomLang({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(S.of(context).title, style: AppStyles.styleMedium24(context)),
        const SizedBox(width: 20),
        SizedBox(
          width: 150,
          child: BlocBuilder<LocalCubit, LocalState>(
            builder: (context, state) {
              return CustomDropdown(
                options: const ["ar", "en"],
                onChanged: (value) {
                  BlocProvider.of<LocalCubit>(
                    context,
                  ).changeLang(value ?? "ar");
                },
                hintText: S.of(context).lang,
                isSearchable: false,
              );
            },
          ),
        ),
      ],
    );
  }

  bool isArabic() => Intl.getCurrentLocale() == 'ar';
}
