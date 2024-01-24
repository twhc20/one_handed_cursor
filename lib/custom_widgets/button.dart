import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonNotfiier extends ChangeNotifier {
  ValueNotifier<int> counter = ValueNotifier(0);

  void increment() {
    counter.value++;
    notifyListeners();
  }

  int getCounter() {
    return counter.value;
  }
}

class Button extends StatelessWidget {
  final double x;
  final double y;
  final double width;
  final double height;
  ValueNotifier<int> counter = ValueNotifier(0);

  Button(
      {Key? key, this.x = 5, this.y = 10, this.width = 100, this.height = 100})
      : super(key: key);

  Rect getRect() {
    return Rect.fromLTWH(x, y, width, height);
  }

  @override
  Widget build(BuildContext context) {
    final buttonNotifier = Provider.of<ButtonNotfiier>(context);
    return Positioned(
        left: x,
        top: y,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: ValueListenableBuilder(
            valueListenable: counter,
            builder: (context, int counter, child) {
              return SizedBox(
                width: width,
                height: height,
                child: ElevatedButton(
                  onPressed: () => buttonNotifier
                      .increment(), // Disable the button's own onPressed event
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Text(
                      'Counter: ${buttonNotifier.getCounter().toString()}'),
                ),
              );
            },
          ),
        ));
  }
}
