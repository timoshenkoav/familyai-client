import 'state.dart';

abstract class CbAppEvent {}

class InitEvent extends CbAppEvent {}
class UpdateEvent extends CbAppEvent {
  final CbAppState state;

  UpdateEvent({required this.state});
}