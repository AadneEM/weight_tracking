import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants.dart';
import '../../models/weight_entry.dart';
import '../widgets/weight_entry_list_item.dart';

class WeightEntruRegister extends StatelessWidget {
  final Function? onEndryDeleted;

  WeightEntruRegister([this.onEndryDeleted]);

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

  void deleteEntry(WeightEntry entry) {
    final box = GetStorage();
    List<WeightEntry> entries = getData();

    entries.remove(entry);
    box.write(kWeightEntriesListKey, entries);

    if (onEndryDeleted != null) onEndryDeleted!();
  }

  @override
  Widget build(BuildContext context) {
    final data = getData();

    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (ctx, i) => Divider(height: 2,),
      itemBuilder: (ctx, i) => Dismissible(
        key: Key('dismissible-${data[i].id}'),
        child: WeightEntryListItem(data[i]),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => deleteEntry(data[i]),
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: Theme.of(context).errorColor,
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete_forever),
          ),
        ),
        confirmDismiss: (direction) async {
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
        },
      ),
    );
  }
}
