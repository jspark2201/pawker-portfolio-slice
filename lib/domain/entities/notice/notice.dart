import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/notice/notice_response_api_model.dart';

part 'notice.freezed.dart';
part 'notice.g.dart';

/// 공지사항 데이터 모델
@freezed
abstract class Notice with _$Notice {
  const factory Notice({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
  }) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
}

@freezed
abstract class NoticeList with _$NoticeList {
  const factory NoticeList({
    required List<Notice> notices,
    required int totalCount,
    required int limit,
    required int offset,
    required bool hasMore,
  }) = _NoticeList;

  factory NoticeList.fromJson(Map<String, dynamic> json) =>
      _$NoticeListFromJson(json);
}

class NoticeListMapper {
  static NoticeList toDomain(NoticeListApiModel apiModel) {
    return NoticeList(
      notices: apiModel.notices.map(NoticeMapper.toDomain).toList(),
      totalCount: apiModel.totalCount,
      limit: apiModel.limit,
      offset: apiModel.offset,
      hasMore: apiModel.hasMore,
    );
  }
}

class NoticeMapper {
  static Notice toDomain(NoticeApiModel apiModel) {
    return Notice(
      id: apiModel.id,
      title: apiModel.title,
      content: apiModel.content,
      createdAt: apiModel.createdAt,
    );
  }
}
