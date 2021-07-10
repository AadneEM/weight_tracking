import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracking/models/weight_entry.dart';

class GraphPainter extends CustomPainter {
  final List<WeightEntry> entries;

  GraphPainter({required this.entries});

  final _verticalLabelWidth = 0;
  final _horizontalLabelHeight = 15;

  final _verticalLabels = 8;
  final _horizontalLabels = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final widthPerEntry = (size.width - _verticalLabelWidth) / (entries.length - 1);

    final weightValues = entries.map((e) => e.weight).toList().cast<double>()..sort();

    final lowestWeight = weightValues.first;
    final highestWeight = weightValues.last;

    final yPerWeight = (size.height - _horizontalLabelHeight) / (highestWeight - lowestWeight);

    final horizontalLabelSpacing = entries.length / _horizontalLabels;

    paintVerticalLabels(canvas, size, lowestWeight, highestWeight);

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final nextEntry = i < entries.length - 1 ? entries[i + 1] : null;

      final paint = Paint()
        ..color = entry.cheatDay ? Colors.orange : Color(0xff0088ff)
        ..strokeWidth = 2;

      final startOffset = Offset(
        _verticalLabelWidth + (widthPerEntry * i),
        (size.height - _horizontalLabelHeight) - ((entry.weight - lowestWeight)) * yPerWeight,
      );

      if (nextEntry != null) {
        final endOffset = Offset(
          _verticalLabelWidth + (widthPerEntry * (i + 1)),
          (size.height - _horizontalLabelHeight) - ((nextEntry.weight - lowestWeight)) * yPerWeight,
        );

        canvas.drawLine(
          startOffset,
          endOffset,
          paint,
        );
      }

      if (i % horizontalLabelSpacing.toInt() == 2) {
        paintHorizontalLabel(canvas, size, entry, startOffset);
      }
    }
  }

  void paintVerticalLabels(
    Canvas canvas,
    Size size,
    double lowestWeight,
    double highestWeight,
  ) {
    // TODO: Draw vertical labels with height indicators
  }

  void paintHorizontalLabel(Canvas canvas, Size size, WeightEntry entry, Offset offset) {
    final indicatorTextOffset = 0;
    final labelOffset = Offset(
      offset.dx,
      size.height - indicatorTextOffset,
    );

    final labelIndicatorPaint = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 1.5;

    final indicatorHeight = 8;

    canvas.drawLine(
      Offset(
        labelOffset.dx,
        labelOffset.dy - indicatorHeight,
      ),
      labelOffset,
      labelIndicatorPaint,
    );

    final textSpan = TextSpan(
      text: entry.displayableShortDate,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter
      ..layout(
        minWidth: 0,
        maxWidth: 100,
      )
      ..paint(
        canvas,
        Offset(
          labelOffset.dx - 20,
          labelOffset.dy + indicatorTextOffset,
        ),
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
