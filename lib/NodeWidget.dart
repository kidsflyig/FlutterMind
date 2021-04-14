import 'dart:collection';
import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';

import 'Edge.dart';
import 'EdgeWidget.dart';
import 'Node.dart';

class NodeWidget extends StatefulWidget {
  Node node;
  NodeWidget(this.node);
  //静止状态下的offset
  Offset idleOffset=Offset(0, 0);
  //本次移动的offset
  Offset moveOffset=Offset(0, 0);
  //最后一次down事件的offset
  Offset lastStartOffset=Offset(0, 0);
  NodeWidgetState state;

  void moveToPostion(Offset dst) {
    state.setState(() {
      moveOffset=dst;
    });
    state.updateEdges(null);
  }

  void onPanStart(detail) {
    print("NodeWidget onPanStart");
    state.setState(() {
      lastStartOffset=detail.globalPosition;
      // painter=TouchMovePainter();
      state.painter.painterColor = Colors.green;
    });
    state.updateEdges(null);
  }

  void onPanUpdate(detail) {
    print("NodeWidget onPanUpdate");
    state.setState(() {
      moveOffset=detail.globalPosition-lastStartOffset+idleOffset;
      // moveOffset=Offset(max(0, moveOffset.dx), max(0, moveOffset.dy));
    });
    state.updateEdges(null);
  }

  void onPanEnd(detail) {
    print("NodeWidget onPanEnd");
    state.setState(() {
      // painter=TouchMovePainter();
      state.painter.painterColor = Colors.red;
      idleOffset=moveOffset;
    });
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

  @override
  void initState() {
    painter = TouchMovePainter();
    super.initState();
  }

  void updateEdges(BuildContext context) {
    HashSet<Edge> edges = widget.node.edges;
    if (edges != null) {
      edges.forEach((e) {
        EdgeWidget edge = e.widget();
        edge.update(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    painter=TouchMovePainter();
    return Positioned(
          //margin: EdgeInsets.only(left: widget.moveOffset.dx, top: widget.moveOffset.dy),
          //color: Colors.purple,
          left: widget.moveOffset.dx,
          top: widget.moveOffset.dy,

          child: Container(
            height: 100,
            width: 100,
            color: Colors.purple,
            child: GestureDetector(
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
              child: new Stack(
                children:[
                  IconButton(
                    icon: new Icon(Icons.star),
                  ),

                  new TextField(
                    style: new TextStyle(color: Colors.red),
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
                  ),
                ]),
              onDoubleTap: () {
                setState(() {
                  editing = true;
                });
              },
            ),
          ),
        );
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
    return oldDelegate.painterColor!=painterColor;
  }
}