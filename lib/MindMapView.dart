import 'dart:typed_data';
import 'package:FlutterMind/ChildrenDrawerView.dart';
import 'package:FlutterMind/DetailDrawerView.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/StyleManager.dart';
import 'package:FlutterMind/third_party/gesture_x_detector/gesture_x_detector.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

import 'Background.dart';
import 'Document.dart';
import 'Foreground.dart';
import 'dialogs/BottomToolBar.dart';
import 'dialogs/TopToolBar.dart';
import 'MapController.dart';

class MindMapView extends StatefulWidget {
  Foreground foreground = new Foreground();
  Background background = new Background();
  MindMapViewState state;
  bool left_drawer_enabled = false;
  bool right_drawer_enabled = false;

  GlobalKey globalKey = GlobalKey();

  MindMapView() {
    // test
    print("MindMapView");
    // Document().loadFromFile("test.txt");
    Document(); // TODO create document
    MapController().setMindMapView(this);
  }

  static Offset Center() {
    return Offset(
        Utils.screenSize().width * 3 / 2, Utils.screenSize().height * 3 / 2);
  }

  void updatePreview(cb) {
    toImage().then((data) {
      if (cb != null) {
        cb(data);
      }
      // state?.setState(() {
      //   bytes = data;
      // });
    });
  }

  void repaint() {
    Log.e("MindMapView repaint1 " + state.toString());
    if (state != null && state.mounted) {
      Log.e("MindMapView repaint2");
      state.setState(() {});
    }
  }

  Future<Uint8List> toImage() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    var dpr = ui.window.devicePixelRatio;
    ui.Image image = await boundary.toImage(pixelRatio: dpr);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  @override
  State<StatefulWidget> createState() {
    Log.e("MindMapView createState");
    state = MindMapViewState();
    return state;
  }
}

class MindMapViewState extends State<MindMapView> {
  double init_size;
  BottomToolBar bottomToolBar;
  bool touch_enabled = true;
  bool force_touch_disabled = false;
  final double drag_edge_width = 20.0;

  MindMapViewState() {
    bottomToolBar = BottomToolBar();
  }

  @override
  void initState() {
    super.initState();
    if (Utils().isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  bool touchEnabled(Offset pos) {
    Log.e("touchEnabled pos="+pos.dx.toString()+", enabled="+widget.left_drawer_enabled.toString());
    if (widget.left_drawer_enabled && pos.dx <= drag_edge_width) {
      return false;
    }
    if (widget.right_drawer_enabled && pos.dx >= Utils.screenSize().width - drag_edge_width) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // RenderRepaintBoundary boundary = context.findRenderObject();
    //                     Image image = await boundary.toImage();
    var left_drawer = DetailDrawerView();
    var right_drawer = ChildrenDrawerView();

    var w = Scaffold(
        // appBar: new AppBar(
        //   shadowColor: Colors.transparent,
        //   backgroundColor: Colors.transparent,
        //   leading: Container(width: 50),
        //   title: TopToolBar(widget.foreground),
        //   toolbarHeight: 50,
        //   // toolbarOpacity: 0,
        //   bottomOpacity: 0,
        // ),
        drawer: left_drawer,
        endDrawer: right_drawer,
        drawerEdgeDragWidth: drag_edge_width,
        drawerEnableOpenDragGesture : false,
        endDrawerEnableOpenDragGesture: false,
        onDrawerChanged: (flag) {
          Log.e("left drawer opened " + flag.toString());
          force_touch_disabled = flag ?? false;
        },
        onEndDrawerChanged: (flag) {
          Log.e("right drawer opened " + flag.toString());
          force_touch_disabled = flag ?? false;
        },
        backgroundColor: Colors.transparent,

        body: Stack(children: [
          XGestureDetector(
            child: RepaintBoundary(
                key: widget.globalKey,
                child: Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: new Stack(
                      children: [
                        widget.background,
                        widget.foreground,

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
                    ))),
            onMoveStart: (MoveEvent me) {
              widget.foreground.onPanStart(me.position);
            },
            onMoveUpdate: (MoveEvent me) {
              widget.foreground.onPanUpdate(me.position);
            },
            onMoveEnd: (MoveEvent me) {

              print("move end");
              widget.foreground.onPanEnd(null);
            },
            onScaleStart: (Offset off) {
              print("onScaleStart");
              Style s = Settings().defaultStyle();
              init_size = s.fontSize();
            },
            onScaleUpdate: (ScaleEvent se) {
              print("onScaleUpdate " + se.scale.toString());
              double newsize = init_size * se.scale;
              newsize = newsize.clamp(5, 50).toDouble();
              print("onScaleUpdate new scale level " + newsize.toString());
              MapController().setFontSize(newsize, null);
            },
            onScaleEnd: () {
              print("onScaleEnd");
            },
          ),
          TopToolBar(),
          bottomToolBar,
          Container(
            padding: EdgeInsets.only(left: 20, bottom:50),
            alignment: Alignment.bottomLeft,
            child: Builder(builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();

                },
                icon: Icon(Icons.settings)
              );
            })),
          Container(
            padding: EdgeInsets.only(right: 20, bottom:50),
            alignment: Alignment.bottomRight,
            child: Builder(builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();

                },
                icon: Icon(Icons.settings)
              );
            })),
        ]));
        return w;
  }
}
