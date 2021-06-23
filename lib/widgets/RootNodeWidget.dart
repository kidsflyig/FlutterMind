import 'dart:collection';
import 'dart:math';

import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/material.dart';

import '../Edge.dart';
import 'EdgeWidget.dart';
import '../MapController.dart';
import '../Node.dart';
import 'EdgeWidgetBase.dart';

class RootNodeWidget extends NodeWidgetBase {
  RootNodeWidget({Key key, Node node}) : super(key: key, node: node) {
    // SetScale(0.5);
    // moveToPosition(Offset(node.left, node.top));
    SetSize(Size(200, 100));
  }

  @override
  void SetScale(double scale) {
    super.SetScale(scale);
    state?.setState(() {});
  }

  @override
  void SetSize(Size size) {
    width = size.width;
    height = size.height;
    state?.setState(() {
    });
    updateEdges(null);
  }

  Offset center() {
    return offset.translate(super.width / 2, super.height / 2);
  }

  @override
  void moveToPostion(Offset dst) {
    super.moveToPosition(dst);
    state?.setState(() {});
    updateEdges(null);
  }

  void onPanStart(detail) {
    print("NodeWidget onPanStart");
    super.onPanStart(detail);
    state.setState(() {});
    updateEdges(null);
  }

  void onPanUpdate(detail) {
    print("NodeWidget onPanUpdate");
    super.onPanUpdate(detail);
    updateEdges(null);
    state.setState(() {});
  }

  void onPanEnd(detail) {
    print("NodeWidget onPanEnd");
    super.onPanEnd(detail);
    state.setState(() {});
  }

  @override
  void setSelected(selected) {
    if (state != null) {
      print("setSelected in nw");
      state.setState(() {
        RootNodeWidgetState s = state;
        s.selected_ = selected;
      });
    } else {
      print("setSelected state is null");
    }
  }

  void updateEdges(BuildContext context) {
    HashSet<Edge> from_edges = node.from_edges;
    if (from_edges != null) {
      from_edges.forEach((e) {
        EdgeWidgetBase edge = e.widget();
        edge.update();
      });
    }

    HashSet<Edge> to_edges = node.to_edges;
    if (to_edges != null) {
      to_edges.forEach((e) {
        EdgeWidgetBase edge = e.widget();
        edge.update();
      });
    }
  }

  @override
  State<StatefulWidget> createState() {
    state = RootNodeWidgetState();
    return state;
  }
}

class RootNodeWidgetState extends State<RootNodeWidget> {
  bool editing = false;
  bool selected_ = false;
  Widget node_view;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        //margin: EdgeInsets.only(left: widget.moveOffset.dx, top: widget.moveOffset.dy),
        //color: Colors.purple,
        left: widget.x,
        top: widget.y,
        child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              MapController().selectNode(widget);
            },
            child: Container(
              decoration: BoxDecoration(
                border: selected_
                    ? Border.all(color: Colors.red, width: 1)
                    : null, //边框
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.indigo,
              ),
              width: widget.width,
              height: widget.height,
            )));
  }
}
