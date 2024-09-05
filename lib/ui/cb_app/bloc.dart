import 'package:bloc/bloc.dart';
import 'package:familyai/di/service_locator.dart';

import 'event.dart';
import 'state.dart';

class CbAppBloc extends Bloc<CbAppEvent, CbAppState> {
  CbAppBloc() : super(CbAppStateLoading()) {
    on<InitEvent>(_init);
    on<UpdateEvent>(_update);
    add(InitEvent());
  }

  void _update(UpdateEvent event, Emitter<CbAppState> emit) async {
    emit(event.state);
  }
  void _init(InitEvent event, Emitter<CbAppState> emit) async {
    await setupLocator();
    add(UpdateEvent(state: CbAppStateAvatar()));
  }
}
