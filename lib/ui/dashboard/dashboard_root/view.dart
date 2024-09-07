import 'package:familyai/l10n/cb_localizations.dart';
import 'package:familyai/l10n/cb_localizations_en.dart';
import 'package:familyai/ui/kit/context_ext.dart';
import 'package:familyai/ui/kit/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class DashboardRootPage extends StatelessWidget {
  const DashboardRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DashboardRootBloc(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<DashboardRootBloc>(context);
    final locale = CbLocale.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          locale.members,
          style: AppStyles.black_22_500,
        ),
      ),
      body: BlocBuilder<DashboardRootBloc, DashboardRootState>(
          builder: (context, state) {
        if (state is DashboardRootStateData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final member = state.members[index];
              return ListTile(
                title: Text(
                  [member["firstName"], member["lastName"]].join(" "),
                  style: AppStyles.black_16_500,
                ),
                subtitle: Text(member["topic"]["title"]),
                trailing: IconButton(
                    onPressed: () async {
                      await Clipboard.setData(
                          ClipboardData(text: member["url"] ?? ""));
                      if (context.mounted) {
                        context.showSnackError(message: locale.copied);
                      }
                    },
                    icon: const Icon(Icons.copy)),
              );
            },
            itemCount: state.members.length,
          );
        }
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          QR.push("/dashboard/invite");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
