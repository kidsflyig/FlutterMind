import 'dart:typed_data';

// import 'package:FlutterMind/utils/PanAndScalingGestureRecognizer.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

import 'Background.dart';
import 'Document.dart';
import 'Foreground.dart';
import 'dialogs/BottomToolBar.dart';
import 'dialogs/TopToolBar.dart';
import 'MapController.dart';
// import 'ScreeningDrawerView.dart';

class MindMapView extends StatefulWidget {
  Foreground foreground = new Foreground();
  Background background = new Background();
  MindMapViewState state;

  GlobalKey globalKey = GlobalKey();
  Uint8List bytes = Uint8List.fromList([71, 73, 70, 56, 57, 97,
  1, 0, 1, 0, 128, 0, 0, 0, 0, 0, 255, 255, 255, 33, 249, 4, 1, 0, 0, 0, 0, 44, 0,
  0, 0, 0, 1, 0, 1, 0, 0, 2, 1, 68, 0, 59]);

  MindMapView() {
    // test
    print("MindMapView");
    // Document().loadFromFile("test.txt");
    Document(); // TODO create document
    MapController().setMindMapView(this);
  }

  static Offset Center() {
    return Offset(Utils.screenSize().width * 3 / 2, Utils.screenSize().height * 3 / 2);
  }

  void updatePreview() {
    toImage().then((data) {
      state?.setState(() {
        bytes = data;
      });
    });
  }

  Future<Uint8List> toImage() async  {
   RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    var dpr = ui.window.devicePixelRatio;
    ui.Image image = await boundary.toImage(pixelRatio: dpr);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  @override
  State<StatefulWidget> createState() {
    state = MindMapViewState();
    return state;
  }
}

class MindMapViewState extends State<MindMapView> {
  bool scaling = false;
  BottomToolBar bottomToolBar;

  MindMapViewState() {
    bottomToolBar = BottomToolBar();
  }

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
        // body: PanAndScalingGestureRecognizer(
        body:
        GestureDetector(
          child:
          RepaintBoundary(
            key: widget.globalKey,
            child:Padding(
            padding: EdgeInsets.only(top: 1),
            child:  new Stack(
              children: [
                widget.background,
                widget.foreground,
                TopToolBar(widget.foreground),
                bottomToolBar,
                // Container(
                //   width:200,
                //   height:200,
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.grey, width: 1),//边框
                //     borderRadius: BorderRadius.all(Radius.circular(3.0)),
                //   ),
                  // child: Image(
                  //   fit: BoxFit.fitHeight,
                  //   image: Image.memory(widget.bytes).image
                  // ),
                // )
              ],
            )
          )),
          // onPanStart: (detail) {
          //   print("app pan start");
          //   if(scaling) return;
          //   widget.foreground.onPanStart(detail);
          // },
          // onPanUpdate: (detail, delta){
          //   if(scaling) return;
          //   print("app pan update");
          //   widget.foreground.onPanUpdate(detail + delta);
          // },
          // onPanEnd: () {
          //   if(scaling) return;
          //   print("app pan end");
          //   widget.foreground.onPanEnd(null);
          // },
          // onScalingStart: (detail) {
          //     print("scale start");
          //     scaling = true;
          // },
          // onScalingUpdate: (detail, scale) {
          //     print("scale value: " + scale.toString());
          //     widget.foreground.SetScale(scale * widget.foreground.scale);
          // },
          // onScalingEnd: () {
          //   scaling = false;
          // },

          onPanStart: (detail) {
            print("app pan start");
            bottomToolBar.hide();

            if(scaling) return;
            widget.foreground.onPanStart(detail);
          },
          onPanUpdate: (detail){
            if(scaling) return;
            print("app pan update");
            widget.foreground.onPanUpdate(detail);
          },
          onPanEnd: (detail) {
            if(scaling) return;
            print("app pan end");
            widget.foreground.onPanEnd(null);
          },
        ),
      );
  }

}