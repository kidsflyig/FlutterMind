import 'dart:collection';
// import 'dart:html';
import 'dart:math';

import 'package:FlutterMind/Foreground.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:FlutterMind/widgets/RootNodeWidget.dart';
import 'package:flutter/material.dart';

import '../Edge.dart';
import 'EdgeWidget.dart';
import '../MapController.dart';
import '../Node.dart';
import 'EdgeWidgetBase.dart';

class NodeWidget extends NodeWidgetBase {
  Color bgColor = Colors.purple;
  String label;

  NodeWidget({Key key, Node node}) : super(key: key, node: node) {
    // SetScale(0.5);
    // if (node==null || node.left == null || node.top == null) {
    //   print("set new node =="+node.toString()+" , "+node.left.toString());
    // }
    // moveToPosition(Offset(node.left, node.top));
    label = node.id.toString();
  }

  Widget clone() {
    NodeWidget w = super.clone();
    w.label = label;
    return w;
  }
  static NodeWidget cast(t) {
    if (t is NodeWidget) {
      return t;
    }
    return null;
  }

  void _update() {
    state?.setState(() {});
  }

  @override
  void SetScale(double scale) {
    super.SetScale(scale);
    state?.setState(() {});
  }

  @override
  void moveToPosition(Offset dst) {
    super.moveToPosition(dst);
    _update();
    updateEdges();
  }

  @override
  void SetSize(Size size) {
    width = size.width;
    height = size.height;
    // _update();
    updateEdges();

    MapController().relayout();
  }

  @override
  void setAlpha(alpha) {
    bgColor = bgColor.withAlpha(alpha);
    _update();
  }

  @override
  setColor(color) {
    bgColor = color;
    _update();
  }

  @override
  void onPanStart(detail) {
    Log.i("NodeWidget onPanStart");
    super.onPanStart(detail);
    _update();
    // updateEdges();
  }

  @override
  void onPanUpdate(detail) {
    Log.i("NodeWidget onPanUpdate");
    Log.e("moveTo w  onPanUpdate " + this.hashCode.toString());
    super.onPanUpdate(detail);

    _update();
    updateEdges();
  }

  @override
  void onPanEnd(detail) {
    Log.i("NodeWidget onPanEnd");
    super.onPanEnd(detail);
    _update();
    updateEdges();
  }

  @override
  void setSelected(selected) {
    if (state != null) {
      print("setSelected in nw");
      state.setState(() {
        NodeWidgetState s = state;
        s.selected_ = selected;
      });
    } else {
      print("setSelected state is null");
    }
  }

  void resizeTextBox(String msg) {
    if (msg.length > 10) {
      this.width += 50;
      _update();
    }
  }

  void updateEdges() {
    Log.i("NodeWidget updateEdges");
    HashSet<Edge> from_edges = node.from_edges;

    if (from_edges != null) {
      from_edges.forEach((e) {
        EdgeWidgetBase edge = e.widget();
        edge.update();
      });
    } else {
      Log.e("NodeWidget updateEdges from_edges is null");
    }

    HashSet<Edge> to_edges = node.to_edges;
    if (to_edges != null) {
      to_edges.forEach((e) {
        EdgeWidgetBase edge = e.widget();
        edge.update();
      });
    } else {
      Log.e("NodeWidget updateEdges to_edges is null");
    }
  }

  @override
  State<StatefulWidget> createState() {
    state = NodeWidgetState();
    return state;
  }
}

class NodeWidgetState extends State<NodeWidget> {
  bool editing = false;
  bool selected_ = false;
  Widget node_view;
  // Offset offset_ = Offset(0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((mag) {
       RenderBox box = context.findRenderObject();
       widget.SetSize(box.size);
    });

    return Positioned(
        //margin: EdgeInsets.only(left: widget.moveOffset.dx, top: widget.moveOffset.dy),
        //color: Colors.purple,
        left: widget.x,
        top: widget.y,
        child: Container(
          child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onPanStart: (detail) {
                Log.i("pan start");
                if (widget is RootNodeWidget) return false;
                widget.onPanStart(detail);
              },
              onPanUpdate: (detail) {
                Log.i("pan update");
                if (widget is RootNodeWidget) return false;
                widget.onPanUpdate(detail);
              },
              onPanEnd: (detail) {
                Log.i("pan end");
                if (widget is RootNodeWidget) return false;
                widget.onPanEnd(detail);
              },
              onDoubleTap: () {
                MapController().input(widget.x, widget.y, (msg) {
                  widget.label = msg;
                  print("update test1: " + widget.label);
                  setState(() {
                  });
                });
              },
              onSecondaryTap: () {
                print("secondary tapped");
                return true;
              },
              onTap: () {
                MapController().selectNode(widget);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.bgColor,
                  border: selected_
                      ? Border.all(color: Colors.red, width: 1)
                      : null, //边框
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                // height: widget.height,
                // width: widget.width,
                child: Text(widget.label)
              )),
        ));
  }
}
