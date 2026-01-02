import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer, BlocProvider;
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/routes/end_points.dart' show EndPoints;
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/widgets/auth/auth_main_layout.dart';
import 'package:supercycle/core/widgets/custom_button.dart';
import 'package:supercycle/core/widgets/custom_text_form_field.dart';
import 'package:supercycle/core/widgets/rounded_container.dart';
import 'package:supercycle/features/sign_up/data/managers/sign_up_cubit/sign_up_cubit.dart';
import 'package:supercycle/features/sign_up/data/models/business_information_model.dart'
    show BusinessInformationModel;
import 'package:supercycle/features/sign_up/presentation/widgets/privacy_policy_checkbox.dart'
    show PrivacyPolicyCheckbox;
import 'package:supercycle/generated/l10n.dart';

class SignUpDetailsViewBody extends StatefulWidget {
  const SignUpDetailsViewBody({super.key});

  @override
  State<SignUpDetailsViewBody> createState() => _SignUpDetailsViewBodyState();
}

class _SignUpDetailsViewBodyState extends State<SignUpDetailsViewBody> {
  final _formKey = GlobalKey<FormState>();
  bool isAgreed = false;

  final _controllers = {
    'businessName': TextEditingController(),
    'rawBusinessType': TextEditingController(),
    'businessAddress': TextEditingController(),
    'doshManagerName': TextEditingController(),
    'doshManagerPhone': TextEditingController(),
  };

  void handleCompleteSignUp() {
    if (!isAgreed) {
      CustomSnackBar.showWarning(
        context,
        S.of(context).privacy_policy_required,
      );

      return;
    }

    if (_formKey.currentState!.validate()) {
      final businessInformation = BusinessInformationModel(
        bussinessName: _controllers['businessName']!.text,
        rawBusinessType: _controllers['rawBusinessType']!.text,
        bussinessAdress: _controllers['businessAddress']!.text,
        doshMangerName: _controllers['doshManagerName']!.text,
        doshMangerPhone: _controllers['doshManagerPhone']!.text,
      );
      BlocProvider.of<SignUpCubit>(context).completeSignup(businessInformation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is CompleteSignUpSuccess) {
          GoRouter.of(context).pushReplacement(EndPoints.signInView);
        }
        if (state is CompleteSignUpFailure) {
          CustomSnackBar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        return AuthMainLayout(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.20),
              Expanded(
                child: RoundedContainer(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          S.of(context).entity_information,
                          style: AppStyles.styleSemiBold20(context),
                        ),
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: _controllers['businessName'],
                              labelText: S.of(context).entity_name,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: _controllers['rawBusinessType'],
                              labelText: S.of(context).entity_type,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: _controllers['businessAddress'],
                              labelText: S.of(context).entity_address,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: _controllers['doshManagerName'],
                              labelText: S.of(context).administrator_name,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: _controllers['doshManagerPhone'],
                              labelText: S.of(context).administrator_phone,
                            ),
                            const SizedBox(height: 20),
                            PrivacyPolicyCheckbox(
                              initialValue: isAgreed,
                              onChanged: (bool value) {
                                setState(() {
                                  isAgreed = value;
                                });
                              },
                            ),
                            const SizedBox(height: 30),
                            (state is CompleteSignUpLoading)
                                ? const CustomLoadingIndicator()
                                : CustomButton(
                                    title: S.of(context).signUp_button,
                                    onPress: handleCompleteSignUp,
                                    enabled: isAgreed,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
