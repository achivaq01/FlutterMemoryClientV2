import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_data.dart';

class WidgetMemoryPainter extends CustomPainter {
  final AppData appData;

  WidgetMemoryPainter(this.appData);

  void drawBoard(Canvas canvas, Size size) {
    const int dimensions = 4;
    double smallerDimension =
        size.width < size.height ? size.width : size.height;
    double cellDimension = (smallerDimension / dimensions) / 1.5;

    double separationOffset = 50.0;

    double offsetX = (size.width -
            (cellDimension * dimensions +
                (dimensions - 1) * separationOffset)) /
        2;
    double offsetY = (size.height -
            (cellDimension * dimensions +
                (dimensions - 1) * separationOffset)) /
        2;

    for (var i = 0; i < dimensions; i++) {
      for (var j = 0; j < dimensions; j++) {
        Color paintColor;

        //paintColor = Colors.black12;
        if (appData.cellList[i][j][1] != '-') {
          paintColor = Color(HexColor.getColorFromHex(appData.cellList[i][j][0]));
        } else {
          paintColor = Colors.black12;
        }
        final paint = Paint()..color = paintColor;

        Rect cellRect = Rect.fromLTWH(
            offsetX + i * (cellDimension + separationOffset),
            offsetY + j * (cellDimension + separationOffset),
            cellDimension,
            cellDimension);
        canvas.drawRect(cellRect, paint);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawBoard(canvas, size);
    appData.repaint = false;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
