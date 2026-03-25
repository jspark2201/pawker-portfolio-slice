import 'package:pawker/domain/entities/notification.dart';

abstract class NotificationRepository {
  /// 알림 목록을 페이징으로 조회
  Future<NotificationList> getNotifications({
    required int limit,
    required int offset,
  });

  /// 알림을 읽음 처리
  Future<void> markAsRead(String notificationId);

  /// 모든 알림을 읽음 처리
  Future<void> markAllAsRead();

  /// 알림 삭제
  Future<void> deleteNotification(String notificationId);

  /// 읽지 않은 알림 개수 조회
  Future<int> getUnreadCount();
}
