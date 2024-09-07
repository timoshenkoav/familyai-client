import 'package:familyai/l10n/cb_localizations.dart';
import 'package:familyai/ui/auth/auth_root/view.dart';
import 'package:familyai/ui/kit/context_ext.dart';
import 'package:familyai/ui/kit/generic_button.dart';
import 'package:familyai/ui/kit/google_sign_in_button.dart';
import 'package:familyai/ui/kit/horizontal_separator_text.dart';
import 'package:familyai/ui/kit/input_box.dart';
import 'package:familyai/ui/kit/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignUpBloc(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<SignUpBloc>(context);

    final locale = CbLocale.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 54.0),
                    child: Center(
                      child: Text(
                        locale.app_name,
                        style: AppStyles.black_22_500.copyWith(fontSize: 30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.padding2,
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.padding2),
                    child: GoogleButton(
                      label: locale.sign_up_with_google,
                      onClick: (ret) async {
                        navigateAfterAuth(context, ret);
                      },
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.padding2,
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.padding2),
                    child: HorizontalSeparatorText(
                      text: locale.continue_with_email,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.padding2,
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.padding2),
                    child: InputBox(
                        hint: locale.email_hint, controller: bloc.email),
                  ),
                  SizedBox(
                    height: AppSizes.padding1,
                  ),
                  Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.padding2),
                      child: ValueListenableBuilder(
                        valueListenable: bloc.passwordVisibility.stream,
                        builder: (context, value, child) {
                          return InputBox(
                            hint: locale.password_hint,
                            controller: bloc.password,
                            obscureText: !value,
                            trailing: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                iconSize: 20,
                                color: AppColors.grey,
                                constraints: const BoxConstraints(),
                                icon: value
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  bloc.passwordVisibility.toggle();
                                },
                              ),
                            ),
                          );
                        },
                      )),
                  SizedBox(
                    height: AppSizes.padding1,
                  ),
                  Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.padding2),
                      child: ValueListenableBuilder(
                        valueListenable: bloc.confirmPasswordVisibility.stream,
                        builder: (context, value, child) {
                          return InputBox(
                            hint: locale.confirm_password_hint,
                            controller: bloc.confirmPassword,
                            obscureText: !value,
                            trailing: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                iconSize: 20,
                                color: AppColors.grey,
                                constraints: const BoxConstraints(),
                                icon: value
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  bloc.confirmPasswordVisibility.toggle();
                                },
                              ),
                            ),
                          );
                        },
                      )),
                  SizedBox(
                    height: AppSizes.padding1,
                  ),
                  Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.padding2),
                      child: ValueListenableBuilder(
                        valueListenable: bloc.terms,
                        builder: (context, value, child) {
                          return ListTile(
                            onTap: () {
                              bloc.terms.value = !value;
                            },
                            splashColor: Colors.transparent,
                            leading: SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox.adaptive(
                                activeColor: AppColors.lemon,
                                checkColor: Colors.black,
                                value: value,
                                onChanged: (value) {
                                  bloc.terms.value = value ?? false;
                                },
                              ),
                            ),
                            dense: true,
                            horizontalTitleGap: 0,
                            title: Text.rich(TextSpan(
                                text: "I agree with ",
                                style: AppStyles.black_14_400,
                                children: [
                                  TextSpan(
                                      text: "Terms & Conditions",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          try {
                                            final ret = await launchUrl(Uri.parse(
                                                "https://static.doubl.ee/static/terms-and-conditions"));
                                            print("launch $ret");
                                            if (!ret) {
                                              context.showSnackError();
                                            }
                                          } catch (ex) {
                                            context.showSnackError();
                                          }
                                        },
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline))
                                ])),
                            contentPadding: EdgeInsets.zero,
                          );
                        },
                      )),
                  SizedBox(
                    height: AppSizes.padding1,
                  ),
                  ValueListenableBuilder(
                    valueListenable: bloc.enabled,
                    builder: (context, value,child) {
                      return Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.padding2),
                        child: SimpleLabelledButton(
                          label: locale.create_account,
                          enabled: value,
                          onClick: () async {
                            final ret = await bloc.signUp();

                            navigateAfterAuth(context, ret);
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: AppSizes.padding2,
                  ),
                  TextButton(
                      onPressed: () {
                        QR.replaceAll("/auth");
                      },
                      child: Text(
                        locale.already_have_account,
                        style: AppStyles.black_16_500,
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

