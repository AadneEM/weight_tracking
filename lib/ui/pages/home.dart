import 'package:flutter/material.dart';
import 'package:weight_tracking/ui/pages/statistics.dart';
import 'package:weight_tracking/ui/pages/weight_entry_register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Widget getCurrentTab() {
    switch (_selectedIndex) {
      case 0:
        return WeightEntruRegister();
      case 1: 
        return StatisticsPage();
      default:
        return Center(
          child: Text('Page not found'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight tracker'),
      ),
      body: getCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Register',
            icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: 'Statistics',
            icon: Icon(Icons.show_chart),
          ),
        ],
      ),
    );
  }
}
