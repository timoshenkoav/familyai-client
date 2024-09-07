import 'package:bloc/bloc.dart';
import 'package:familyai/di/service_locator.dart';
import 'package:familyai/domain/repo/user_repository.dart';
import 'package:familyai/ui/kit/password_visibility.dart';
import 'package:flutter/cupertino.dart';

import 'event.dart';
import 'state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final terms = ValueNotifier(false);
  final enabled = ValueNotifier(false);
  final passwordVisibility = PasswordVisibility();
  final confirmPasswordVisibility = PasswordVisibility();
  final UserRepository _userRepository = getIt();
  SignUpBloc() : super(SignUpState().init()) {
    on<InitEvent>(_init);
    email.addListener(_update);
    password.addListener(_update);
    confirmPassword.addListener(_update);
    terms.addListener(_update);
  }
  void _update(){
    final op = [
      email.text.trim().isNotEmpty,
      password.text.trim().isNotEmpty,
      password.text == confirmPassword.text,
      terms.value
    ];
    enabled.value = op.every((element) => element,);
  }
  @override
  Future<void> close() {
    email.removeListener(_update);
    password.removeListener(_update);
    confirmPassword.removeListener(_update);
    terms.removeListener(_update);
    return super.close();
  }

  void _init(InitEvent event, Emitter<SignUpState> emit) async {
    emit(state.clone());
  }

  Future<SignInResult>signUp() async{
    return _userRepository.signUp(email.text, password.text);
  }
}
