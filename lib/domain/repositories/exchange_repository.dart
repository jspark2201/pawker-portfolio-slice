import 'package:pawker/domain/entities/exchange/create_exchange_request.dart';
import 'package:pawker/domain/entities/exchange/exchange_item.dart';
import 'package:pawker/domain/entities/exchange/exchange_request.dart';
import 'package:pawker/domain/entities/exchange/exchange_request_list_response.dart';

abstract class ExchangeRepository {
  Future<List<ExchangeItem>> getExchangeItems();
  Future<ExchangeRequest> exchangeItem(
    String itemId,
    CreateExchangeRequest request,
  );
  Future<ExchangeRequestListResponse> getMyExchangeRequests({
    int? limit,
    int? offset,
  });
}
