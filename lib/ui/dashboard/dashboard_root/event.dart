import 'state.dart';

abstract class DashboardRootEvent {}

class InitEvent extends DashboardRootEvent {}
class UpdateEvent extends DashboardRootEvent {
  final DashboardRootState state;

  UpdateEvent({required this.state});
}