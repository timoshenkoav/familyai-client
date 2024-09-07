import 'dart:async';

import 'package:familyai/di/service_locator.dart';
import 'package:familyai/domain/repo/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/cb_localizations.dart';
import 'google_sign_in/google_sign_in.dart';

class GoogleButtonBloc extends Bloc<int, bool> {
  final UserRepository _userRepository = getIt();
  final subs = <StreamSubscription>[];
  void Function(SignInResult?)? onClick;

  GoogleButtonBloc() : super(false) {
    subs.add(_userRepository.listenGoogleSignIn().listen(
      (event) async {
        print("listenGoogleSignIn $event");
        final ret = await _userRepository.auth(event);
        onClick?.call(ret);
      },
    ));
  }

  @override
  Future<void> close() {
    for (var element in subs) {
      element.cancel();
    }
    subs.clear();
    return super.close();
  }

  void google() async {
    final ret = await _userRepository.google();
    onClick?.call(ret);
  }

  Widget buildButton(String label, void Function(SignInResult? p1)? onClick) {
    this.onClick = onClick;
    return buildSignInButton(label, onPressed: () async {
      google();
    });
  }
}

class GoogleButton extends StatelessWidget {
  final String label;
  final void Function(SignInResult?)? onClick;

  const GoogleButton({super.key, required this.label, this.onClick});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GoogleButtonBloc(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final locale = CbLocale.of(context)!;
    final bloc = BlocProvider.of<GoogleButtonBloc>(context);
    return bloc.buildButton(label, onClick);
  }
}
