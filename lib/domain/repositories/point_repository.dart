import 'package:pawker/domain/entities/point_history_response.dart';

abstract class PointRepository {
  Future<PointHistoryResponse> getPointHistory({int? limit, int? offset});
}
