import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/domain/entities/point_history_item.dart';

part 'point_history_response.freezed.dart';
part 'point_history_response.g.dart';

@freezed
abstract class PointHistoryResponse with _$PointHistoryResponse {
  const factory PointHistoryResponse({
    required List<PointHistoryItem> items,
    required int total,
    required int limit,
    required int offset,
    required bool hasMore,
  }) = _PointHistoryResponse;

  factory PointHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$PointHistoryResponseFromJson(json);
}
