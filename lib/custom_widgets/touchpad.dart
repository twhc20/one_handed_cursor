import 'package:flutter/material.dart';

class Touchpad extends StatefulWidget {
  final Function(double, double) onUpdatePosition;
  final Function() onTap;

  const Touchpad(
      {super.key, required this.onUpdatePosition, required this.onTap});

  @override
  _TouchpadState createState() => _TouchpadState();
}

class _TouchpadState extends State<Touchpad> {
  double positionX = 0.0;
  double positionY = 0.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16.0,
      bottom: 16.0,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            positionX += details.delta.dx;
            positionY += details.delta.dy;

            // Notify the parent widget about the updated position
            widget.onUpdatePosition(positionX, positionY);
          });
        },
        onTap: () {
          widget.onTap();
        },
        child: Container(
          width: 250.0,
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
    );
  }
}
