import 'package:familyai/l10n/cb_localizations.dart';
import 'package:familyai/ui/kit/context_ext.dart';
import 'package:familyai/ui/kit/generic_button.dart';
import 'package:familyai/ui/kit/input_box.dart';
import 'package:familyai/ui/kit/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class AddInvitePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddInviteBloc(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<AddInviteBloc>(context);
    final locale = CbLocale.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: Text(
          locale.add_member,
          style: AppStyles.black_22_500,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.padding1),
        child: Column(
          children: [
            LabeledInputBox(
              formatters: [nameInputFormatter],
              controller: bloc.firstName,
              hint: locale.first_name_hint_required,
            ),
            SizedBox(
              height: AppSizes.padding2,
            ),
            LabeledInputBox(
              formatters: [nameInputFormatter],
              controller: bloc.lastName,
              hint: locale.last_name_hint_required,
            ),
            SizedBox(
              height: AppSizes.padding2,
            ),
            LabeledInputBox(
              formatters: const [],
              controller: bloc.email,
              hint: locale.email_hint_required,
            ),
            SizedBox(
              height: AppSizes.padding2,
            ),

            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final topics = await bloc.topics();
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            scrollable: false,
                            contentPadding: EdgeInsets.zero,
                            content: Container(
                              width: double.maxFinite,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: topics.length,
                                itemBuilder: (context, index) {
                                  final item = topics[index];
                                  return ListTile(
                                    title: Text(item["title"]),
                                    onTap: () {
                                      bloc.topic.value = item;
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              ),
                            ));
                      },
                    );
                  }
                  // pickGender(context,locale,(gender){
                  //   bloc.genderValue.value = gender;
                  // });
                },
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: ValueListenableBuilder(
                    valueListenable: bloc.topic,
                    builder: (context, value, child) {
                      if (value == null) {
                        return Text(
                          locale.topic,
                          style: AppStyles.grey_16_400,
                        );
                      } else {
                        return Text(
                          value["title"],
                          style: AppStyles.black_16_400,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppSizes.padding2,
            ),

            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final roles = await bloc.roles();
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            scrollable: false,
                            contentPadding: EdgeInsets.zero,
                            content: Container(
                              width: double.maxFinite,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: roles.length,
                                itemBuilder: (context, index) {
                                  final item = roles[index];
                                  return ListTile(
                                    title: Text(item["title"]),
                                    onTap: () {
                                      bloc.role.value = item;
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              ),
                            ));
                      },
                    );
                  }

                },
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10))),
                  child: ValueListenableBuilder(
                    valueListenable: bloc.role,
                    builder: (context, value, child) {
                      if (value == null) {
                        return Text(
                          locale.role,
                          style: AppStyles.grey_16_400,
                        );
                      } else {
                        return Text(
                          value["title"],
                          style: AppStyles.black_16_400,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppSizes.padding2,
            ),
            ValueListenableBuilder(
              valueListenable: bloc.enabled,
              builder: (context, value, child) {
                return SimpleLabelledButton(
                  label: locale.invite,
                  enabled: value,
                  onClick: () async {
                    if (await bloc.invite()) {
                      QR.replaceAll("/dashboard");
                      if (context.mounted) {
                        context.showSnackError(message: locale.member_invited);
                      }
                    } else {
                      if (context.mounted) {
                        context.showSnackError();
                      }
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
