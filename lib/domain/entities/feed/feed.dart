import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/feed/feed_comment_api_model.dart';
import 'package:pawker/data/models/feed/feed_comment_author_api_model.dart';
import 'package:pawker/data/models/feed/feed_comment_list_response_api_model.dart';
import 'package:pawker/data/models/feed/feed_list_response_api_model.dart';
import 'package:pawker/data/models/feed/feed_post_api_model.dart';
import 'package:pawker/data/models/feed/feed_post_author_api_model.dart';
import 'package:pawker/data/models/feed/feed_post_image_api_model.dart';
import 'package:pawker/data/models/feed/walk_record_summary_api_model.dart';

part 'feed.freezed.dart';
part 'feed.g.dart';

/// 피드 게시글 작성자
@freezed
abstract class FeedPostAuthor with _$FeedPostAuthor {
  const factory FeedPostAuthor({
    required String id,
    String? nickname,
    String? profileImage,
  }) = _FeedPostAuthor;

  factory FeedPostAuthor.fromJson(Map<String, dynamic> json) => _$FeedPostAuthorFromJson(json);
}

/// 피드 이미지
@freezed
abstract class FeedPostImage with _$FeedPostImage {
  const factory FeedPostImage({
    required String id,
    required String imageUrl,
    @Default(0) int sortOrder,
  }) = _FeedPostImage;

  factory FeedPostImage.fromJson(Map<String, dynamic> json) => _$FeedPostImageFromJson(json);
}

/// 산책 기록 요약 (피드 첨부용)
@freezed
abstract class WalkRecordSummary with _$WalkRecordSummary {
  const factory WalkRecordSummary({
    required String id,
    required String date,
    required int durationSeconds,
    required double distance,
    List<FeedPathPoint>? path,
  }) = _WalkRecordSummary;

  factory WalkRecordSummary.fromJson(Map<String, dynamic> json) => _$WalkRecordSummaryFromJson(json);
}

@freezed
abstract class FeedPathPoint with _$FeedPathPoint {
  const factory FeedPathPoint({
    required double latitude,
    required double longitude,
  }) = _FeedPathPoint;

  factory FeedPathPoint.fromJson(Map<String, dynamic> json) => _$FeedPathPointFromJson(json);
}

/// 피드 게시글 (목록/상세 공통)
@freezed
abstract class FeedPost with _$FeedPost {
  const factory FeedPost({
    required String id,
    required String userId,
    required FeedPostAuthor author,
    required String content,
    @Default([]) List<FeedPostImage> images,
    String? walkRecordId,
    WalkRecordSummary? walkRecord,
    @Default('') String regionCode,
    @Default(0) int viewCount,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    @Default(false) bool likedByMe,
    required String createdAt,
    required String updatedAt,
  }) = _FeedPost;

  factory FeedPost.fromJson(Map<String, dynamic> json) => _$FeedPostFromJson(json);
}

/// 피드 목록 응답
@freezed
abstract class FeedListResponse with _$FeedListResponse {
  const factory FeedListResponse({
    required List<FeedPost> items,
    required int limit,
    required int offset,
    int? total,
  }) = _FeedListResponse;

  factory FeedListResponse.fromJson(Map<String, dynamic> json) => _$FeedListResponseFromJson(json);
}

/// 댓글 작성자
@freezed
abstract class FeedCommentAuthor with _$FeedCommentAuthor {
  const factory FeedCommentAuthor({
    required String id,
    String? nickname,
    String? profileImage,
  }) = _FeedCommentAuthor;

  factory FeedCommentAuthor.fromJson(Map<String, dynamic> json) => _$FeedCommentAuthorFromJson(json);
}

/// 피드 댓글 (대댓글 포함)
@freezed
abstract class FeedComment with _$FeedComment {
  const factory FeedComment({
    required String id,
    required String feedPostId,
    required String userId,
    required FeedCommentAuthor author,
    String? parentCommentId,
    required String content,
    @Default([]) List<FeedComment> replies,
    required String createdAt,
    required String updatedAt,
    String? deletedAt,
  }) = _FeedComment;

  factory FeedComment.fromJson(Map<String, dynamic> json) => _$FeedCommentFromJson(json);
}

/// 댓글 목록 응답
@freezed
abstract class FeedCommentListResponse with _$FeedCommentListResponse {
  const factory FeedCommentListResponse({
    required List<FeedComment> items,
    required int limit,
    required int offset,
  }) = _FeedCommentListResponse;

  factory FeedCommentListResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedCommentListResponseFromJson(json);
}

// --- Mappers (API model → Domain) ---

class FeedPostMapper {
  static FeedPost toDomain(FeedPostApiModel api) {
    return FeedPost(
      id: api.id,
      userId: api.userId,
      author: FeedPostAuthorMapper.toDomain(api.author),
      content: api.content,
      images: api.images.map(FeedPostImageMapper.toDomain).toList(),
      walkRecordId: api.walkRecordId,
      walkRecord: api.walkRecord != null ? WalkRecordSummaryMapper.toDomain(api.walkRecord!) : null,
      regionCode: api.regionCode,
      viewCount: api.viewCount,
      likeCount: api.likeCount,
      commentCount: api.commentCount,
      likedByMe: api.likedByMe,
      createdAt: api.createdAt,
      updatedAt: api.updatedAt,
    );
  }
}

class FeedPostAuthorMapper {
  static FeedPostAuthor toDomain(FeedPostAuthorApiModel api) {
    return FeedPostAuthor(
      id: api.id,
      nickname: api.nickname,
      profileImage: api.profileImage,
    );
  }
}

class FeedPostImageMapper {
  static FeedPostImage toDomain(FeedPostImageApiModel api) {
    return FeedPostImage(
      id: api.id,
      imageUrl: api.imageUrl,
      sortOrder: api.sortOrder,
    );
  }
}

class WalkRecordSummaryMapper {
  static WalkRecordSummary toDomain(WalkRecordSummaryApiModel api) {
    return WalkRecordSummary(
      id: api.id,
      date: api.date,
      durationSeconds: api.durationSeconds,
      distance: api.distance,
      path: api.path?.map((p) => FeedPathPoint(latitude: p.latitude, longitude: p.longitude)).toList(),
    );
  }
}

class FeedListResponseMapper {
  static FeedListResponse toDomain(FeedListResponseApiModel api) {
    return FeedListResponse(
      items: api.items.map(FeedPostMapper.toDomain).toList(),
      limit: api.limit,
      offset: api.offset,
      total: api.total,
    );
  }
}

class FeedCommentMapper {
  static FeedComment toDomain(FeedCommentApiModel api) {
    return FeedComment(
      id: api.id,
      feedPostId: api.feedPostId,
      userId: api.userId,
      author: FeedCommentAuthorMapper.toDomain(api.author),
      parentCommentId: api.parentCommentId,
      content: api.content,
      replies: api.replies.map(FeedCommentMapper.toDomain).toList(),
      createdAt: api.createdAt,
      updatedAt: api.updatedAt,
      deletedAt: api.deletedAt,
    );
  }
}

class FeedCommentAuthorMapper {
  static FeedCommentAuthor toDomain(FeedCommentAuthorApiModel api) {
    return FeedCommentAuthor(
      id: api.id,
      nickname: api.nickname,
      profileImage: api.profileImage,
    );
  }
}

class FeedCommentListResponseMapper {
  static FeedCommentListResponse toDomain(FeedCommentListResponseApiModel api) {
    return FeedCommentListResponse(
      items: api.items.map(FeedCommentMapper.toDomain).toList(),
      limit: api.limit,
      offset: api.offset,
    );
  }
}
