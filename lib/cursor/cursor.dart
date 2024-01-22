import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CursorNotifier extends ChangeNotifier {
  double positionX = 0;
  double positionY = 0;

  void updatePosition(double x, double y) {
    positionX = x;
    positionY = y;
    notifyListeners();
  }
}

class Cursor extends StatelessWidget {
  final double radius;

  const Cursor({Key? key, this.radius = 10.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cursorNotifier = Provider.of<CursorNotifier>(context);
    return Positioned(
      left: cursorNotifier.positionX,
      top: cursorNotifier.positionY,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
      ),
    );
  }
}
