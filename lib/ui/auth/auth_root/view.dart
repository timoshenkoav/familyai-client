import 'package:familyai/domain/repo/user_repository.dart';
import 'package:familyai/l10n/cb_localizations.dart';
import 'package:familyai/ui/kit/context_ext.dart';
import 'package:familyai/ui/kit/generic_button.dart';
import 'package:familyai/ui/kit/google_sign_in_button.dart';
import 'package:familyai/ui/kit/horizontal_separator_text.dart';
import 'package:familyai/ui/kit/input_box.dart';
import 'package:familyai/ui/kit/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class AuthRootPage extends StatelessWidget {
  const AuthRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AuthRootBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<AuthRootBloc>(context);

    final locale = CbLocale.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
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
                      label: locale.sign_in_with_google,
                      onClick: (ret) {
                        navigateAfterAuth(context, ret);
                      },
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.padding2,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.padding1),
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
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.padding2,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.padding2),
                    child: ValueListenableBuilder(
                      valueListenable: bloc.enabled,
                      builder: (context, value, child) {
                        return SimpleLabelledButton(
                          label: locale.label_continue,
                          enabled: value,
                          onClick: () async {
                            final ret = await bloc.signIn();
                            navigateAfterAuth(context, ret);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.padding2,
                  ),
                  TextButton(
                      onPressed: () {
                        QR.replaceAll("/auth/create");
                      },
                      child: Text(
                        locale.dont_have_an_account,
                        style: AppStyles.black_16_500,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

void navigateAfterAuth(BuildContext context, SignInResult? ret) {
  if (ret is SignInError) {
    String? message;
    if (ret.ex is FirebaseAuthException) {
      final auth = ret.ex as FirebaseAuthException;
      message = auth.message;
    }
    context.showSnackError(message: message);
  } else if (ret is SignInHome) {
    QR.replaceAll("/dashboard");
  } else if (ret is SignInProfile) {
    QR.replaceAll("/auth/profile");
  }
}
