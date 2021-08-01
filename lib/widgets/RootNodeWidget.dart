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

  }

  @override
  void SetScale(double scale) {
    super.SetScale(scale);
    _update();
  }

  @override
  void SetSize(Size size) {
    width = size.width;
    height = size.height;
    _update();
    updateEdges();
  }

  void _update() {
    if (state == null) {
      return;
    }
    if (state.mounted) {
      state.setState(() {
      });
    }
  }

  Offset center() {
    return offset.translate(super.width / 2, super.height / 2);
  }

  @override
  void moveToPostion(Offset dst) {
    super.moveToPosition(dst);
    _update();
    updateEdges();
  }

  void onPanStart(detail) {
    print("NodeWidget onPanStart");
    super.onPanStart(detail);
    _update();
    updateEdges();
  }

  void onPanUpdate(detail) {
    print("NodeWidget onPanUpdate");
    super.onPanUpdate(detail);
    updateEdges();
    _update();
  }

  void onPanEnd(detail) {
    print("NodeWidget onPanEnd");
    super.onPanEnd(detail);
    _update();
  }

  @override
  void setSelected(selected) {
    if (state != null) {
      print("setSelected in nw");
      RootNodeWidgetState s = state;
      s.selected_ = selected;
      _update();
    } else {
      print("setSelected state is null");
    }
  }

  void updateEdges() {
    HashSet<Edge> from_edges = node.from_edges;
    if (from_edges != null) {
      from_edges.forEach((e) {
        EdgeWidgetBase edge = e.widget();
        edge.update(null);
      });
    }

    HashSet<Edge> to_edges = node.to_edges;
    if (to_edges != null) {
      to_edges.forEach((e) {
        EdgeWidgetBase edge = e.widget();
        edge.update(null);
      });
    }
  }

  @override
  State<StatefulWidget> createState() {
    state = RootNodeWidgetState();
    SetSize(Size(200, 100));
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
