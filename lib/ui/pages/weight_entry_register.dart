import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weight_tracking/controllers/state_controller.dart';

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
            itemBuilder: (ctx, i) => WeightEntryListItem(i),
          ),
        );
      },
    );
  }
}
