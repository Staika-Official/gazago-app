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
  final String? referredBy;
  final RefereesData referees;

  const RefereeResponseModel({
    this.referredBy,
    required this.referees,
  });

  factory RefereeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RefereeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefereeResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RefereesData {
  final List<RefereeModel> content;
  final PageableModel pageable;
  final int totalPages;
  final int totalElements;
  final bool last;
  final int size;
  final int number;
  final SortModel sort;
  final bool first;
  final int numberOfElements;
  final bool empty;

  const RefereesData({
    required this.content,
    required this.pageable,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.size,
    required this.number,
    required this.sort,
    required this.first,
    required this.numberOfElements,
    required this.empty,
  });

  factory RefereesData.fromJson(Map<String, dynamic> json) =>
      _$RefereesDataFromJson(json);

  Map<String, dynamic> toJson() => _$RefereesDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PageableModel {
  final SortModel sort;
  final int offset;
  final int pageSize;
  final int pageNumber;
  final bool paged;
  final bool unpaged;

  const PageableModel({
    required this.sort,
    required this.offset,
    required this.pageSize,
    required this.pageNumber,
    required this.paged,
    required this.unpaged,
  });

  factory PageableModel.fromJson(Map<String, dynamic> json) =>
      _$PageableModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageableModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SortModel {
  final bool sorted;
  final bool unsorted;
  final bool empty;

  const SortModel({
    required this.sorted,
    required this.unsorted,
    required this.empty,
  });

  factory SortModel.fromJson(Map<String, dynamic> json) =>
      _$SortModelFromJson(json);

  Map<String, dynamic> toJson() => _$SortModelToJson(this);
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

