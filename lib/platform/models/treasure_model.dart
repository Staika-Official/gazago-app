class TreasureModel {
  final int id;
  final double latitude;
  final double longitude;
  final TreasureType type;

  TreasureModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  String get treasureIconPath {
    switch (type) {
      case TreasureType.personal:
        return 'assets/images/activity/ico_treasure_normal.svg';
      case TreasureType.event:
        return 'assets/images/activity/ico_treasure_normal.svg';
    }
  }
}

enum TreasureType {
  personal,
  event,
}
