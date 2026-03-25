import 'package:pawker/domain/entities/walker_dashboard.dart';

abstract class WalkerDashboardRepository {
  Future<WalkerDashboard> getDashboard();
}
