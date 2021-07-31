import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final TabController controller;
  final TabData tab;

  const CustomTab({
    required this.controller,
    required this.tab,
    Key? key,
  }) : super(key: key);

  void _selectTab() {
    controller.animateTo(
      tab.index,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectTab,
      child: Container(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Icon(
                tab.icon,
                size: 32,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            AnimatedBuilder(
              animation: controller.animation!,
              builder: (context, child) {
                final index = tab.index;
                final offset = controller.animation?.value ?? 0;

                final double opacity;
                if (offset >= index && offset < (index + 1)) {
                  opacity = 1 - (offset % 1);
                } else if ((offset + 1) >= index && (offset + 1) < (index + 1)) {
                  opacity = offset % 1;
                } else {
                  opacity = 0.0;
                }

                return Opacity(
                  opacity: opacity,
                  child: ClipRRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      heightFactor: 1,
                      widthFactor: opacity,
                      child: child,
                    ),
                  ),
                );
              },
              child: Text(
                tab.label,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabData {
  final String label;
  final IconData icon;

  const TabData({required this.label, required this.icon});

  static const tabs = <TabData>[
    TabData(label: 'Register', icon: Icons.list),
    TabData(label: 'Statistics', icon: Icons.show_chart),
    TabData(label: 'Settings', icon: Icons.settings),
  ];

  int get index => tabs.indexOf(this);
}
