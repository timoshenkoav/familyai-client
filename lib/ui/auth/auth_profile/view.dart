import 'package:familyai/l10n/cb_localizations.dart';
import 'package:familyai/ui/kit/context_ext.dart';
import 'package:familyai/ui/kit/generic_button.dart';
import 'package:familyai/ui/kit/input_box.dart';
import 'package:familyai/ui/kit/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';


class AuthProfilePage extends StatelessWidget {
  const AuthProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AuthProfileBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<AuthProfileBloc>(context);
    final locale = CbLocale.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.padding2),
            child: LabeledInputBox(
              formatters: [nameInputFormatter],
              controller: bloc.firstName,
              hint: locale.first_name_hint_required,
            ),
          ),
          SizedBox(
            height: AppSizes.padding1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.padding2),
            child: LabeledInputBox(

              formatters: [nameInputFormatter],
              controller: bloc.lastName,
              hint: locale.last_name_hint_required,
            ),
          ),
          SizedBox(
            height: AppSizes.padding1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.padding2),
            child: ValueListenableBuilder(
              valueListenable: bloc.enabled,
              builder: (context, value, child) {
                return SimpleLabelledButton(
                  label: locale.save_and_continue,
                  enabled: value,
                  onClick: () async {
                    if (await bloc.save()) {
                      QR.replaceAll("/dashboard");
                    } else {
                      if (context.mounted) {
                        context.showSnackError();
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
