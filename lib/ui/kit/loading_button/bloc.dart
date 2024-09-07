import 'dart:async';

import 'package:bloc/bloc.dart';

import 'event.dart';
import 'state.dart';

class LoadingButtonBloc extends Bloc<LoadingButtonEvent, LoadingButtonState> {
  LoadingButtonBloc() : super(LoadingButtonState(loading: false)) {
    on<InitEvent>(_init);
    on<LoadEvent>(_load);
  }

  void _load(LoadEvent event, Emitter<LoadingButtonState> emit) async {
    try {
      await event.action();
    } catch (ex) {
      print(ex);
    }
    if (!isClosed) {
      add(InitEvent(state: LoadingButtonState(loading: false)));
    }
  }

  void _init(InitEvent event, Emitter<LoadingButtonState> emit) async {
    emit(event.state);
  }

  void onClick(FutureOr<void> Function() action) async {
    add(InitEvent(state: LoadingButtonState(loading: true)));
    add(LoadEvent(action: action));
  }
}
