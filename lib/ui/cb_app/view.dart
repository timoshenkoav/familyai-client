import 'package:familyai/di/service_locator.dart';
import 'package:familyai/domain/repo/user_repository.dart';
import 'package:familyai/l10n/cb_localizations.dart';
import 'package:familyai/ui/auth/auth_profile/view.dart';
import 'package:familyai/ui/auth/auth_root/view.dart';
import 'package:familyai/ui/auth/sign_up/view.dart';
import 'package:familyai/ui/avatar/view.dart';
import 'package:familyai/ui/dashboard/add_invite/view.dart';
import 'package:familyai/ui/dashboard/dashboard_root/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class AuthCompleteMiddleware extends QMiddleware {
  @override
  Future<String?> redirectGuard(String path) async {
    print("guard AuthCompleteMiddleware");
    final UserRepository userRepository = getIt();
    if (!await userRepository.hasUser()) {
      return "/auth";
    }
    if (!await userRepository.hasCompleteUser()) {
      return "/auth/profile";
    }

    return null;
  }
}

class AuthMiddleware extends QMiddleware {
  @override
  Future<String?> redirectGuard(String path) async {
    print("guard AuthMiddleware");
    final UserRepository userRepository = getIt();
    if (!await userRepository.hasUser()) {
      return "/auth";
    }

    return null;
  }
}

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

    return _buildApp(context);
  }

  Widget _buildApp(BuildContext context) {
    final routes = [
      QRoute(
          path: "/",
          builder: () {
            return const Text("root");
          },
          middleware: [AuthMiddleware()]),

      QRoute(
          path: "/dashboard",
          builder: () {
            return const DashboardRootPage();
          },
          children: [
            QRoute(
                path: "/invite",
                builder: () {
                  return AddInvitePage();
                }),
          ],
          middleware: [AuthCompleteMiddleware()]),
      QRoute(
          path: "/auth",
          builder: () {
            return const AuthRootPage();
          },
          children: [
            QRoute(
              path: "/create",
              builder: () {
                return const SignUpPage();
              },
            ),
            QRoute(
              path: "/profile",
              builder: () {
                return const AuthProfilePage();
              },
            )
          ]
      ),
      QRoute(path: "/:avatarId", builder: (){
        final avatarId = QR.params.asValueMap["avatarId"]!;
        return AvatarPage(avatarId: avatarId,);
      })
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
      routerDelegate:
          QRouterDelegate(routes, initPath: "/dashboard", observers: []),
      routeInformationParser: const QRouteInformationParser(),
    );
  }
}
