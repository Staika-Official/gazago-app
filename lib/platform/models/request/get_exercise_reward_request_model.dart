class GetExerciseRewardRequestModel {
  final num userId;
  final num userExerciseId;
  final num page;
  final num size;

  GetExerciseRewardRequestModel({
    required this.userId,
    required this.userExerciseId,
    required this.page,
    this.size = 10,
  });
}
