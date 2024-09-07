import 'dart:async';

import 'state.dart';

abstract class LoadingButtonEvent {}

class LoadEvent extends LoadingButtonEvent {
  final FutureOr<void> Function() action;

  LoadEvent({required this.action});
}
class InitEvent extends LoadingButtonEvent {
  final LoadingButtonState state;

  InitEvent({required this.state});
}