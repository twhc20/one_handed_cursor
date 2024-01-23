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
  ValueNotifier<int> counter = ValueNotifier(0);

  Button({Key? key, this.x = 0, this.y = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final buttonNotifier = Provider.of<ButtonNotfiier>(context);
    return Positioned(
        left: x,
        right: y,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: ValueListenableBuilder(
            valueListenable: counter,
            builder: (context, int counter, child) {
              return ElevatedButton(
                onPressed: () => buttonNotifier
                    .increment(), // Disable the button's own onPressed event
                child:
                    Text('Counter: ${buttonNotifier.getCounter().toString()}'),
              );
            },
          ),
        ));
  }
}
