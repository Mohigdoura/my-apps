// given a habit list of comleted days
// is the habit completed today

import 'package:habit_tracker/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> comletedDays) {
  final today = DateTime.now();
  return comletedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

// prepare the heat map dataset
Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};
  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // normalize date to avoid time mismatch
      final normalizedDate = DateTime(date.year, date.month, date.day);
      // if the date already exists in the dataset, increment its count
      if (dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      } else {
        // initialize it with the count of 1
        dataset[normalizedDate] = 1;
      }
    }
  }
  return dataset;
}
