import 'dart:ui';

Color getItemGradeColor(String itemGrade) {
  switch (itemGrade) {
    case 'POOR':
      return const Color(0xFF596869);
    case 'COMMON':
      return const Color(0xFFCBD2D2);
    case 'UNCOMMON':
      return const Color(0xFF00D9CC);
    case 'RARE':
      return const Color(0xFFB163FF);
    case 'EPIC':
      return const Color(0xFF2EFFCD);
    case 'LEGEND':
      return const Color(0xFFCBFF5C);
  }
  return const Color(0xFFffffff);
}
