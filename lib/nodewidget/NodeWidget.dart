import 'dart:collection';
// import 'dart:html';
import 'dart:math';

import 'package:FlutterMind/nodewidget/NodeWidgetBase.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/material.dart';

import '../Edge.dart';
import '../EdgeWidget.dart';
import '../MapController.dart';
import '../Node.dart';

class NodeWidget extends NodeWidgetBase {

  NodeWidget({
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
      NodeWidgetState s = state;
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
        NodeWidgetState s = state;
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
    state = NodeWidgetState();
    return state;
  }
}

class NodeWidgetState extends State<NodeWidget> {
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
            child: new Stack(children: [
          GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onPanStart: (detail) {
                print("pan start");
                if(widget.node.type == NodeType.rootNode) return false;
                widget.onPanStart(detail);
              },
              onPanUpdate: (detail) {
                print("pan update");
                if(widget.node.type == NodeType.rootNode) return false;
                widget.onPanUpdate(detail);
              },
              onPanEnd: (detail) {
                print("pan end");
                if(widget.node.type == NodeType.rootNode) return false;
                widget.onPanEnd(detail);
              },
              onDoubleTap: () {
                setState(() {
                  editing = true;
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
                height: widget.width,
                width: widget.height,
                color: Colors.purple,
                child: IconButton(
                  icon: new Icon(Icons.star),
                ),
              )),
          Visibility(
              child: Expanded(
                  // margin: EdgeInsets.only(left: 0),
                  // color: Colors.black,
                  // height: 40,
                  // width: double.infinity,
                  child: Row(
                  children: [
                    IconButton(

                      color: Colors.red,
                      icon: new Icon(Icons.cached),
                      onPressed: () {
                        print("click functio icon1");
                        MapController().addNode(widget.node);
                      },
                    ),
                    IconButton(
                      color: Colors.green,
                      icon: new Icon(Icons.access_alarms),
                      onPressed: () {
                        print("click functio icon2");
                        MapController().removeNode(widget.node);
                      },
                    )]
                  )
                ),
              visible: selected_),
          Container(
              width: 50,
              height: 50,
              child: IgnorePointer(
                  ignoring: !editing,
                  child: new TextField(
                    style: new TextStyle(
                      color: Colors.red,
                      fontSize: ScreenUtil.getDp(plain_text_node_font_size_100p) * widget.scale_,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    enabled: editing,

                    onChanged: (rsp) {
                      print(rsp);
                    },
                    onSubmitted: (rsp) {
                      print("editing submited");
                      setState(() {
                        editing = false;
                      });
                    },
                  ))),
        ])));
  }
}
