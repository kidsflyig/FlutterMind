import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'Background.dart';
import 'Document.dart';
import 'Foreground.dart';
import 'dialogs/TopToolBar.dart';
import 'MapController.dart';
import 'ScreeningDrawerView.dart';

class MindMapView extends StatefulWidget {
  Foreground foreground = new Foreground();
  Background background = new Background();

  MindMapView() {
    // test
    print("MindMapView");
    // Document().loadFromFile("test.txt");

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

    // RenderRepaintBoundary boundary = context.findRenderObject();
    //                     Image image = await boundary.toImage();

    return new Scaffold(
        // appBar: new AppBar(
        //   shadowColor: Colors.transparent,
        //   backgroundColor: Colors.transparent,
        //   leading: Container(width: 50),
        //   title: TopToolBar(widget.foreground),
        //   toolbarHeight: 50,
        //   // toolbarOpacity: 0,
        //   bottomOpacity: 0,
        // ),
        // drawer: ScreeningDrawerView(widget.foreground.operations()),
        backgroundColor: Colors.transparent,
        body:GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(top: 1),
            child:  new Stack(
              children: [
                widget.background,
                widget.foreground,
                TopToolBar(widget.foreground)
              ],
            )
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