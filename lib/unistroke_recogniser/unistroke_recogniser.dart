import 'dart:math';

import 'package:one_handed_cursor/unistroke_recogniser/helper_functions.dart';

class Point {
  double x, y;

  Point(this.x, this.y);
}

class Rectangle {
  double x, y, width, height;

  Rectangle(this.x, this.y, this.width, this.height);
}

class Unistroke {
  String name;
  List<Point> points;

  Unistroke(this.name, this.points) {
    points = resample(points, numPoints);
    double radians = indicativeAngle(points);
    points = rotateBy(points, -radians);
    points = scaleTo(points, squareSize);
    points = translateTo(points, origin);
    vector = vectorize(points); // for Protractor
  }
  
  set vector(List<double> vector) {}
}



const int numUnistrokes = 16;
const int numPoints = 64;
const double squareSize = 250.0;
final Point origin = Point(0,0);
final double diagonal = sqrt(squareSize * squareSize + squareSize * squareSize);
final double halfDiagonal = 0.5 * diagonal;
final double angleRange = deg2Rad(45.0);
final double anglePrecision = deg2Rad(2.0);
final double phi = 0.5 * (-1.0 + sqrt(5.0)); // Golden Ratio
