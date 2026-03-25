import 'package:dio/dio.dart';
import 'package:pawker/data/models/block/block_list_api_model.dart';
import 'package:pawker/data/models/block/block_response_api_model.dart';
import 'package:pawker/data/models/block/unblock_response_api_model.dart';
import 'package:pawker/data/models/create_user_api_model.dart';
import 'package:pawker/data/models/dog/create_dog_request_api_model.dart';
import 'package:pawker/data/models/dog/dog_api_model.dart';
import 'package:pawker/data/models/dog/update_dog_request_api_model.dart';
import 'package:pawker/data/models/dog/animal_registration_request_api_model.dart';
import 'package:pawker/data/models/dog/animal_registration_response_api_model.dart';
import 'package:pawker/data/models/exchange/exchange_api_model.dart';
import 'package:pawker/data/models/exchange/create_exchange_request_api_model.dart';
import 'package:pawker/data/models/exchange/exchange_request_response_api_model.dart';
import 'package:pawker/data/models/exchange/exchange_request_list_response_api_model.dart';
import 'package:pawker/data/models/faq/faq_api_model.dart';
import 'package:pawker/data/models/notice/notice_response_api_model.dart';
import 'package:pawker/data/models/pet_certification/pet_certification_api_model.dart';
import 'package:pawker/data/models/notification_api_model.dart';
import 'package:pawker/data/models/reviews/review_stats_api_response.dart';
import 'package:pawker/data/models/reviews/user_reviews_api_response.dart';
import 'package:pawker/data/models/user_api_model.dart';
import 'package:pawker/data/models/jwt_token_response.dart';
import 'package:pawker/data/models/upload_response.dart';
import 'package:pawker/data/models/walk_record_api_model.dart';
import 'package:pawker/data/models/create_walk_record_api_model.dart';
import 'package:pawker/data/models/point_history_api_response.dart';
import 'package:pawker/data/models/walk_record_list_api_model.dart';
import 'package:pawker/data/models/walk_summary_api_model.dart';
import 'package:pawker/data/models/walker_dashboard_api_model.dart';
import 'package:pawker/data/models/subscription_verification_api_model.dart';
import 'package:pawker/data/models/walker_job/create_walker_job_request_api_model.dart';
import 'package:pawker/data/models/walker_job_api_model.dart';
import 'package:pawker/data/models/owner_job/create_owner_job_request_api_model.dart';
import 'package:pawker/data/models/owner_job_api_model.dart';
import 'package:pawker/data/models/walk_request_api_model.dart';
import 'package:pawker/data/models/create_walk_request_api_model.dart';
import 'package:pawker/data/models/chat/chat_room_api_model.dart';
import 'package:pawker/data/models/chat/chat_message_api_model.dart';
import 'package:pawker/data/models/chat/create_chat_room_request_api_model.dart';
import 'package:pawker/data/models/chat/send_message_request_api_model.dart';
import 'package:pawker/data/models/chat/chat_room_list_response_api_model.dart';
import 'package:pawker/data/models/chat/chat_message_list_response_api_model.dart';
import 'package:pawker/data/models/walk_schedule/walk_schedule_api_model.dart';
import 'package:pawker/data/models/walk_schedule/walk_schedule_list_response_api_model.dart';
import 'package:pawker/data/models/attendance/attendance_claim_response_api_model.dart';
import 'package:pawker/data/models/attendance/attendance_status_api_model.dart';
import 'package:pawker/data/models/badge_count_response.dart';
import 'package:pawker/data/models/walk_schedule/create_walk_schedule_request_api_model.dart';
import 'package:pawker/data/models/walk_schedule/update_walk_schedule_request_api_model.dart';
import 'package:pawker/data/models/walk_review_api_model.dart';
import 'package:pawker/data/models/report/create_user_report_request_api_model.dart';
import 'package:pawker/data/models/report/user_report_response_api_model.dart';
import 'package:pawker/data/models/reward_box/reward_box_count_api_model.dart';
import 'package:pawker/data/models/user/ban_status_response_api_model.dart';
import 'package:pawker/data/models/user/phone_verification_message_response_api_model.dart';
import 'package:pawker/data/models/user/send_phone_verification_request_api_model.dart';
import 'package:pawker/data/models/user/verify_phone_request_api_model.dart';
import 'package:pawker/data/models/feed/feed_post_api_model.dart';
import 'package:pawker/data/models/feed/feed_list_response_api_model.dart';
import 'package:pawker/data/models/feed/feed_comment_api_model.dart';
import 'package:pawker/data/models/feed/feed_comment_list_response_api_model.dart';
import 'package:pawker/data/models/feed/create_feed_post_request_api_model.dart';
import 'package:pawker/data/models/feed/update_feed_post_request_api_model.dart';
import 'package:pawker/data/models/feed/create_feed_comment_request_api_model.dart';
import 'package:pawker/data/models/feed/create_feed_reply_request_api_model.dart';
import 'package:pawker/data/models/feed/feed_report_request_api_model.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:io';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl, ParseErrorLogger? errorLogger}) =
      _ApiClient;

  @POST("/auth/token")
  Future<JwtTokenResponse> getJWTToken(@Body() Map<String, dynamic> body);

  @POST("/auth/refresh")
  Future<JwtTokenResponse> refreshToken(@Body() Map<String, dynamic> body);

  /// User APIs
  @POST("/users")
  Future<UserApiModel> createUser(@Body() CreateUserApiModel user);

  @GET("/users/email/{email}")
  Future<UserApiModel?> findUserByEmail(@Path("email") String email);

  @GET("/users/{id}")
  Future<UserApiModel?> findUserById(@Path("id") String id);

  @GET("/users/me")
  Future<UserApiModel> getMe();

  @GET("/users/me/ban-status")
  Future<BanStatusResponseApiModel> getBanStatus();

  @DELETE("/users/me")
  Future<void> deleteMe();

  @PATCH("/users/me")
  Future<UserApiModel> updateMe({
    @Field("nickname") String? nickname,
    @Field("phoneNumber") String? phoneNumber,
    @Field("profileImage") String? profileImage,
    @Field("marketingPushAgreed") bool? marketingPushAgreed,
    @Field("marketingEmailAgreed") bool? marketingEmailAgreed,
    @Field("marketingSmsAgreed") bool? marketingSmsAgreed,
  });

  @GET("/users/me/points/history")
  Future<PointHistoryApiResponse> getMyPointsHistory({
    @Query("limit") int? limit,
    @Query("offset") int? offset,
  });

  /// 전화번호 인증번호 발송
  @POST("/users/me/phone/verification/send")
  Future<PhoneVerificationMessageResponseApiModel> sendPhoneVerification(
    @Body() SendPhoneVerificationRequestApiModel request,
  );

  /// 전화번호 인증번호 확인
  @POST("/users/me/phone/verification/verify")
  Future<PhoneVerificationMessageResponseApiModel> verifyPhone(
    @Body() VerifyPhoneRequestApiModel request,
  );

  /// Dog APIs
  @POST("/dogs")
  Future<DogApiModel> createDog(@Body() CreateDogRequestApiModel dog);

  @GET("/dogs/{id}")
  Future<DogApiModel?> findDogById(@Path("id") String id);

  @GET("/dogs")
  Future<List<DogApiModel>> getMyDogs();

  @PATCH("/dogs/{id}")
  Future<DogApiModel> updateDog(
    @Path("id") String id,
    @Body() UpdateDogRequestApiModel dog,
  );

  @DELETE("/dogs/{id}")
  Future<void> deleteDog(@Path("id") String id);

  @POST("/dogs/verify-registration")
  Future<AnimalRegistrationResponseApiModel> verifyDogRegistration(
    @Body() AnimalRegistrationRequestApiModel request,
  );

  /// Walk Record APIs
  @POST("/walk-records")
  Future<WalkRecordApiModel> createWalkRecord(
    @Body() CreateWalkRecordApiModel request,
  );

  @GET("/walk-records")
  Future<WalkRecordListApiModel> getWalkRecords({
    @Query("limit") int? limit,
    @Query("offset") int? offset,
    @Query("ownerWalk") bool? ownerWalk,
  });

  @GET("/walk-records/{id}")
  Future<WalkRecordApiModel> getWalkRecord(@Path("id") String id);

  @GET("/walk-records/{id}/review")
  Future<WalkReviewApiResponse> getWalkReviewByWalkRecordId(
    @Path("id") String id,
  );

  /// 산책 리뷰 생성/수정
  @POST("/walk-records/{id}/review")
  Future<WalkReviewApiResponse> createOrUpdateWalkReview(
    @Path("id") String walkRecordId,
    @Body() WalkReviewApiRequest request,
  );

  /// Upload APIs
  @POST("/upload/profile")
  @MultiPart()
  Future<UploadResponse> uploadUserProfileImage(@Part() File image);

  @DELETE("/upload/profile")
  Future<void> deleteUserProfileImage();

  @POST("/upload/dog/{dogId}")
  @MultiPart()
  Future<UploadResponse> uploadDogProfileImage(
    @Path("dogId") String dogId,
    @Part() File image,
  );

  /// 산책 요약 통계 조회
  @GET("/walk-summary")
  Future<WalkSummaryApiModel> getWalkSummary({
    @Query("userId") required String userId,
    @Query("startDate") required DateTime startDate,
    @Query("endDate") required DateTime endDate,
  });

  /// 목표 설정 조회
  @GET("/goal-settings/{userId}")
  Future<GoalSettingsApiModel> getGoalSettings(@Path("userId") String userId);

  /// 목표 설정 업데이트
  @PUT("/goal-settings/{userId}")
  Future<void> updateGoalSettings(
    @Path("userId") String userId,
    @Body() GoalSettingsApiModel goalSettings,
  );

  /// Walker Dashboard 조회
  /// walkerId가 없으면 본인의 Dashboard 조회
  /// walkerId가 있으면 특정 Walker의 Dashboard 조회 (본인만 가능)
  @GET("/walker-dashboard")
  Future<WalkerDashboardApiModel> getWalkerDashboard({
    @Query("walkerId") String? walkerId,
  });

  /// 알림 목록 조회 (페이징)
  @GET('/notifications')
  Future<NotificationListApiModel> getNotifications({
    @Query('limit') required int limit,
    @Query('offset') required int offset,
  });

  /// 알림 읽음 처리
  @PATCH('/notifications/{id}/read')
  Future<void> markAsRead(@Path('id') String notificationId);

  /// 모든 알림 읽음 처리
  @PATCH('/notifications/read-all')
  Future<void> markAllAsRead();

  /// 알림 삭제
  @DELETE('/notifications/{id}')
  Future<void> deleteNotification(@Path('id') String notificationId);

  /// 읽지 않은 알림 개수 조회
  @GET('/notifications/unread-count')
  Future<int> getUnreadCount();

  /// 구독 검증 API
  @POST('/subscriptions/verify')
  Future<SubscriptionVerificationResponse> verifySubscription(
    @Body() SubscriptionVerificationRequest request,
  );

  /// Walker Job APIs
  /// 워커 구인구직 글 생성
  @POST('/walker-jobs')
  Future<WalkerJobApiModel> createWalkerJob(
    @Body() CreateWalkerJobRequestApiModel request,
  );

  /// 워커 구인구직 글 조회 (워커 ID로)
  @GET('/walker-jobs/walker/{walkerId}')
  Future<WalkerJobApiModel?> getWalkerJobByWalkerId(
    @Path('walkerId') String walkerId,
  );

  /// 워커 구인구직 글 수정
  @PUT('/walker-jobs/{jobId}')
  Future<WalkerJobApiModel> updateWalkerJob(
    @Path('jobId') String jobId,
    @Body() CreateWalkerJobRequestApiModel request,
  );

  /// 워커 구인구직 글 삭제
  @DELETE('/walker-jobs/{jobId}')
  Future<void> deleteWalkerJob(@Path('jobId') String jobId);

  /// 워커 구인구직 글 목록 조회 (키워드 검색 + 필터)
  @GET('/walker-jobs')
  Future<List<WalkerJobApiModel>> getWalkerJobs({
    @Query('keyword') String? keyword,
    @Query('regionCode') String? regionCode,
    @Query('availableTime') String? availableTime,
    @Query('minHourlyRate') int? minHourlyRate,
    @Query('maxHourlyRate') int? maxHourlyRate,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  /// 워커 구인구직 글 상세 조회
  @GET('/walker-jobs/{jobId}')
  Future<WalkerJobApiModel> getWalkerJobById(@Path('jobId') String jobId);

  /// Owner Job APIs (견주 구인 글)
  @POST('/owner-jobs')
  Future<OwnerJobApiModel> createOwnerJob(
    @Body() CreateOwnerJobRequestApiModel request,
  );

  @GET('/owner-jobs/owner/{ownerId}')
  Future<List<OwnerJobApiModel>> getOwnerJobsByOwnerId(
    @Path('ownerId') String ownerId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  @GET('/owner-jobs')
  Future<List<OwnerJobApiModel>> getOwnerJobs({
    @Query('keyword') String? keyword,
    @Query('regionCode') String? regionCode,
    @Query('availableTime') String? availableTime,
    @Query('minHourlyRate') int? minHourlyRate,
    @Query('maxHourlyRate') int? maxHourlyRate,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  @GET('/owner-jobs/{jobId}')
  Future<OwnerJobApiModel> getOwnerJobById(@Path('jobId') String jobId);

  @PUT('/owner-jobs/{jobId}')
  Future<OwnerJobApiModel> updateOwnerJob(
    @Path('jobId') String jobId,
    @Body() CreateOwnerJobRequestApiModel request,
  );

  @DELETE('/owner-jobs/{jobId}')
  Future<void> deleteOwnerJob(@Path('jobId') String jobId);

  /// Walk Request APIs
  /// 산책 요청 생성
  @POST('/walk-requests')
  Future<WalkRequestApiModel> createWalkRequest(
    @Body() CreateWalkRequestApiModel request,
  );

  /// 산책 요청 취소 (오너용)
  @DELETE('/walk-requests/{requestId}')
  Future<void> cancelWalkRequest(@Path('requestId') String requestId);

  /// 워커가 받은 요청 목록 조회 (워커용)
  @GET('/walk-requests/received')
  Future<List<WalkRequestApiModel>> getWalkRequests();

  /// GET /walk-requests/:requestId - ID로 산책 요청 조회
  @GET('/walk-requests/{requestId}')
  Future<WalkRequestApiModel> getWalkRequestById(
    @Path('requestId') String requestId,
  );

  /// Chat APIs
  /// 사용자의 채팅방 목록 조회
  @GET('/chat/rooms')
  Future<ChatRoomListResponseApiModel> getChatRooms({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  /// 특정 채팅방 정보 조회
  @GET('/chat/rooms/{roomId}')
  Future<ChatRoomApiModel> getChatRoomById(@Path('roomId') String roomId);

  /// 특정 채팅방의 메시지 목록 조회
  @GET('/chat/rooms/{roomId}/messages')
  Future<ChatMessageListResponseApiModel> getChatMessages(
    @Path('roomId') String roomId, {
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  /// 메시지 전송
  @POST('/chat/rooms/{roomId}/messages')
  Future<ChatMessageApiModel> sendMessage(
    @Path('roomId') String roomId,
    @Body() SendMessageRequestApiModel message,
  );

  /// 이미지 메시지 전송 (message: 단일 URL 또는 URL 배열, messageType: 'image')
  @POST('/chat/rooms/{roomId}/messages')
  Future<ChatMessageApiModel> sendMessageWithBody(
    @Path('roomId') String roomId,
    @Body() Map<String, dynamic> body,
  );

  /// 메시지 읽음 처리
  @PATCH('/chat/rooms/{roomId}/read')
  Future<void> markChatAsRead(@Path('roomId') String roomId);

  /// 채팅방 생성
  @POST('/chat/rooms')
  Future<ChatRoomApiModel> createChatRoom(
    @Body() CreateChatRoomRequestApiModel request,
  );

  /// 채팅방 나가기 (채팅방 나가기 버튼 클릭 시 호출)
  @POST('/chat/rooms/{roomId}/leave')
  Future<void> leaveChatRoom(@Path('roomId') String roomId);

  /// 채팅방 나가기 (채팅방 뒤로가기 버튼 클릭 시 호출)
  @POST('/chat/rooms/{roomId}/exit')
  Future<void> exitChatRoom(@Path('roomId') String roomId);

  // ========== Walk Schedule APIs (Old - 레거시) ==========

  /// 워커 스케줄 목록 조회
  @GET('/walk-schedule')
  Future<WalkScheduleListResponseApiModel> getWalkSchedules({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('date') String? date,
    @Query('status') String? status,
  });

  /// 특정 스케줄 조회
  @GET('/walk-schedule/{id}')
  Future<WalkScheduleApiModel> getWalkSchedule(@Path('id') String id);

  /// 스케줄 생성
  @POST('/walk-schedule')
  Future<WalkScheduleApiModel> createWalkSchedule(
    @Body() CreateWalkScheduleRequestApiModel request,
  );

  /// 스케줄 업데이트
  @PUT('/walk-schedule/{id}')
  Future<WalkScheduleApiModel> updateWalkSchedule(
    @Path('id') String id,
    @Body() UpdateWalkScheduleRequestApiModel request,
  );

  /// 스케줄 삭제
  @DELETE('/walk-schedule/{id}')
  Future<void> deleteWalkSchedule(@Path('id') String id);

  /// 스케줄 상태 업데이트
  @PATCH('/walk-schedule/{id}/status')
  Future<WalkScheduleApiModel> updateWalkScheduleStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> status,
  );

  // ========== FCM Token APIs ==========

  /// FCM 토큰 등록
  @POST('/fcm-tokens')
  Future<void> registerFcmToken(@Body() Map<String, dynamic> tokenData);

  /// FCM 토큰 삭제
  @DELETE('/fcm-tokens')
  Future<void> deleteFcmToken(@Body() Map<String, dynamic> tokenData);

  /// 사용자 리뷰 목록 조회
  @GET('/users/{id}/reviews')
  Future<UserReviewsApiResponse> getUserReviews(
    @Path('id') String userId, {
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  /// 사용자 리뷰 통계 조회
  @GET('/users/{id}/review-stats')
  Future<ReviewStatsApiResponse> getUserReviewStats(@Path('id') String userId);

  /// 사용자의 전체 산책 횟수 조회
  @GET('/users/{id}/total-walk-count')
  Future<int> getUserTotalWalkCount(@Path('id') String userId);

  /// Badge Count 조회
  @GET('/me/badge-count')
  Future<BadgeCountResponse> getBadgeCount();

  /// 출석 상태 조회 (오늘 출석/보너스 여부)
  @GET('/attendance/me')
  Future<AttendanceStatusApiModel> getAttendanceStatus();

  /// 출석 체크 (지급)
  @POST('/attendance/claim')
  Future<AttendanceClaimResponseApiModel> claimAttendance();

  /// 출석 광고 보너스 (랜덤 추가 지급)
  @POST('/attendance/claim-bonus')
  Future<AttendanceClaimResponseApiModel> claimAttendanceBonus();

  // 차단한 유저 목록
  @GET('/users/blocked')
  Future<BlockListApiModel> getBlockedUsers();

  // 차단한 유저 추가
  @POST('/users/block/{userId}')
  Future<BlockResponseApiModel> blockUser(@Path('userId') String userId);

  // 차단한 유저 삭제
  @DELETE('/users/block/{userId}')
  Future<UnblockResponseApiModel> unblockUser(@Path('userId') String userId);

  // 사용자 신고
  @POST('/users/{userId}/report')
  Future<UserReportResponseApiModel> reportUser(
    @Path('userId') String userId,
    @Body() CreateUserReportRequestApiModel request,
  );

  // FAQ APIs
  @GET('/faqs')
  Future<List<FaqApiModel>> getFaqs();

  /// 반려동물 자격증 목록 조회 (인증 불필요)
  @GET('/pet-certifications')
  Future<List<PetCertificationApiModel>> getPetCertifications();

  // Notice APIs
  @GET('/notices')
  Future<NoticeListApiModel> getNotices({
    @Query('limit') required int limit,
    @Query('offset') required int offset,
  });

  // Exchange APIs
  @GET('/exchange-items')
  Future<List<ExchangeItemApiModel>> getExchangeItems();

  @POST('/exchange-items/{id}/exchange')
  Future<ExchangeRequestResponseApiModel> exchangeItem(
    @Path('id') String itemId,
    @Body() CreateExchangeRequestApiModel request,
  );

  // 내 교환 요청 목록 조회
  @GET('/exchange-items/exchanges/me')
  Future<ExchangeRequestListResponseApiModel> getMyExchangeRequests({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  // Reward Box APIs
  @GET('/reward-boxes/me')
  Future<RewardBoxCountApiModel> getMyRewardBox();

  @POST('/reward-boxes/open')
  Future<OpenRewardBoxResponseApiModel> openRewardBox();

  // Feed APIs
  @POST('/feed')
  Future<FeedPostApiModel> createFeedPost(
    @Body() CreateFeedPostRequestApiModel body,
  );

  @GET('/feed')
  Future<FeedListResponseApiModel> getFeedList({
    @Query('sort') String? sort,
    @Query('hasWalkRecord') bool? hasWalkRecord,
    @Query('period') String? period,
    @Query('regionCode') String? regionCode,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('onlyMine') bool? onlyMine,
  });

  @GET('/feed/{postId}')
  Future<FeedPostApiModel> getFeedPost(@Path('postId') String postId);

  @PATCH('/feed/{postId}')
  Future<FeedPostApiModel> updateFeedPost(
    @Path('postId') String postId,
    @Body() UpdateFeedPostRequestApiModel body,
  );

  @DELETE('/feed/{postId}')
  Future<void> deleteFeedPost(@Path('postId') String postId);

  @POST('/upload/feed/{postId}')
  @MultiPart()
  Future<UploadResponse> uploadFeedImage(
    @Path('postId') String postId,
    @Part(name: 'image') File image,
  );

  @POST('/feed/{postId}/like')
  Future<void> likeFeedPost(@Path('postId') String postId);

  @DELETE('/feed/{postId}/like')
  Future<void> unlikeFeedPost(@Path('postId') String postId);

  @GET('/feed/{postId}/comments')
  Future<FeedCommentListResponseApiModel> getFeedComments(
    @Path('postId') String postId, {
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  @POST('/feed/{postId}/comments')
  Future<FeedCommentApiModel> createFeedComment(
    @Path('postId') String postId,
    @Body() CreateFeedCommentRequestApiModel body,
  );

  @POST('/feed/{postId}/comments/{commentId}/replies')
  Future<FeedCommentApiModel> createFeedReply(
    @Path('postId') String postId,
    @Path('commentId') String commentId,
    @Body() CreateFeedReplyRequestApiModel body,
  );

  @GET('/feed/{postId}/comments/{commentId}/replies')
  Future<FeedCommentListResponseApiModel> getFeedReplies(
    @Path('postId') String postId,
    @Path('commentId') String commentId, {
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  @PATCH('/feed/{postId}/comments/{commentId}')
  Future<FeedCommentApiModel> updateFeedComment(
    @Path('postId') String postId,
    @Path('commentId') String commentId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/feed/{postId}/comments/{commentId}')
  Future<void> deleteFeedComment(
    @Path('postId') String postId,
    @Path('commentId') String commentId,
  );

  @POST('/feed/{postId}/comments/{commentId}/report')
  Future<void> reportFeedComment(
    @Path('postId') String postId,
    @Path('commentId') String commentId,
    @Body() FeedReportRequestApiModel body,
  );

  @POST('/feed/{postId}/hide')
  Future<void> hideFeedPost(@Path('postId') String postId);

  @DELETE('/feed/{postId}/hide')
  Future<void> unhideFeedPost(@Path('postId') String postId);

  @POST('/feed/{postId}/report')
  Future<void> reportFeedPost(
    @Path('postId') String postId,
    @Body() FeedReportRequestApiModel body,
  );
}
