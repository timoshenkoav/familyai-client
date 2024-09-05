import 'package:familyai/di/service_locator.dart';
import 'package:familyai/l10n/cb_localizations.dart';
import 'package:familyai/ui/avatar/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class CbAppPage extends StatelessWidget {
  const CbAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CbAppBloc(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<CbAppBloc>(context);

    return BlocBuilder<CbAppBloc, CbAppState>(builder: (context, state) {
      if (state is CbAppStateAvatar) {
        return _buildApp(context);
      }
      return const Center(child: CircularProgressIndicator.adaptive(),);
    },);
  }

  Widget _buildApp(BuildContext context) {
    final routes = [
      QRoute(
        path: "/splash",
        builder: () {
          return AvatarPage();
        },
      )
    ];
    if (PlatformOpts.instance.isAndroid()) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          statusBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light));
    }
    return MaterialApp.router(
      onGenerateTitle: (context) {
        return CbLocale.of(context)!.app_name;
      },
      onNavigationNotification: (notification) {
        print(notification);
        return true;
      },
      theme: ThemeData(
        useMaterial3: false,
      ),
      localizationsDelegates: CbLocale.localizationsDelegates,
      supportedLocales: CbLocale.supportedLocales,
      routerDelegate: QRouterDelegate(routes, initPath: "/splash", observers: [

      ]),
      routeInformationParser: const QRouteInformationParser(),
    );
  }
}

