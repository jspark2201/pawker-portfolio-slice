import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

enum NotificationType {
  @JsonValue('walk_request')
  walkRequest,
  @JsonValue('walk_request_accepted')
  walkRequestAccepted,
  @JsonValue('walk_request_rejected')
  walkRequestRejected,
  @JsonValue('walk_request_cancelled')
  walkRequestCancelled,
  @JsonValue('walk_request_resubmitted')
  walkRequestResubmitted,
  @JsonValue('walk_started')
  walkStarted,
  @JsonValue('walk_completed')
  walkCompleted,
  @JsonValue('walk_walker_completed')
  walkWalkerCompleted,
  @JsonValue('walk_cancelled')
  walkCancelled,
  @JsonValue('payment_completed')
  paymentCompleted,
  @JsonValue('walk_tracking_started')
  walkTrackingStarted,
  /// 위치 공유 시작 통보 (워커가 산책 추적 시작 시)
  @JsonValue('location_share_notice')
  locationShareNotice,
  /// 위치 공유 종료 통보 (산책 추적 종료 시)
  @JsonValue('location_share_ended')
  locationShareEnded,
  @JsonValue('system')
  system,
  @JsonValue('promotion')
  promotion,
}

@freezed
abstract class Notification with _$Notification {
  const factory Notification({
    required String id,
    required String title,
    required String message,
    required NotificationType type,
    required DateTime createdAt,
    required bool isRead,
    Map<String, dynamic>? data, // 타입별 추가 데이터
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}

@freezed
abstract class NotificationList with _$NotificationList {
  const factory NotificationList({
    required List<Notification> notifications,
    required int totalCount,
    required int limit,
    required int offset,
    required bool hasMore,
  }) = _NotificationList;

  factory NotificationList.fromJson(Map<String, dynamic> json) =>
      _$NotificationListFromJson(json);
}
