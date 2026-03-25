import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawker/data/models/exchange/exchange_api_model.dart';

part 'exchange_item.freezed.dart';
part 'exchange_item.g.dart';

@freezed
abstract class ExchangeItem with _$ExchangeItem {
  const factory ExchangeItem({
    required String id,
    required String productId,
    required String goodsCode,
    required String goodsName,
    required String brandName,
    required String imageUrl,
    required int rewardPoints,
    int? discountPrice,
    int? displayOrder,
    DateTime? displayStartAt,
    DateTime? displayEndAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ExchangeItem;

  factory ExchangeItem.fromJson(Map<String, dynamic> json) =>
      _$ExchangeItemFromJson(json);
}

class ExchangeItemMapper {
  static ExchangeItem toDomain(ExchangeItemApiModel apiModel) {
    return ExchangeItem(
      id: apiModel.id,
      productId: apiModel.productId,
      goodsCode: apiModel.goodsCode,
      goodsName: apiModel.goodsName,
      brandName: apiModel.brandName,
      imageUrl: apiModel.imageUrl,
      rewardPoints: apiModel.rewardPoints,
      discountPrice: apiModel.discountPrice,
      displayOrder: apiModel.displayOrder,
      displayStartAt: _parseDate(apiModel.displayStartAt),
      displayEndAt: _parseDate(apiModel.displayEndAt),
      createdAt: _parseDate(apiModel.createdAt),
      updatedAt: _parseDate(apiModel.updatedAt),
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
