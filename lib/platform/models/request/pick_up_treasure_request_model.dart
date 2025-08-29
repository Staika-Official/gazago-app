class PickUpTreasureRequestModel {
  final num userId;
  final num userExerciseId;
  final num userLat;
  final num userLng;
  final num treasureId;

  PickUpTreasureRequestModel({
    required this.userId,
    required this.userExerciseId,
    required this.userLat,
    required this.userLng,
    required this.treasureId,
  });
}
