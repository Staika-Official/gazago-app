import 'package:json_annotation/json_annotation.dart';

part 'terms_status_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TermsStatusModel {
  bool activated;
  String boardType;
  String? createdDate;

  TermsStatusModel({
    required this.activated,
    required this.boardType,
    this.createdDate,
  });

  factory TermsStatusModel.fromJson(Map<String, dynamic> json) => _$TermsStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$TermsStatusModelToJson(this);
}
