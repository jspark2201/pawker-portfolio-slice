import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/domain/entities/exchange/exchange_request.dart';

part 'exchange_request_list_response.freezed.dart';
part 'exchange_request_list_response.g.dart';

@freezed
abstract class ExchangeRequestListResponse
    with _$ExchangeRequestListResponse {
  const factory ExchangeRequestListResponse({
    required List<ExchangeRequest> items,
    required int total,
    required int limit,
    required int offset,
    required bool hasMore,
  }) = _ExchangeRequestListResponse;

  factory ExchangeRequestListResponse.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRequestListResponseFromJson(json);
}

