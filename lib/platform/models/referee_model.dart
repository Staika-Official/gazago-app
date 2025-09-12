import 'package:json_annotation/json_annotation.dart';

part 'referee_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RefereeModel {
  final String type;
  final String referredAt;
  final String username;
  final int amount;
  final int userId;

  const RefereeModel({
    required this.type,
    required this.referredAt,
    required this.username,
    required this.amount,
    required this.userId,
  });

  factory RefereeModel.fromJson(Map<String, dynamic> json) =>
      _$RefereeModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefereeModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RefereeResponseModel {
  final List<RefereeModel> data;
  final MetaModel meta;

  const RefereeResponseModel({
    required this.data,
    required this.meta,
  });

  factory RefereeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RefereeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefereeResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MetaModel {
  final int page;
  final int size;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;
  final List<dynamic> sort;

  const MetaModel({
    required this.page,
    required this.size,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
    required this.sort,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) =>
      _$MetaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetaModelToJson(this);
}

