import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weight_tracking/controllers/state_controller.dart';
import 'package:weight_tracking/models/weight_entry.dart';

import '../widgets/weight_entry_list_item.dart';

class WeightEntruRegister extends StatelessWidget {
  final Function? onEndryDeleted;

  WeightEntruRegister([this.onEndryDeleted]);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: Get.find<StateController>(),
      builder: (StateController controller) {
        final data = controller.entries;

        return RefreshIndicator(
          onRefresh: () async {
            controller.update();
          },
          child: ListView.separated(
            itemCount: data.length,
            separatorBuilder: (ctx, i) => Divider(height: 2),
            itemBuilder: (ctx, i) => Dismissible(
              key: Key('dismissible-${data[i].id}'),
              child: WeightEntryListItem(
                data[i],
                previousEntry: data.cast<WeightEntry?>().firstWhere(
                      (entry) => entry?.sameDateAs(data[i].date.add(Duration(days: -1))) ?? false,
                      orElse: () => null,
                    ),
                lastWeekEntry: data.cast<WeightEntry?>().firstWhere(
                      (entry) => entry?.sameDateAs(data[i].date.add(Duration(days: -7))) ?? false,
                      orElse: () => null,
                    ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => controller.removeEntry(data[i]),
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
          ),
        );
      },
    );
  }
}
