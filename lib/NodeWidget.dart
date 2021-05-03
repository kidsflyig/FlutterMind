import 'dart:collection';
import 'dart:html';
import 'dart:math';

import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:flutter/material.dart';

import 'Edge.dart';
import 'EdgeWidget.dart';
import 'MapController.dart';
import 'Node.dart';

class NodeWidget extends StatefulWidget {
  Node node;
  DragUtil drag_ = DragUtil();

  NodeWidget({
    Key key,
    this.node
  }) : super(key: key);


  NodeWidgetState state;

  void moveToPostion(Offset dst) {
    drag_.moveToPostion(dst);
    state.setState(() {
    });
    state.updateEdges(null);
  }

  void onPanStart(detail) {
    print("NodeWidget onPanStart");
    drag_.onPanStart(detail);
    state.setState(() {
      state.painter.painterColor = Colors.green;
    });
    state.updateEdges(null);
  }

  void onPanUpdate(detail) {
    print("NodeWidget onPanUpdate");
    drag_.onPanUpdate(detail);
    state.updateEdges(null);
    state.setState(() {
      state.offset_ = drag_.moveOffset;
    });
  }

  void onPanEnd(detail) {
    print("NodeWidget onPanEnd");
    drag_.onPanEnd(detail);
    state.setState(() {
      state.painter.painterColor = Colors.red;
    });
  }

  void setSelected(selected) {
    if (state != null) {
      print("setSelected in nw");
      state.setState(() {
        state.selected_ = selected;
      });
    } else {
      print("setSelected state is null");
    }
  }

  @override
  State<StatefulWidget> createState() {
    state = NodeWidgetState();
    return state;
  }
}

class NodeWidgetState extends State<NodeWidget> {
  TouchMovePainter painter;
  bool editing = false;
  bool selected_ = false;
  Widget node_view;
  Offset offset_ = Offset(0, 0);

  @override
  void initState() {
    painter = TouchMovePainter();
    super.initState();
  }

  void updateEdges(BuildContext context) {
    HashSet<Edge> from_edges = widget.node.from_edges;
    if (from_edges != null) {
      from_edges.forEach((e) {
        EdgeWidget edge = e.widget();
        edge.update(context);
      });
    }

    HashSet<Edge> to_edges = widget.node.to_edges;
    if (to_edges != null) {
      to_edges.forEach((e) {
        EdgeWidget edge = e.widget();
        edge.update(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    painter = TouchMovePainter();

    return Positioned(
        //margin: EdgeInsets.only(left: widget.moveOffset.dx, top: widget.moveOffset.dy),
        //color: Colors.purple,
        left: widget.drag_.moveOffset.dx,
        top: widget.drag_.moveOffset.dy,
        child: Container(
            child: new Stack(children: [
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (detail) {
                print("pan start");
                widget.onPanStart(detail);
              },
              onPanUpdate: (detail) {
                print("pan update");
                widget.onPanUpdate(detail);
              },
              onPanEnd: (detail) {
                print("pan end");
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
                height: 100,
                width: 100,
                color: Colors.purple,
                child: IconButton(
                  icon: new Icon(Icons.star),
                ),
              )),
          Visibility(
              child: Container(
                  margin: EdgeInsets.only(left: 50),
                  color: Colors.red,
                  height: 40,
                  width: 40,
                  child: IconButton(
                    color: Colors.red,
                    icon: new Icon(Icons.access_alarms),
                    onPressed: () {
                      print("click functio icon");
                      MapController().addNode(widget.node);
                    },
                  )),
              visible: selected_),
          Container(
              width: 50,
              height: 50,
              child: IgnorePointer(
                  ignoring: !editing,
                  child: new TextField(
                    style: new TextStyle(color: Colors.red),
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

class TouchMovePainter extends CustomPainter {
  var painter = Paint();
  var painterColor = Colors.red;

  @override
  void paint(Canvas canvas, Size size) {
    painter.color = painterColor;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        min(size.height, size.width) / 2, painter);
  }

  @override
  bool shouldRepaint(TouchMovePainter oldDelegate) {
    return oldDelegate.painterColor != painterColor;
  }
}
