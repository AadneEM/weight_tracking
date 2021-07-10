import 'package:flutter/material.dart';

import '../../models/weight_entry.dart';

List<String> weekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class WeightEntryListItem extends StatelessWidget {
  final WeightEntry weightEntry;
  final WeightEntry? previousEntry;
  final WeightEntry? lastWeekEntry;

  WeightEntryListItem(
    this.weightEntry, {
    this.previousEntry,
    this.lastWeekEntry,
  });

  Color getWeightDifference(difference) {
    var differenceColor = Colors.lightBlue[400];
    if (difference.isNegative) differenceColor = Colors.green[300];
    if (difference > 0) differenceColor = Colors.red[300];
    return differenceColor!;
  }

  @override
  Widget build(BuildContext context) {
    final dayDifference = ((weightEntry.weight - (previousEntry?.weight ?? 0)) * 10).round() / 10;
    var dayDifferenceColor = getWeightDifference(dayDifference);

    final weekDifference = ((weightEntry.weight - (lastWeekEntry?.weight ?? 0)) * 10).round() / 10;
    var weekDifferenceColor = getWeightDifference(weekDifference);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weightEntry.displayableDate,
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(weekDays[weightEntry.date.weekday - 1]),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  weightEntry.weight.toString(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2, bottom: 5),
                  child: Text('kg'),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                previousEntry != null
                    ? Text(
                        'Day: $dayDifference',
                        style: TextStyle(
                          fontSize: 21,
                          color: dayDifferenceColor,
                        ),
                      )
                    : Text('N/A', style: TextStyle(color: Colors.grey[400])),
                lastWeekEntry != null
                    ? Text(
                        'Week: $weekDifference',
                        style: TextStyle(
                          fontSize: 21,
                          color: weekDifferenceColor,
                        ),
                      )
                    : Text('N/A', style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
