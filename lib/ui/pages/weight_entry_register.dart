import 'package:flutter/material.dart';
import 'package:weight_tracking/models/weight_entry.dart';
import 'package:weight_tracking/ui/widgets/weight_entry_list_item.dart';

class WeightEntruRegister extends StatelessWidget {
  List<WeightEntry> getData() {
    return [
      WeightEntry(
        date: DateTime.parse('2021-05-27'),
        weight: 87.2,
        cheatDay: true,
      ),
      WeightEntry(
        date: DateTime.parse('2021-05-28'),
        weight: 87.7,
      ),
      WeightEntry(
        date: DateTime.parse('2021-05-29'),
        weight: 87.6,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final data = getData();

    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (ctx, i) => Divider(),
      itemBuilder: (ctx, i) => WeightEntryListItem(data[i]),
    );
  }
}
