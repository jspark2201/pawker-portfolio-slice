import 'dart:io';
import 'package:pawker/domain/entities/feed/feed.dart';

abstract class FeedRepository {
  Future<FeedPost> createFeedPost({
    required String content,
    List<String> imageUrls,
    String? walkRecordId,
    String? regionCode,
  });

  Future<FeedListResponse> getFeedList({
    String? sort,
    bool? hasWalkRecord,
    String? period,
    String? regionCode,
    int? limit,
    int? offset,
    bool? onlyMine,
  });

  Future<FeedPost> getFeedPost(String postId);

  Future<FeedPost> updateFeedPost(String postId, {String? content, List<String>? imageUrls, String? regionCode, String? walkRecordId});

  Future<void> deleteFeedPost(String postId);

  /// 이미지 파일들을 순서대로 업로드하고, 생성된 post에 반영한 뒤 해당 FeedPost 반환.
  /// [postId]는 이미 생성된 게시글 id (이미지 없이 먼저 생성한 경우).
  Future<FeedPost> uploadFeedImages(String postId, List<File> imageFiles);

  /// 이미지 파일들만 업로드하고 URL 목록만 반환. 게시글에는 반영하지 않음 (수정 시 사용).
  Future<List<String>> uploadFeedImageFiles(String postId, List<File> imageFiles);

  Future<void> likeFeedPost(String postId);

  Future<void> unlikeFeedPost(String postId);

  Future<FeedCommentListResponse> getFeedComments(String postId, {int? limit, int? offset});

  /// 최상위 댓글만 작성
  Future<FeedComment> createFeedComment(String postId, {required String content});

  /// 대댓글 작성 (commentId = 부모 댓글 ID)
  Future<FeedComment> createFeedReply(String postId, String commentId, {required String content});

  /// 해당 댓글의 대댓글 목록 (5개씩 등 limit/offset)
  Future<FeedCommentListResponse> getFeedReplies(String postId, String commentId, {int? limit, int? offset});

  Future<FeedComment> updateFeedComment(String postId, String commentId, String content);

  Future<void> deleteFeedComment(String postId, String commentId);

  Future<void> reportFeedComment(String postId, String commentId, {required String reason, String? description});

  Future<void> hideFeedPost(String postId);

  Future<void> unhideFeedPost(String postId);

  Future<void> reportFeedPost(String postId, {required String reason, String? description});
}
