import 'package:bloc/bloc.dart';

import 'event.dart';
import 'state.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  AvatarBloc() : super(AvatarState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<AvatarState> emit) async {
    emit(state.clone());
  }
}
