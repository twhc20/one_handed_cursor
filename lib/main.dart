import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/pages/home_page.dart';


// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => CursorNotifier(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => ButtonNotfiier(),
//         ),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final GlobalKey buttonKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Custom Cursor'),
//           ),
//           body: Stack(children: [
//             Button(
//               key: buttonKey,
//               x: 16.0,
//               y: 16.0,
//             ),
//             const Cursor(),
//             Touchpad(
//               onUpdatePosition: (double x, double y) {
//                 Provider.of<CursorNotifier>(context, listen: false)
//                     .updatePosition(x, y);
//               },
//               onTap: () {
//                 Rect cursorRect =
//                     Provider.of<CursorNotifier>(context, listen: false).rect;
//                 Button button = buttonKey.currentWidget as Button;
//                 Rect buttonRect = button.getRect();
//                 bool isButtonTapped = checkOverlap(cursorRect, buttonRect);
//                 if (isButtonTapped) {
//                   Provider.of<ButtonNotfiier>(context, listen: false)
//                       .increment();
//                 }
//                 print("Button tapped: $isButtonTapped");
//               },
//             ),
//           ])),
//     );
//   }
// }

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Custom Cursor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
