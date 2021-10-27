import 'dart:math';

import 'package:FlutterMind/TreeNode.dart';
import 'package:FlutterMind/layout/LayoutObject.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:flutter/material.dart';

import 'Edge.dart';
import 'NodeWidgetBase.dart';
import '../utils/Utils.dart';

class LinedEdge extends Edge {
  LinedEdge({
    Key key
  }) : super(key: key);
  EdgeWidgetState _state;

  @override
  void repaint() {
    Log.i("In EdgeWidget update " + this.hashCode.toString()+" , state="+_state.toString());
    _state?.setState(() {});
  }

  void update(TreeNode f, TreeNode t) {
    Log.e("edge update");
    this.from = f;
    this.to = t;
    f.addEdge(this, true);
    t.addEdge(this, false);
  }

  @override
  State<StatefulWidget> createState() {
    _state = EdgeWidgetState();
    print("In EdgeWidget create State " + this.hashCode.toString()+" , state="+_state.toString());
    return _state;
  }
}

class EdgeWidgetState extends State<LinedEdge> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LayoutObject fl = widget.from.layout;
    LayoutObject tl = widget.to.layout;
    NodeWidgetBase fnw = widget.from;
    NodeWidgetBase tnw = widget.from;

    var width = (fl.x - tl.x).abs();
    var height = (fl.y - tl.y).abs();

    var l = min(fl.x , tl.x);
    var t = min(fl.y , tl.y);

    Offset ll = fnw.center().translate(-l, -t);
    Offset lt = tnw.center().translate(-l, -t);
    Log.i("edge:pos="+l.toString()+"," +t.toString()+", size="+ width.toString()+","+height.toString());
    return Positioned(
      // margin: EdgeInsets.only(left: l, top: t),
        left: l,
        top: t,
        child:CustomPaint(
          painter: TouchMovePainter(this.widget, ll, lt, width, height),
          size: Size( width == 0? 50 : width, height)
          // size: Size(1,1)
          // painter: MyPainter(data),
        )
      );
  }
}

class TouchMovePainter extends CustomPainter {
  var painter = Paint();
  var painterColor = Color.fromARGB(0xFF, 0xff, 0, 0);
  LinedEdge widget;
  Offset l;
  Offset t;
  var w;
  var h;
  TouchMovePainter(this.widget, this.l, this.t, this.w, this.h);

  @override
  void paint(Canvas canvas, Size size) {
    painter.color = painterColor;
    // widget.from.widget()
    // Offset from = Utils.position(widget.from.key);
    // Offset to = Utils.position(widget.to.key);
    // canvas.drawCircle(Offset(size.width / 2, size.height / 2),
    //     min(size.height, size.width) / 2, painter);
    painter.color = Colors.yellow;
    canvas.drawLine(l , t, painter);
    // canvas.drawLine(from, to, painter);

  }

  @override
  bool shouldRepaint(TouchMovePainter oldDelegate) {
    return true;
  }
}