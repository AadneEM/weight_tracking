import 'package:flutter/material.dart';
import 'package:weight_tracking/ui/widgets/add_entry_fab_card.dart';
import 'package:weight_tracking/ui/widgets/custom_tab.dart';
import 'package:weight_tracking/ui/widgets/drawer.dart';

import 'statistics.dart';
import 'weight_entry_register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  initState() {
    super.initState();
    _controller = TabController(vsync: this, length: TabData.tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: CustomDrawer(),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: TabData.tabs.map((tab) {
                  return Flexible(
                    flex: 1,
                    child: CustomTab(controller: _controller, tab: tab),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: [
                  WeightEntruRegister(() {
                    setState(() {});
                  }),
                  StatisticsPage(),
                  Center(
                    child: Text('Settings coming soon'),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: AddEntryFabCard(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
