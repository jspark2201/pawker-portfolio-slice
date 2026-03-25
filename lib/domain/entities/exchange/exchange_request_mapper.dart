import 'package:pawker/data/models/exchange/create_exchange_request_api_model.dart';
import 'package:pawker/data/models/exchange/exchange_request_list_response_api_model.dart';
import 'package:pawker/data/models/exchange/exchange_request_response_api_model.dart';
import 'package:pawker/domain/entities/exchange/create_exchange_request.dart';
import 'package:pawker/domain/entities/exchange/exchange_item.dart';
import 'package:pawker/domain/entities/exchange/exchange_request.dart';
import 'package:pawker/domain/entities/exchange/exchange_request_list_response.dart';

class ExchangeRequestMapper {
  /// CreateExchangeRequest 도메인 모델을 API 모델로 변환
  static CreateExchangeRequestApiModel toApiModel(
    CreateExchangeRequest request,
  ) {
    return CreateExchangeRequestApiModel(phoneNumber: request.phoneNumber);
  }

  /// ExchangeRequestResponseApiModel을 도메인 모델로 변환
  static ExchangeRequest toDomain(ExchangeRequestResponseApiModel apiModel) {
    return ExchangeRequest(
      id: apiModel.id,
      exchangeItem: ExchangeItemMapper.toDomain(apiModel.exchangeItem),
      status: _parseStatus(apiModel.status),
      pointsSpent: apiModel.pointsSpent,
      phoneNumber: apiModel.phoneNumber,
      voucherCode: apiModel.voucherCode,
      rejectionReason: apiModel.rejectionReason,
      approvedAt:
          apiModel.approvedAt != null
              ? DateTime.parse(apiModel.approvedAt!)
              : null,
      approvedBy: apiModel.approvedBy,
      smsSentAt:
          apiModel.smsSentAt != null
              ? DateTime.parse(apiModel.smsSentAt!)
              : null,
      smsSentStatus: apiModel.smsSentStatus,
      createdAt: DateTime.parse(apiModel.createdAt),
      updatedAt: DateTime.parse(apiModel.updatedAt),
    );
  }

  /// ExchangeRequestStatus 문자열을 enum으로 변환
  static ExchangeRequestStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return ExchangeRequestStatus.pending;
      case 'approved':
        return ExchangeRequestStatus.approved;
      case 'rejected':
        return ExchangeRequestStatus.rejected;
      default:
        return ExchangeRequestStatus.pending;
    }
  }

  /// ExchangeRequest 목록을 도메인 모델로 변환
  static List<ExchangeRequest> toDomainList(
    List<ExchangeRequestResponseApiModel> apiModels,
  ) {
    return apiModels.map((apiModel) => toDomain(apiModel)).toList();
  }

  /// ExchangeRequestListResponseApiModel을 도메인 모델로 변환
  static ExchangeRequestListResponse toDomainResponse(
    ExchangeRequestListResponseApiModel apiResponse,
  ) {
    return ExchangeRequestListResponse(
      items: toDomainList(apiResponse.items),
      total: apiResponse.total,
      limit: apiResponse.limit,
      offset: apiResponse.offset,
      hasMore: apiResponse.hasMore,
    );
  }
}
