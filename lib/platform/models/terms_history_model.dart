import 'package:json_annotation/json_annotation.dart';

part 'terms_history_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TermsHistoryModel {
  String terms;
  int postId;
  bool activated;
  String boardType;

  TermsHistoryModel({required this.terms, required this.postId, required this.activated, required this.boardType});

  factory TermsHistoryModel.fromJson(Map<String, dynamic> json) => _$TermsHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$TermsHistoryModelToJson(this);
}
