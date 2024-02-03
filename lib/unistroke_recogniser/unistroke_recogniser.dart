import 'dart:math';
import 'helper_functions.dart';

const int numUnistrokes = 16;
const int numPoints = 64;
const double squareSize = 250.0;
final int infinity = double.maxFinite.toInt();
final Point origin = Point(0, 0);
final double diagonal = sqrt(squareSize * squareSize + squareSize * squareSize);
final double halfDiagonal = 0.5 * diagonal;
final double angleRange = deg2Rad(45.0);
final double anglePrecision = deg2Rad(2.0);
final double phi = 0.5 * (-1.0 + sqrt(5.0)); // Golden Ratio

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
  late List<double> vector;

  Unistroke(this.name, this.points) {
    points = resample(points, numPoints);
    double radians = indicativeAngle(points);
    points = rotateBy(points, -radians);
    points = scaleTo(points, squareSize);
    points = translateTo(points, origin);
    vector = vectorize(points); // for Protractor
  }
}

class Result {
  String name;
  double score;
  int ms;

  Result(this.name, this.score, this.ms);
}

/// DollarRecognizer class
class DollarRecognizer {
  List<Unistroke> unistrokes;

  DollarRecognizer() : unistrokes = <Unistroke>[];

  DollarRecognizer.withGestures(List<Unistroke> unistrokes)
      : unistrokes = <Unistroke>[] {
    addGestures(unistrokes);
  }

  ///Recognize gesture
  Future<Result> recognize(points, bool useProtractor) async {
    int t0 = DateTime.now().millisecondsSinceEpoch;
    Unistroke candidate = Unistroke("", points);

    int u = -1;
    double b = infinity.toDouble();
    for (int i = 0; i < unistrokes.length; i++) // for each unistroke template
    {
      double d;
      if (useProtractor) {
        d = optimalCosineDistance(
            unistrokes[i].vector, candidate.vector); // Protractor
      } else {
        d = distanceAtBestAngle(candidate.points, unistrokes[i], -angleRange,
            angleRange, anglePrecision); // Golden Section Search (original $1)
      }
      if (d < b) {
        b = d; // best (least) distance
        u = i; // unistroke index
      }
    }
    int t1 = DateTime.now().millisecondsSinceEpoch;
    return (u == -1)
        ? Result("No match.", 0.0, t1 - t0)
        : Result(unistrokes[u].name,
            useProtractor ? (1.0 - b) : (1.0 - b / halfDiagonal), t1 - t0);
  }

  ///Add a list of gestures to the recognizer.
  void addGestures(List<Unistroke> unistrokes) {
    this.unistrokes.addAll(unistrokes);
  }

  ///Add a gesture to the recognizer.
  int addGesture(String name, List<Point> points) {
    unistrokes.add(Unistroke(name, points)); // append new unistroke
    int num = 0;
    for (int i = 0; i < unistrokes.length; i++) {
      if (unistrokes[i].name == name) num++;
    }
    return num;
  }

  ///Delete a gesture fro, the recognizer.
  int deleteUserGesture(String name) {
    int index = -1;
    for (int i = 0; i < unistrokes.length; i++) {
      if (unistrokes[i].name == name) {
        index = i;
        break;
      }
    }
    if (index != -1) {
      unistrokes.removeAt(index); // clear any beyond the original set
    }
    return index;
  }
}
