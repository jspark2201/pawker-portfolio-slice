import 'package:freezed_annotation/freezed_annotation.dart';

part 'apple_user_data_model.freezed.dart';
part 'apple_user_data_model.g.dart';

@freezed
abstract class AppleUserDataModel with _$AppleUserDataModel {
  const factory AppleUserDataModel({
    required String appleId,
    required String email,
    required String name,
  }) = _AppleUserDataModel;

  factory AppleUserDataModel.fromJson(Map<String, dynamic> json) =>
      _$AppleUserDataModelFromJson(json);
}
