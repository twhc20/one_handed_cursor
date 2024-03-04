import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/custom_widgets/touchpad.dart';

class TouchpadNotifer extends StateNotifier<TouchpadState> {
  TouchpadNotifer(double left, double top, double right, double bottom,
      double updateDx, double updateDy)
      : super(TouchpadState(
            bottom: bottom,
            left: left,
            right: right,
            top: top,
            dxRatio: updateDx,
            dyRatio: updateDy));

  void updatePosition(double bottom, double left, double right, double top) {
    state = TouchpadState(
        bottom: bottom, left: left, right: right, top: top);
  }

  // void moveCursor(double x, double y) {
  //   state = TouchpadState(left: x, top: y);
  // }
}
