import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants.dart';
import '../../models/weight_entry.dart';
import '../widgets/weight_entry_list_item.dart';

class WeightEntruRegister extends StatelessWidget {
  List<WeightEntry> getData() {
    final box = GetStorage();
    List<WeightEntry> entries = box.read<List<dynamic>>(kWeightEntriesListKey)
        ?.map((e) {
          if (e is WeightEntry) return e; 
          return WeightEntry.fromJson(e);
        })
        .toList()
      ?? [];
    return entries;
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
