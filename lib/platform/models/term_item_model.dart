import 'package:json_annotation/json_annotation.dart';

part 'term_item_model.g.dart';

@JsonSerializable()
class TermItemModel {
  String title;
  String termType;
  bool isChecked;
  bool isRequired;

  TermItemModel({
    required this.title,
    required this.termType,
    this.isChecked = false,
    this.isRequired = false,
  });

  factory TermItemModel.fromJson(Map<String, dynamic> json) => _$TermItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$TermItemModelToJson(this);
}
