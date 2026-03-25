import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/domain/entities/exchange/exchange_item.dart';

part 'exchange_request.freezed.dart';
part 'exchange_request.g.dart';

@freezed
abstract class ExchangeRequest with _$ExchangeRequest {
  const factory ExchangeRequest({
    required String id,
    required ExchangeItem exchangeItem,
    required ExchangeRequestStatus status,
    required int pointsSpent,
    required String phoneNumber,
    String? voucherCode,
    String? rejectionReason,
    DateTime? approvedAt,
    String? approvedBy,
    DateTime? smsSentAt,
    String? smsSentStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ExchangeRequest;

  factory ExchangeRequest.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRequestFromJson(json);
}

enum ExchangeRequestStatus { pending, approved, rejected }
