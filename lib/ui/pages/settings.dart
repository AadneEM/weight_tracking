import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weight_tracking/controllers/state_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ListTile(
            title: Text('Height'),
            leading: Icon(Icons.accessibility),
            trailing: Text('###'),
            onTap: () => Get.rawSnackbar(message: 'This is not available yet'),
          ),
          ListTile(
            title: Text('Export data'),
            leading: Icon(Icons.file_download),
            onTap: () => Get.rawSnackbar(message: 'This is not available yet'),
          ),
          ListTile(
            title: Text('Import data'),
            leading: Icon(Icons.file_upload),
            onTap: () => Get.rawSnackbar(message: 'This is not available yet'),
          ),
          Obx(() {
            return ListTile(
              title: Text('Dark mode'),
              leading: Icon(Icons.dark_mode),
              trailing: Switch(
                value: Get.find<StateController>().darkMode,
                onChanged: (value) => Get.find<StateController>().darkMode = value,
              ),
              // onTap: () => Get.find<StateController>().darkMode = !Get.find<StateController>().darkMode,
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Text(
              'Danger zone',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
          ),
          ListTile(
            title: Text(
              'Clear data',
              style: TextStyle(color: Colors.red),
            ),
            leading: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onTap: () {
              Get.dialog(AlertDialog(
                title: Text('Clear data'),
                content: Text('Are you sure you want to delete all your data?'),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancle'),
                  ),
                  TextButton(
                    onPressed: Get.find<StateController>().wipeData,
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ));
            },
          ),
        ],
      ),
    );
  }
}
