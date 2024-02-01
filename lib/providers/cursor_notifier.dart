import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/custom_widgets/button.dart';
import 'package:one_handed_cursor/custom_widgets/cursor.dart';

class CursorNotifier extends StateNotifier<CursorState> {
  CursorNotifier(double positionX, double positionY, double radius)
      : super(CursorState(
            positionX: positionX, positionY: positionY, radius: radius));

  void updatePosition(double x, double y) {
    state = CursorState(positionX: x, positionY: y);
  }

  bool isCursorOnButton (Button button) {
    return button.getRect().contains(Offset(state.positionX, state.positionY));}
}



