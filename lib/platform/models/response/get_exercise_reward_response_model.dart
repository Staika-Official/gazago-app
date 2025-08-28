import 'package:gaza_go/platform/models/treasure_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_exercise_reward_response_model.g.dart';

@JsonSerializable()
class GetExerciseRewardResponseModel {
  final List<TreasureModel> content;
  final Pageable pageable;
  final bool last;
  final int totalPages;
  final int totalElements;
  final int size;
  final int number;
  final int numberOfElements;
  final bool first;
  final bool empty;

  GetExerciseRewardResponseModel({
    required this.content,
    required this.pageable,
    required this.last,
    required this.totalPages,
    required this.totalElements,
    required this.size,
    required this.number,
    required this.numberOfElements,
    required this.first,
    required this.empty,
  });

  factory GetExerciseRewardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetExerciseRewardResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetExerciseRewardResponseModelToJson(this);
}

@JsonSerializable()
class Pageable {
  final int offset;
  final int pageSize;
  final int pageNumber;
  final bool paged;
  final bool unpaged;
  final Sort sort;

  Pageable({
    required this.offset,
    required this.pageSize,
    required this.pageNumber,
    required this.paged,
    required this.unpaged,
    required this.sort,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) =>
      _$PageableFromJson(json);

  Map<String, dynamic> toJson() => _$PageableToJson(this);
}

@JsonSerializable()
class Sort {
  final bool empty;
  final bool unsorted;
  final bool sorted;

  Sort({
    required this.empty,
    required this.unsorted,
    required this.sorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => _$SortFromJson(json);

  Map<String, dynamic> toJson() => _$SortToJson(this);
}
