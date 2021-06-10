import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  WeightEntryListItem(this.weightEntry, [this.previousEntry]);

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('yyyy-MM-dd');

    final weightDifference = ((weightEntry.weight - (previousEntry?.weight ?? 0)) * 10).toInt() / 10;
    var differenceColor = Colors.lightBlue[400];
    if (weightDifference.isNegative) differenceColor = Colors.green[300];
    else if (weightDifference > 0) differenceColor = Colors.red[300];

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
                  format.format(weightEntry.date),
                  style: TextStyle(
                    fontWeight: FontWeight.w300
                  ),
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
                previousEntry != null ? Text(
                  weightDifference.toString(),
                  style: TextStyle(
                    fontSize: 21,
                    color: differenceColor,
                  ),
                ) : Text('N/A', style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
