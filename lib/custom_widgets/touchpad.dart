import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/providers/touchpad_notifer.dart';

@immutable
class TouchpadState {
  final double left;
  final double top;
  final double right;
  final double bottom;
  final double dxRatio;
  final double dyRatio;

  const TouchpadState(
      {this.bottom = 0,
      this.left = 0,
      this.right = 0,
      this.top = 0,
      this.dxRatio = 1,
      this.dyRatio = 1});
}

final touchpadNotifierProvider = StateNotifierProvider.family<TouchpadNotifer,
    TouchpadState, TouchpadWidget>(
  (ref, touchpadWidget) => TouchpadNotifer(
      touchpadWidget.initialLeft,
      touchpadWidget.initialTop,
      touchpadWidget.initialRight,
      touchpadWidget.initialBottom,
      touchpadWidget.updateDx,
      touchpadWidget.updateDy),
);

class TouchpadWidget extends ConsumerStatefulWidget {
  final Function(double, double) onTouch;
  final Function() onTap;

  final double initialLeft;
  final double initialTop;
  final double initialRight;
  final double initialBottom;
  final double updateDx;
  final double updateDy;

  const TouchpadWidget(
      {this.initialLeft = 0,
      this.initialRight = 0,
      this.initialTop = 0,
      this.initialBottom = 0,
      this.updateDx = 1,
      this.updateDy = 1,
      required this.onTouch,
      required this.onTap,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TouchpadWidgetState();
}

class _TouchpadWidgetState extends ConsumerState<TouchpadWidget> {
  @override
  Widget build(BuildContext context) {
    final touchpadState =
        ref.watch(touchpadNotifierProvider(widget).select((state) => state));

    double relativeCursorPositionX = 0.0;
    double relativeCursorPositionY = 0.0;

    return Stack(children: [
      Positioned(
        left: touchpadState.left,
        top: touchpadState.top,
        child: GestureDetector(
          onPanUpdate: (details) {
            widget.onTouch(relativeCursorPositionX += details.delta.dx * 1.2,
                relativeCursorPositionY += details.delta.dy * 1.2);
          },
          onTap: () {
            widget.onTap();
          },
          child: Container(
            width: touchpadState.right,
            height: touchpadState.bottom,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
      ),
    ]);
  }
}

// class Touchpad extends StatefulWidget {
//   final Function(double, double) onUpdatePosition;
//   final Function() onTap;

//   const Touchpad(
//       {super.key, required this.onUpdatePosition, required this.onTap});

//   @override
//   State<Touchpad> createState() => _TouchpadState();
// }

// class _TouchpadState extends State<Touchpad> {
//   double positionX = 0.0;
//   double positionY = 0.0;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       Positioned(
//         right: 16.0,
//         bottom: 16.0,
//         child: GestureDetector(
//           onPanUpdate: (details) {
//             setState(() {
//               positionX += details.delta.dx * 1.2;
//               positionY += details.delta.dy * 1.2;

//               // Notify the parent widget about the updated position
//               widget.onUpdatePosition(positionX, positionY);
//             });
//           },
//           onTap: () {
//             widget.onTap();
//           },
//           child: Container(
//             width: 250.0,
//             height: 200.0,
//             decoration: BoxDecoration(
//               color: Colors.grey.withOpacity(0.5),
//               borderRadius: BorderRadius.circular(16.0),
//             ),
//           ),
//         ),
//       ),
//     ]);
//   }
// }
