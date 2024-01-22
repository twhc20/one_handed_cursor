// import 'package:flutter/material.dart';
// import 'cursor.dart';

// class CursorPosition extends StatefulWidget {
//   static double positionX = 10.0;
//   static double positionY = 10.0;

//   CursorPosition({super.key});

//   // Function to update the position from the outside
//   static void updatePosition(double x, double y) {
//     positionX = x;
//     positionY = y;
//     print("x:$positionX y:$positionY");
//   }

//   @override
//   _CursorPositionState createState() =>
//       _CursorPositionState();
// }

// class _CursorPositionState extends State<CursorPosition> {
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: CursorPosition.positionX,
//       top: CursorPosition.positionY,
//       child: Cursor(positionX, positionY),
//     );

//   }
// }