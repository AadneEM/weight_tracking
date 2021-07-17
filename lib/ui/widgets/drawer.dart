import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weight_tracking/controllers/state_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Text('Settings on the way'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dark mode:',
                  style: Theme.of(context).textTheme.caption,
                ),
                Obx(() {
                  return Switch(
                    value: Get.find<StateController>().darkMode,
                    onChanged: (value) => Get.find<StateController>().darkMode = value,
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
