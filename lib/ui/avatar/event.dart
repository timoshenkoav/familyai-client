import 'package:familyai/ui/avatar/state.dart';

abstract class AvatarEvent {}

class InitEvent extends AvatarEvent {}
class StateEvent extends AvatarEvent {
  final AvatarState state;

  StateEvent({required this.state});
}