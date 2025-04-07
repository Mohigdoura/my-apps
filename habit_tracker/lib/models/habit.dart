import 'package:isar/isar.dart';

part 'habit.g.dart';

@Collection()
class Habit {
  // habit id
  Id id = Isar.autoIncrement;

  // habit name
  late String name;

  //comleted days
  List<DateTime> completedDays = [
    // DateTime (year, month, day),
    // DateTime (2025, may, 21),
  ];
}
