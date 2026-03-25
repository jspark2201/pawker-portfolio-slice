import 'package:pawker/domain/entities/walk_review.dart';

abstract class WalkReviewRepository {
  Future<WalkReview> getWalkReviewByWalkRecordId(String id);
  Future<WalkReview> createOrUpdateWalkReview(
    String walkRecordId,
    CreateWalkReviewRequest request,
  );
}
