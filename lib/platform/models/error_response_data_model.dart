import 'package:json_annotation/json_annotation.dart';

part 'error_response_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ErrorResponseDataModel {
  int? status;
  String? errorMessage;
  String? errorCode;
  String? detailMessage;

  ErrorResponseDataModel({
    this.status,
    this.errorMessage,
    this.errorCode,
    this.detailMessage,
  });

  factory ErrorResponseDataModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseDataModelToJson(this);
}
