import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weight_tracking/controllers/state_controller.dart';
import 'package:weight_tracking/ui/widgets/graph_painter.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StateController>();

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 400,
          padding: EdgeInsets.all(16),
          child: CustomPaint(
            painter: GraphPainter(entries: controller.entries.reversed.toList()),
          ),
        ),
      ],
    );
  }
}
