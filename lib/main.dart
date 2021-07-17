import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weight_tracking/controllers/state_controller.dart';
import 'package:weight_tracking/ui/themes/dark_theme.dart';
import 'package:weight_tracking/ui/themes/light_theme.dart';

import 'ui/pages/home.dart';

void main() async {
  await GetStorage.init();
  Get.put(StateController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stateController = Get.find<StateController>();
    return Obx(() {
      return GetMaterialApp(
        title: 'Weight tracking',
        theme: stateController.darkMode ? darkTheme : lightTheme,
        home: HomePage(),
      );
    });
  }
}
