import 'package:freezed_annotation/freezed_annotation.dart';

part 'point_history_item.freezed.dart';
part 'point_history_item.g.dart';

@freezed
abstract class PointHistoryItem with _$PointHistoryItem {
  const factory PointHistoryItem({
    required String id,
    required int points,
    required String type, // 'earn' | 'spend' | 'expire' | 'adjust'
    required String source,
    String? description,
    String? referenceId,
    String? expiresAt,
    required String createdAt,
  }) = _PointHistoryItem;

  factory PointHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$PointHistoryItemFromJson(json);
}
