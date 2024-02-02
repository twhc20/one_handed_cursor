import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';
import 'dart:math';

List<Point> resample(List<Point> points, int n) {
  double I = pathLength(points) / (n - 1); // interval length
  double D = 0.0;
  List<Point> newpoints = List<Point>.empty();
  newpoints.add(points[0]);
  for (int i = 1; i < points.length; i++) {
    Point pt1 = points[i - 1];
    Point pt2 = points[i];
    double d = distance(pt1, pt2);
    if ((D + d) >= I) {
      double qx = pt1.x + ((I - D) / d) * (pt2.x - pt1.x);
      double qy = pt1.y + ((I - D) / d) * (pt2.y - pt1.y);
      Point q = Point(qx, qy);
      newpoints.add(q); // append new point 'q'
      points.insert(i,
          q); // insert 'q' at position i in points s.t. 'q' will be the next i
      D = 0.0;
    } else {
      D += d;
    }
  }
  if (newpoints.length == n - 1) {
    // somtimes we fall a rounding-error short of adding the last point, so add it if so
    newpoints.add(points[points.length - 1]);
  }
  return newpoints;
}

double indicativeAngle(List<Point> points) {
  Point c = centroid(points);
  return atan2(c.y - points[0].y, c.x - points[0].x);
}

List<Point> rotateBy(List<Point> points, double radians) {
  Point c = centroid(points);
  double cosValue = cos(radians);
  double sinValue = sin(radians);
  List<Point> newpoints = List<Point>.empty();
  for (int i = 0; i < points.length; i++) {
    double qx =
        (points[i].x - c.x) * cosValue - (points[i].y - c.y) * sinValue + c.x;
    double qy =
        (points[i].x - c.x) * sinValue + (points[i].y - c.y) * cosValue + c.y;
    newpoints.add(Point(qx, qy));
  }
  return newpoints;
}

List<Point> scaleTo(List<Point> points, double size) {
  // non-uniform scale; assumes 2D gestures (i.e., no lines)
  Rectangle B = boundingBox(points);
  List<Point> newpoints = List<Point>.empty();
  for (int i = 0; i < points.length; i++) {
    double qx = points[i].x * (size / B.width);
    double qy = points[i].y * (size / B.height);
    newpoints.add(Point(qx, qy));
  }
  return newpoints;
}

List<Point> translateTo(List<Point> points, Point pt) {
  Point c = centroid(points);
  List<Point> newpoints = List<Point>.empty();
  for (int i = 0; i < points.length; i++) {
    double qx = points[i].x + pt.x - c.x;
    double qy = points[i].y + pt.y - c.y;
    newpoints.add(Point(qx, qy));
  }
  return newpoints;
}

List<double> vectorize(List<Point> points) {
  double sum = 0.0;
  List<double> vector = [];
  for (int i = 0; i < points.length; i++) {
    vector.add(points[i].x);
    vector.add(points[i].y);
    sum += points[i].x * points[i].x + points[i].y * points[i].y;
  }
  double magnitude = sqrt(sum);
  for (var i = 0; i < vector.length; i++) {
    vector[i] /= magnitude;
  }
  return vector;
}

double optimalCosineDistance(List<double> v1, List<double> v2) {
  double a = 0.0;
  double b = 0.0;
  for (int i = 0; i < v1.length; i += 2) {
    a += v1[i] * v2[i] + v1[i + 1] * v2[i + 1];
    b += v1[i] * v2[i + 1] - v1[i + 1] * v2[i];
  }
  double angle = atan(b / a);
  return acos(a * cos(angle) + b * sin(angle));
}

double distanceAtBestAngle(
    List<Point> points, T, double a, double b, double threshold) {
  double x1 = phi * a + (1.0 - phi) * b;
  double f1 = distanceAtAngle(points, T, x1);
  double x2 = (1.0 - phi) * a + phi * b;
  double f2 = distanceAtAngle(points, T, x2);
  while ((b - a).abs() > threshold) {
    if (f1 < f2) {
      b = x2;
      x2 = x1;
      f2 = f1;
      x1 = phi * a + (1.0 - phi) * b;
      f1 = distanceAtAngle(points, T, x1);
    } else {
      a = x1;
      x1 = x2;
      f1 = f2;
      x2 = (1.0 - phi) * a + phi * b;
      f2 = distanceAtAngle(points, T, x2);
    }
  }
  return min(f1, f2);
}

double distanceAtAngle(List<Point> points, T, double radians) {
  var newpoints = rotateBy(points, radians);
  return pathDistance(newpoints, T.Points);
}

Point centroid(List<Point> points) {
  double x = 0.0, y = 0.0;
  for (int i = 0; i < points.length; i++) {
    x += points[i].x;
    y += points[i].y;
  }
  x /= points.length;
  y /= points.length;
  return Point(x, y);
}

Rectangle boundingBox(List<Point> points) {
  double minX = double.infinity, maxX = double.negativeInfinity;
  double minY = double.infinity, maxY = double.negativeInfinity;
  for (int i = 0; i < points.length; i++) {
    minX = min(minX, points[i].x);
    minY = min(minY, points[i].y);
    maxX = max(maxX, points[i].x);
    maxY = max(maxY, points[i].y);
  }
  return Rectangle(minX, minY, maxX - minX, maxY - minY);
}

double pathDistance(List<Point> pts1, List<Point> pts2) {
  double d = 0.0;
  for (int i = 0; i < pts1.length; i++) {
    // assumes pts1.length == pts2.length
    d += distance(pts1[i], pts2[i]);
  }
  return d / pts1.length;
}

double pathLength(List<Point> points) {
  double d = 0.0;
  for (int i = 1; i < points.length; i++) {
    d += distance(points[i - 1], points[i]);
  }
  return d;
}

double distance(Point p1, Point p2) {
  double dx = p2.x - p1.x;
  double dy = p2.y - p1.y;
  return sqrt(dx * dx + dy * dy);
}

double deg2Rad(double degree) {
  return (degree * pi / 180);
}
