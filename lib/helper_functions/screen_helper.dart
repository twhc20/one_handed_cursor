import 'dart:math';

import 'package:flutter/material.dart';
import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';

double distanceBetweenTwoPoints(Point a, Point b) {
  return sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2));
}

/// returns the vertices of the rectangle [upperLeft, upperRight, bottomLeft, bottomRight]
List<Point> getVertices(List<Point> points) {
  if (points.isEmpty) {
    return [];
  }

  double maxX = points.map((point) => point.x).reduce(max);
  double maxY = points.map((point) => point.y).reduce(max);
  double minX = points.map((point) => point.x).reduce(min);
  double minY = points.map((point) => point.y).reduce(min);

  return [
    Point(minX, minY),
    Point(maxX, minY),
    Point(minX, maxY),
    Point(maxX, maxY)
  ];
}

Quadrant? getQuadrantFromRectangle(
    List<Point> points, Quadrant a, Quadrant b, Quadrant c, Quadrant d) {
  if (points.isEmpty) {
    return null;
  }

  Point firstPoint = points.first;

  List<Point> vertices = getVertices(points);

  List<double> distances = [
    distanceBetweenTwoPoints(firstPoint, vertices[0]),
    distanceBetweenTwoPoints(firstPoint, vertices[1]),
    distanceBetweenTwoPoints(firstPoint, vertices[2]),
    distanceBetweenTwoPoints(firstPoint, vertices[3])
  ];
  int closestVertexIndex = distances.indexOf(distances.reduce(min));

  if (closestVertexIndex == 0) {
    return a; // upper left quadrant
  } else if (closestVertexIndex == 1) {
    return b; // upper right quadrant
  } else if (closestVertexIndex == 2) {
    return c; // bottom left quadrant
  } else if (closestVertexIndex == 3) {
    return d; // bottom right quadrant
  } else {
    return a; // default to upper left quadrant
  }
}

Quadrant? getQuadrantFromTriangle(
    List<Point> points, Quadrant a, Quadrant b, Quadrant c, Quadrant d) {
  if (points.isEmpty) {
    return null;
  }

  Point firstPoint = points.first;

  List<Point> vertices = getVertices(points);

  List<double> distances = [
    distanceBetweenTwoPoints(firstPoint, vertices[0]),
    distanceBetweenTwoPoints(firstPoint, vertices[1]),
    distanceBetweenTwoPoints(firstPoint, vertices[2]),
    distanceBetweenTwoPoints(firstPoint, vertices[3])
  ];
  int closestVertexIndex = distances.indexOf(distances.reduce(min));

  if (closestVertexIndex == 0) {
    return a; // upper left quadrant
  } else if (closestVertexIndex == 1) {
    return b; // upper right quadrant
  } else if (closestVertexIndex == 2) {
    return c; // bottom left quadrant
  } else if (closestVertexIndex == 3) {
    return d; // bottom right quadrant
  } else {
    return a; // default to upper left quadrant
  }
}

Quadrant? getQuadrantFromCircle(
    List<Point> points, Quadrant a, Quadrant b, Quadrant c, Quadrant d) {
  if (points.isEmpty) {
    return null;
  }

  Point firstPoint = points.first;

  List<Point> vertices = getVertices(points);

  List<double> distances = [
    distanceBetweenTwoPoints(firstPoint, vertices[0]),
    distanceBetweenTwoPoints(firstPoint, vertices[1]),
    distanceBetweenTwoPoints(firstPoint, vertices[2]),
    distanceBetweenTwoPoints(firstPoint, vertices[3])
  ];
  int closestVertexIndex = distances.indexOf(distances.reduce(min));

  if (closestVertexIndex == 0) {
    return a; // upper left quadrant
  } else if (closestVertexIndex == 1) {
    return b; // upper right quadrant
  } else if (closestVertexIndex == 2) {
    return c; // bottom left quadrant
  } else if (closestVertexIndex == 3) {
    return d; // bottom right quadrant
  } else {
    return a; // default to upper left quadrant
  }
}

/// contains the name and rect of the quadrant
class Quadrant {
  final String name;
  Rect rect;

  Quadrant(this.name, this.rect);

  set setRect(Rect newRect) {
    rect = newRect;
  }
}

/// contains methods to get cursor offset and trackpad offset based on the points and shape drawn
class ScreenHelper {
  final BuildContext context;
  Size screenSize;
  Quadrant a = Quadrant('A', Rect.zero);
  Quadrant b = Quadrant('B', Rect.zero);
  Quadrant c = Quadrant('C', Rect.zero);
  Quadrant d = Quadrant('D', Rect.zero);

  ScreenHelper(this.context) : screenSize = Size.zero {
    screenSize = MediaQuery.of(context).size;

    double halfWidth = screenSize.width / 2;
    double halfHeight = screenSize.height / 2;
    double widthA = screenSize.width * 3 / 5;

    a.setRect = Rect.fromLTRB(0, 0, widthA, halfHeight); // Upper left quadrant
    b.setRect = Rect.fromLTRB(
        widthA, 0, screenSize.width, halfHeight); // Upper right quadrant
    c.setRect = Rect.fromLTRB(
        0, halfHeight, halfWidth, screenSize.height); // Bottom left quadrant
    d.setRect = Rect.fromLTRB(halfWidth, halfHeight, screenSize.width,
        screenSize.height); // Bottom right quadrant
  }

  Offset getCursorOffset(String shape, List<Point> points) {
    switch (shape) {
      case 'rectangle':
        return getQuadrantFromRectangle(points, a, b, c, d)!.rect.center;
      case 'triangle':
        return getQuadrantFromTriangle(points, a, b, c, d)!.rect.center;
      case 'circle':
        return getQuadrantFromCircle(points, a, b, c, d)!.rect.center;
      default:
        return Offset.zero;
    }
  }

  Rect getTouchpadRect(String shape, List<Point> points) {
    List<Point> vertices = getVertices(points);

    double left = vertices[0].x;
    double top = vertices[0].y;
    double right = vertices[3].x;
    double bottom = vertices[3].y;

    return Rect.fromLTRB(left, top, right, bottom);
  }

  double getCenterX (String shape, List<Point> points) {
    List<Point> vertices = getVertices(points);
    return (vertices[0].x + vertices[3].x) / 2;
  }

  double getCenterY (String shape, List<Point> points) {
    List<Point> vertices = getVertices(points);
    return (vertices[0].y + vertices[3].y) / 2;
  }

  double getWidth (String shape, List<Point> points) {
    List<Point> vertices = getVertices(points);
    return vertices[3].x - vertices[0].x;
  }

  double getHeight (String shape, List<Point> points) {
    List<Point> vertices = getVertices(points);
    return vertices[3].y - vertices[0].y;
  }

  double getArea (String shape, List<Point> points) {
    List<Point> vertices = getVertices(points);
    return (vertices[3].x - vertices[0].x) * (vertices[3].y - vertices[0].y);
  }
}
