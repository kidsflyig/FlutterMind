import "package:flutter/material.dart";

import 'Background.dart';
import 'Document.dart';
import 'Foreground.dart';

main() {
  runApp(MyApp());
}

class Data {
  GlobalKey key;
}

class MyApp extends StatelessWidget {
  Data data = new Data();
  Foreground foreground = new Foreground();

  @override
  Widget build(BuildContext context) {
    data.key = GlobalKey();
    return MaterialApp(
      home: GestureDetector(
        child:new Stack(
        children: [
          // new Background(data),
          // new Foreground(data)
          new Background(),
          foreground
        ],
      ),

      onPanStart: (detail) {
        print("app pan start");
        foreground.onPanStart(detail);
      },
      onPanUpdate: (detail){
        print("app pan update");
        foreground.onPanUpdate(detail);
      },
      onPanEnd: (detail) {
        print("app pan end");
        foreground.onPanEnd(detail);
      },

      )
    );
  }
}