import "package:flutter/material.dart";

import 'Background.dart';
import 'Document.dart';
import 'Foreground.dart';
import 'ScreeningDrawerView.dart';

main() {
  runApp(MyApp());
}

class Data {
  GlobalKey key;
}

class MyApp extends StatelessWidget {
  Data data = new Data();
  Foreground foreground = new Foreground();
  Background background = new Background();

  @override
  Widget build(BuildContext context) {
    data.key = GlobalKey();
    return MaterialApp(
      home: new Scaffold(
        drawer: ScreeningDrawerView(foreground.operations()),
        body:GestureDetector(
          child:new Stack(
            children: [
              // new Background(data),
              // new Foreground(data)
              background,
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

      ),


      )
    );
  }
}