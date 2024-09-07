import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:familyai/di/service_locator.dart';
import 'package:familyai/domain/repo/user_repository.dart';
import 'package:familyai/ui/kit/password_visibility.dart';
import 'package:flutter/cupertino.dart';

import 'event.dart';
import 'state.dart';

class AuthRootBloc extends Bloc<AuthRootEvent, AuthRootState> {
  final email = TextEditingController();
  final password = TextEditingController();
  final enabled = ValueNotifier(false);
  final passwordVisibility = PasswordVisibility();
  final UserRepository _userRepository = getIt();
  AuthRootBloc() : super(AuthRootState().init()) {
    on<InitEvent>(_init);
    email.addListener(_update);
    password.addListener(_update);
  }

  @override
  Future<void> close() {
    email.removeListener(_update);
    password.removeListener(_update);
    return super.close();
  }

  void _update() {
    enabled.value = email.text.trim().isNotEmpty && password.text.isNotEmpty;
  }
  void _init(InitEvent event, Emitter<AuthRootState> emit) async {
    emit(state.clone());
  }

  Future<SignInResult> signIn() async{
    return _userRepository.signIn(email.text, password.text);
  }
}
