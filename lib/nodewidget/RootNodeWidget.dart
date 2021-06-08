import 'dart:collection';
import 'dart:math';

import 'package:FlutterMind/nodewidget/NodeWidgetBase.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/material.dart';

import '../Edge.dart';
import '../EdgeWidget.dart';
import '../MapController.dart';
import '../Node.dart';

class RootNodeWidget extends NodeWidgetBase {

  RootNodeWidget({
    Key key,
    Node node
  }) : super(key: key, node:node) {
    SetScale(0.5);
    moveToPostion(Offset(node.left, node.top));
  }

  @override
  void SetScale(double scale) {
    super.SetScale(scale);
    state?.setState(() {
    });
  }

  Offset center() {
    return drag_.moveOffset.translate(super.width / 2, super.height / 2);
  }

  void moveToPostion(Offset dst) {
    drag_.moveToPostion(dst);
    state?.setState(() {
    });
    updateEdges(null);
  }

  void onPanStart(detail) {
    print("NodeWidget onPanStart");
    drag_.onPanStart(detail);
    state.setState(() {
    });
    updateEdges(null);

  }

  void onPanUpdate(detail) {
    print("NodeWidget onPanUpdate");
    drag_.onPanUpdate(detail);
    updateEdges(null);
    state.setState(() {
      RootNodeWidgetState s = state;
      s.offset_ = drag_.moveOffset;
    });
  }

  void onPanEnd(detail) {
    print("NodeWidget onPanEnd");
    drag_.onPanEnd(detail);
    state.setState(() {
    });
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
        EdgeWidget edge = e.widget();
        edge.update(context);
      });
    }

    HashSet<Edge> to_edges = node.to_edges;
    if (to_edges != null) {
      to_edges.forEach((e) {
        EdgeWidget edge = e.widget();
        edge.update(context);
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
  Offset offset_ = Offset(0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        //margin: EdgeInsets.only(left: widget.moveOffset.dx, top: widget.moveOffset.dy),
        //color: Colors.purple,
        left: widget.drag_.moveOffset.dx,
        top: widget.drag_.moveOffset.dy,
        child: Container(
          width: widget.width,
          height: widget.height,
          color: Colors.indigo,
        ));
  }
}
