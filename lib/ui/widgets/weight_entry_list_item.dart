import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/weight_entry.dart';

class WeightEntryListItem extends StatelessWidget {
  final WeightEntry weightEntry;

  WeightEntryListItem(this.weightEntry);

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('yyyy-MM-dd');

    return ListTile(
      title: Text(weightEntry.weight.toString()),
      subtitle: Text(format.format(weightEntry.date)),
      trailing: weightEntry.cheatDay ? Icon(Icons.thumb_down) : null,
    );
  }
}
