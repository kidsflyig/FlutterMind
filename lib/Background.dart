import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  // Data data;
  Background();
  // Background(Data d):data = d;

  @override
  State<StatefulWidget> createState() {
    return BackgroundState();
  }
}

class BackgroundState extends State <Background> {
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        width:1600,
        height:1600,
        // painter: MyPainter(data),
      );
  }
}