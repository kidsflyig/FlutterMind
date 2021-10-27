import 'dart:collection';
import 'dart:math';

import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/TreeNode.dart';
import 'package:FlutterMind/dialogs/EditingDialog.dart';
import 'package:FlutterMind/layout/LayoutController.dart';
import 'package:FlutterMind/layout/LayoutObject.dart';
import 'package:FlutterMind/utils/base.dart';
import 'package:FlutterMind/widgets/NodeWidget.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/material.dart';

import 'LinedEdge.dart';
import '../MapController.dart';
import 'Edge.dart';

class RootNodeWidget extends NodeWidgetBase {
  RootNodeWidget({Key key, TreeNode node}) : super(key: key) {
    layout = LayoutController().newLayout(this);
    SetSize(Settings().rootNodeSize);
  }

  @override
  void SetSize(Size size) {
    layout.width = size.width;
    layout.height = size.height;

    setNeedsRepaint();
    // repaint();
  }

  Offset center() {
    return offset.translate(layout.width / 2, layout.height / 2);
  }

  // @override
  // addChild(TreeNode node, Direction direction) {
  //   dynamic w = node.widget();
  //   Layout l = w.layout;
  //   layout.addChild(l, node.direction);
  //   setNeedsRepaint();
  //   repaint();
  // }

  @override
  void moveToPostion(Offset dst) {
    dst = dst.translate(-layout.width / 2, -layout.height / 2);
    layout.moveToPosition(dst);
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
    HashSet<Edge> from_edges = super.from_edges;
    if (from_edges != null) {
      from_edges.forEach((e) {
        Edge edge = e;
        edge.repaint();
      });
    }

    HashSet<Edge> to_edges = super.to_edges;
    if (to_edges != null) {
      to_edges.forEach((e) {
        Edge edge = e;
        edge.repaint();
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
        left: widget.layout.x,
        top: widget.layout.y,
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
              width: widget.layout.width,
              height: widget.layout.height,
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
              Offset screen_pos = widget.posInScreen(Offset(widget.layout.x, widget.layout.y));
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
