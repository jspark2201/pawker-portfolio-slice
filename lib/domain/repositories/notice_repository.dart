import 'package:pawker/domain/entities/notice/notice.dart';

abstract class NoticeRepository {
  Future<NoticeList> getNotices({required int limit, required int offset});
}
