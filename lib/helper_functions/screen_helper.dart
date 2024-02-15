import 'package:flutter/material.dart';
import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';

class ScreenHelper {
  final BuildContext context;
  Size screenSize;
  late Map<String, Rect> quadrants;

  ScreenHelper(this.context) : screenSize = Size.zero {
    screenSize = MediaQuery.of(context).size;
    defineQuadrants();
  }

  void defineQuadrants() {
    double halfWidth = screenSize.width / 2;
    double halfHeight = screenSize.height / 2;
    double widthA = screenSize.width * 3 / 5;

    quadrants = {
      'A': Rect.fromLTRB(0, 0, widthA, halfHeight),
      'B': Rect.fromLTRB(widthA, 0, screenSize.width, halfHeight),
      'C': Rect.fromLTRB(0, halfHeight, halfWidth, screenSize.height),
      'D': Rect.fromLTRB(halfWidth, halfHeight, screenSize.width, screenSize.height),
    };
  }

  String getQuadrant(String gestureName, List<Point> points) {
    if (points.isEmpty) {
      return 'No points provided for $gestureName';
    }

    Point firstPoint = points.first;
    double widthA = screenSize.width * 3 / 5;
    double halfHeight = screenSize.height / 2;

    if (firstPoint.x <= widthA) {
      return firstPoint.y <= halfHeight ? 'A' : 'C';
    } else {
      return firstPoint.y <= halfHeight ? 'B' : 'D';
    }
  }
}
