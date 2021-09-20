import 'dart:collection';
import 'dart:math';

import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/dialogs/EditingDialog.dart';
import 'package:FlutterMind/layout/Layout.dart';
import 'package:FlutterMind/widgets/NodeWidget.dart';
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
    SetSize(Settings().rootNodeSize);
  }

  @override
  void SetSize(Size size) {
    width = size.width;
    height = size.height;

    setNeedsRepaint();
    // repaint();
  }

  Offset center() {
    return offset.translate(super.width / 2, super.height / 2);
  }

  @override
  void addChild(Node node) {
    dynamic w = node.widget();
    Layout l = w.layout;
    layout.addChild(l, node.direction);
    setNeedsRepaint();
    repaint();
  }

  @override
  void moveToPostion(Offset dst) {
    dst = dst.translate(-width / 2, -height / 2);
    super.moveToPosition(dst);
    setNeedsRepaint();
    repaint();
  }

  void onPanStart(detail) {
    print("NodeWidget onPanStart");
    super.onPanStart(detail);
    setNeedsRepaint();
    repaint();
  }

  void onPanUpdate(detail) {
    print("NodeWidget onPanUpdate");
    super.onPanUpdate(detail);
    setNeedsRepaint();
    repaint();
  }

  void onPanEnd(detail) {
    print("NodeWidget onPanEnd");
    super.onPanEnd(detail);
    setNeedsRepaint();
    repaint();
  }

  @override
  void setSelected(selected) {
    if (state != null) {
      print("setSelected in nw");
      RootNodeWidgetState s = state;
      s.selected_ = selected;
      setNeedsRepaint();
      repaint();
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
              padding: EdgeInsets.all(3),
              child: Center(child:Text(
                  widget.label == null ? "" : widget.label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    shadows: [Shadow(color:Colors.black26, offset:Offset(1,1))],
                    fontSize: 20,
                  )))
            ),
            onDoubleTap: () {
              Offset screen_pos = widget.posInScreen(Offset(widget.x, widget.y));
              EditingDialog.showMyDialog(context, EditConfig(
                  pos: screen_pos,
                  maxLength: 999,
                  maxLines:10,
                  keyboardType : TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onSubmit: (msg) {
                    widget.label = msg;
                    widget.repaint();
                  }
              ));
            },
            ));
  }
}
