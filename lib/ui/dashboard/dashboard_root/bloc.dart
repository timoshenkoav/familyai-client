import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:familyai/di/service_locator.dart';
import 'package:familyai/domain/repo/api_repository.dart';
import 'package:familyai/domain/repo/members_repository.dart';

import 'event.dart';
import 'state.dart';

class DashboardRootBloc extends Bloc<DashboardRootEvent, DashboardRootState> {
  final ApiRepository _apiRepository = getIt();
  final MembersRepository _membersRepository = getIt();
  final subs = <StreamSubscription>[];
  DashboardRootBloc() : super(DashboardRootStateLoading()) {
    on<InitEvent>(_init);
    on<UpdateEvent>(_update);
    add(InitEvent());
    subs.add(_membersRepository.listen().listen((data){
      add(UpdateEvent(state: DashboardRootStateData(members: data)));
    }));
  }

  @override
  Future<void> close(){
    for (var e in subs) {
      e.cancel();
    }
    subs.clear();
    return super.close();
  }

  void _update(UpdateEvent event, Emitter<DashboardRootState> emit) async {
    emit(event.state);
  }

  void _init(InitEvent event, Emitter<DashboardRootState> emit) async {
    final members = await _apiRepository.members();
  }
}
