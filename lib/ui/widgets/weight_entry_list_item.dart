import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weight_tracking/controllers/state_controller.dart';
import 'package:weight_tracking/models/weight_entry.dart';

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
  final int entryIndex;

  final StateController _controller = Get.find();

  WeightEntryListItem(this.entryIndex);

  Color getWeightDifference(difference) {
    var differenceColor = Colors.lightBlue[400];
    if (difference.isNegative) differenceColor = Colors.green[300];
    if (difference > 0) differenceColor = Colors.red[300];
    return differenceColor!;
  }

  @override
  Widget build(BuildContext context) {
    final data = _controller.entries;
    final currentEntry = data[entryIndex];
    final WeightEntry? previousEntry = entryIndex != data.length - 1 ? data[entryIndex + 1] : data[entryIndex];
    final WeightEntry? lastWeekEntry = data.cast<WeightEntry?>().firstWhere(
          (entry) => entry != null && currentEntry.date.difference(entry.date) >= Duration(days: 7),
          orElse: () => null,
        );

    final dayDifference = ((currentEntry.weight - (previousEntry?.weight ?? 0)) * 10).round() / 10;
    var dayDifferenceColor = getWeightDifference(dayDifference);

    final weekDifference = ((currentEntry.weight - (lastWeekEntry?.weight ?? 0)) * 10).round() / 10;
    var weekDifferenceColor = getWeightDifference(weekDifference);

    return Dismissible(
      key: Key('dismissible-${currentEntry.id}'),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: currentEntry.cheatDay ? Colors.orangeAccent : Colors.transparent,
              width: 8.0,
            ),
          ),
        ),
        child: Padding(
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
                      currentEntry.displayableDate,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Text(weekDays[currentEntry.date.weekday - 1]),
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
                      currentEntry.weight.toString(),
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
        ),
      ),
      direction: DismissDirection.horizontal,
      onDismissed: (DismissDirection direction) => _controller.removeEntry(currentEntry),
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.orangeAccent,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(Icons.warning),
              Text(currentEntry.cheatDay ? 'Remove cheat day' : 'Mark cheat day'),
            ],
          ),
        ),
      ),
      secondaryBackground: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Theme.of(context).errorColor,
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.delete_forever),
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        switch (direction) {
          case DismissDirection.endToStart:
            bool? confirm = await Get.dialog<bool>(AlertDialog(
              title: Text('Really delete?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: Text('Cancle'),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  child: Text('Confirm'),
                ),
              ],
            ));

            return confirm ?? false;
          case DismissDirection.startToEnd:
            _controller.toggleCheatDay(currentEntry);
            return false;
          default:
            return false;
        }
      },
    );
  }
}
