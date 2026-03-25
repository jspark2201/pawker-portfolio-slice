import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_exchange_request.freezed.dart';
part 'create_exchange_request.g.dart';

@freezed
abstract class CreateExchangeRequest with _$CreateExchangeRequest {
  const factory CreateExchangeRequest({
    required String phoneNumber,
  }) = _CreateExchangeRequest;

  factory CreateExchangeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateExchangeRequestFromJson(json);
}

