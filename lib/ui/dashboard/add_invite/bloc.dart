import 'package:bloc/bloc.dart';
import 'package:familyai/di/service_locator.dart';
import 'package:familyai/domain/repo/api_repository.dart';
import 'package:familyai/domain/repo/members_repository.dart';
import 'package:familyai/domain/repo/user_repository.dart';
import 'package:flutter/cupertino.dart';

import 'event.dart';
import 'state.dart';

class AddInviteBloc extends Bloc<AddInviteEvent, AddInviteState> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final enabled = ValueNotifier(false);
  final topic = ValueNotifier<dynamic>(null);
  final role = ValueNotifier<dynamic>(null);

  // final topics = ValueNotifier<List<dynamic>>([]);
  final ApiRepository _apiRepository = getIt();
  final UserRepository _userRepository = getIt();
  final MembersRepository _membersRepository = getIt();

  AddInviteBloc() : super(AddInviteState().init()) {
    on<InitEvent>(_init);
    add(InitEvent());
    firstName.addListener(_update);
    lastName.addListener(_update);
    email.addListener(_update);
    topic.addListener(_update);
    role.addListener(_update);
  }

  void _update() {
    final op = [
      firstName.text.trim().isNotEmpty,
      lastName.text.trim().isNotEmpty,
      email.text.trim().isNotEmpty,
      topic.value != null,
      role.value != null
    ];
    enabled.value = op.every(
      (element) => element,
    );
  }

  @override
  Future<void> close() {
    firstName.removeListener(_update);
    lastName.removeListener(_update);
    email.removeListener(_update);
    topic.removeListener(_update);
    role.removeListener(_update);
    return super.close();
  }

  void _init(InitEvent event, Emitter<AddInviteState> emit) async {
    emit(state.clone());
  }

  Future<List<dynamic>> topics() {
    return _apiRepository.topics();
  }
  Future<List<dynamic>> roles() {
    return _apiRepository.roles();
  }

  Future<bool> invite() async {
    return _membersRepository.createMember(
        firstName.text, lastName.text, email.text, topic.value, role.value);
  }
}
