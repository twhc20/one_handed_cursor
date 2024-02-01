import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CursorNotifier extends ChangeNotifier {
//   double positionX = 0;
//   double positionY = 0;
//   double screenWidth = 0;
//   double screenHeight = 0;
//   double radius;
//   double bottomPadding = 0;

//   CursorNotifier({this.radius = 10.0});

//   Offset get position => Offset(positionX, positionY);

//   Rect get rect => Rect.fromLTWH(positionX, positionY, radius * 2, radius * 2);

//   void updateScreenSize(double width, double height, double bottomPadding) {
//     screenWidth = width;
//     screenHeight = height;
//     this.bottomPadding = bottomPadding;
//   }

//   void updatePosition(double x, double y) {
//     positionX = x.clamp(0, screenWidth - radius * 2);
//     positionY = y.clamp(0, screenHeight - radius * 2 - bottomPadding);
//     notifyListeners();
//   }
// }

// class Cursor extends StatelessWidget {
//   final double radius;

//   const Cursor({Key? key, this.radius = 10.0}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final cursorNotifier = Provider.of<CursorNotifier>(context);
//     final screenSize = MediaQuery.of(context).size;
//     final bottomPadding = MediaQuery.of(context).padding.bottom;
//     cursorNotifier.updateScreenSize(
//         screenSize.width, screenSize.height, bottomPadding);

//     return Positioned(
//       left: cursorNotifier.positionX,
//       top: cursorNotifier.positionY,
//       child: Container(
//         width: radius * 2,
//         height: radius * 2,
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.blue,
//         ),
//       ),
//     );
//   }
// }

@immutable
class CursorState {
  final double positionX;
  final double positionY;
  final double radius;

  const CursorState(
      {this.positionX = 0, this.positionY = 0, this.radius = 10.0});
}

class CursorNotifier extends StateNotifier<CursorState> {
  CursorNotifier() : super(const CursorState());

  void updatePosition(double x, double y) {
    state = CursorState(positionX: x, positionY: y);
  }
}

final cursorNotifier =
    StateNotifierProvider<CursorNotifier, CursorState>((ref) => CursorNotifier());

// class CursorWidget extends ConsumerWidget {
//   final double initialPositionX;
//   final double initialPositionY;
//   final double radius;

//   const CursorWidget(
//       {this.initialPositionX = 0,
//       this.initialPositionY = 0,
//       this.radius = 10,
//       super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     CursorState cursorPosition = ref.watch(cursorNotfier);

//     // final screenSize = MediaQuery.of(context).size;
//     // final bottomPadding = MediaQuery.of(context).padding.bottom;

//     return Positioned(
//       left: cursorPosition.positionX,
//       top: cursorPosition.positionY,
//       child: Container(
//         width: cursorPosition.radius * 2,
//         height: cursorPosition.radius * 2,
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.blue,
//         ),
//       ),
//     );
//   }
// }


class CursorWidget extends ConsumerWidget {
  final double initialPositionX;
  final double initialPositionY;
  final double radius;

  const CursorWidget({
    this.initialPositionX = 0,
    this.initialPositionY = 0,
    this.radius = 10,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursorPosition = ref.watch(cursorNotifier);

    return Stack(
      children: [Positioned(
        left: cursorPosition.positionX,
        top: cursorPosition.positionY,
        child: Container(
          width: cursorPosition.radius * 2,
          height: cursorPosition.radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
    ]);
  }
}
