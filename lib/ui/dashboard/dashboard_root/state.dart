class DashboardRootState {

}

class DashboardRootStateLoading extends DashboardRootState{}
class DashboardRootStateData extends DashboardRootState{
  final List<dynamic> members;

  DashboardRootStateData({required this.members});
}
