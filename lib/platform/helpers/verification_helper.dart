bool checkIsFourteenUnderUser(String birthday) {
  DateTime currentDate = DateTime.now();
  DateTime birthDate = DateTime(int.parse(birthday.substring(0, 4)), int.parse(birthday.substring(4, 6)), int.parse(birthday.substring(6, 8)));
  int age = currentDate.year - birthDate.year;
  bool hasBirthdayOccurred = currentDate.isAfter(DateTime(currentDate.year, birthDate.month, birthDate.day));
  bool isUnder14 = age < 14 || (age == 14 && !hasBirthdayOccurred);
  return isUnder14;
}
