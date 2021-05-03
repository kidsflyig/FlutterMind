import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Background.dart';
import 'Foreground.dart';
import 'MapController.dart';
import 'ScreeningDrawerView.dart';

class MindMapView extends StatefulWidget {
  Foreground foreground = new Foreground();
  Background background = new Background();

  MindMapView() {
    MapController().setMindMapView(this);
  }

  @override
  State<StatefulWidget> createState() {
    return MindMapViewState();
  }
}

class MindMapViewState extends State<MindMapView> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: ScreeningDrawerView(widget.foreground.operations()),
        body:GestureDetector(
          child:new Stack(
            children: [
              // widget.background,
              widget.foreground
            ],
          ),
          onPanStart: (DragStartDetails  detail) {
            print("app pan start");
            widget.foreground.onPanStart(detail);
          },
          onPanUpdate: (detail){
            print("app pan update");
            widget.foreground.onPanUpdate(detail);
          },
          onPanEnd: (detail) {
            print("app pan end");
            widget.foreground.onPanEnd(detail);
          },

      ),
      );
  }

}