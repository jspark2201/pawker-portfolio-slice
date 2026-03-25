import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/reviews/review_stats_api_response.dart';
import 'package:pawker/data/models/reviews/user_reviews_api_response.dart';
import 'package:pawker/data/models/walk_review_api_model.dart';
import 'package:pawker/domain/entities/user.dart';

part 'walk_review.freezed.dart';
part 'walk_review.g.dart';

/// 산책 리뷰 생성 요청 (Domain)
@freezed
abstract class CreateWalkReviewRequest with _$CreateWalkReviewRequest {
  const factory CreateWalkReviewRequest({
    required int rating, // 1-5
    String? reviewText,
  }) = _CreateWalkReviewRequest;

  factory CreateWalkReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateWalkReviewRequestFromJson(json);
}

/// 산책 리뷰 (Domain)
@freezed
abstract class WalkReview with _$WalkReview {
  const factory WalkReview({
    required String id,
    required String walkRecordId,
    required User reviewer,
    required User reviewee,
    required int rating,
    String? reviewText,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WalkReview;

  factory WalkReview.fromJson(Map<String, dynamic> json) =>
      _$WalkReviewFromJson(json);
}

/// 리뷰 통계 (Domain)
@freezed
abstract class ReviewStats with _$ReviewStats {
  const factory ReviewStats({
    required double averageRating,
    required int reviewCount,
    required Map<String, int> ratingDistribution,
  }) = _ReviewStats;

  factory ReviewStats.fromJson(Map<String, dynamic> json) =>
      _$ReviewStatsFromJson(json);
}

/// 사용자 리뷰 목록 (Domain)
@freezed
abstract class UserReviews with _$UserReviews {
  const factory UserReviews({
    required ReviewStats stats,
    required List<WalkReview> recentReviews,
    required int total,
    required int limit,
    required int offset,
    required bool hasMore,
  }) = _UserReviews;

  factory UserReviews.fromJson(Map<String, dynamic> json) =>
      _$UserReviewsFromJson(json);
}

// Mappers
class CreateWalkReviewRequestMapper {
  static WalkReviewApiRequest toApiModel(CreateWalkReviewRequest domain) {
    return WalkReviewApiRequest(
      rating: domain.rating,
      reviewText: domain.reviewText,
    );
  }
}

class WalkReviewMapper {
  static WalkReview toDomain(WalkReviewApiResponse apiModel) {
    return WalkReview(
      id: apiModel.id,
      walkRecordId: apiModel.walkRecordId,
      reviewer: UserMapper.toDomain(apiModel.reviewer),
      reviewee: UserMapper.toDomain(apiModel.reviewee),
      rating: apiModel.rating,
      reviewText: apiModel.reviewText,
      createdAt: DateTime.parse(apiModel.createdAt),
      updatedAt: DateTime.parse(apiModel.updatedAt),
    );
  }

  static List<WalkReview> toDomainList(List<WalkReviewApiResponse> apiModels) {
    return apiModels.map((model) => toDomain(model)).toList();
  }
}

class ReviewStatsMapper {
  static ReviewStats toDomain(ReviewStatsApiResponse apiModel) {
    return ReviewStats(
      averageRating: apiModel.averageRating,
      reviewCount: apiModel.reviewCount,
      ratingDistribution: apiModel.ratingDistribution,
    );
  }
}

class UserReviewsMapper {
  static UserReviews toDomain(UserReviewsApiResponse apiModel) {
    return UserReviews(
      stats: ReviewStatsMapper.toDomain(apiModel.stats),
      recentReviews: WalkReviewMapper.toDomainList(apiModel.recentReviews),
      total: apiModel.total,
      limit: apiModel.limit,
      offset: apiModel.offset,
      hasMore: apiModel.hasMore,
    );
  }
}
