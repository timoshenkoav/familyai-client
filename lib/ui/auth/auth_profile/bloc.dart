import 'package:bloc/bloc.dart';
import 'package:familyai/di/service_locator.dart';
import 'package:familyai/domain/repo/user_repository.dart';
import 'package:flutter/cupertino.dart';

import 'event.dart';
import 'state.dart';

class AuthProfileBloc extends Bloc<AuthProfileEvent, AuthProfileState> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final enabled = ValueNotifier(false);
  final UserRepository _userRepository = getIt();
  AuthProfileBloc() : super(AuthProfileState().init()) {
    on<InitEvent>(_init);
    firstName.addListener(_update);
    lastName.addListener(_update);
  }
  void _update(){
    final op = [
      firstName.text.trim().isNotEmpty,
      lastName.text.trim().isNotEmpty
    ];
    enabled.value = op.every((element) => element,);
  }
  @override
  Future<void> close() {
    firstName.removeListener(_update);
    lastName.removeListener(_update);
    return super.close();
  }
  void _init(InitEvent event, Emitter<AuthProfileState> emit) async {
    emit(state.clone());
  }

  Future<bool>save() {
    return _userRepository.update(firstName: firstName.text,lastName: lastName.text);
  }
}
