import 'package:flutter/material.dart';

bool checkOverlap(Rect rect1, Rect rect2) {
  return rect1.overlaps(rect2);
}
