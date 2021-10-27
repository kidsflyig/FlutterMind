import 'dart:math';

import 'package:FlutterMind/layout/LayoutObject.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:flutter/material.dart';

import 'Edge.dart';
import 'NodeWidgetBase.dart';
import '../utils/Utils.dart';

class BezierEdge extends Edge {
  double width = 0;
  double height = 0;
  double l = 0;
  double t = 0;
  Offset ll = Offset(0, 0);
  Offset lt = Offset(0, 0);
  BezierEdgeState _state;

  BezierEdge({
    Key key
  }) : super(key: key) {
  }

  @override
  void repaint() {
    // print("In EdgeWidget update " + this.hashCode.toString()+" , state="+_state.toString());
    updateStyle();

    if (_state != null && _state.mounted) {
      _state.setState(() {});
    }
  }

  void updateStyle() {
    LayoutObject fl = from.layout;
    LayoutObject tl = to.layout;

    NodeWidgetBase fnw = from;
    NodeWidgetBase tnw = to;

    width = (fl.x - tl.x).abs();
    height = (fl.y - tl.y).abs();

    l = min(fl.x , tl.x);
    t = min(fl.y , tl.y);

    ll = fnw.center().translate(-l, -t);
    lt = tnw.center().translate(-l, -t);
  }

  @override
  State<StatefulWidget> createState() {
    _state = BezierEdgeState();
    updateStyle();
    return _state;
  }
}

class BezierEdgeState extends State<BezierEdge> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.red,
    //   width: 20,
    //   height:20
    // );

    // print("edge:pos="+l.toString()+"," +t.toString()+", size="+ width.toString()+","+height.toString());
    return Positioned(
      // margin: EdgeInsets.only(left: l, top: t),
        left: widget.l,
        top: widget.t,
        child:CustomPaint(
          painter: TouchMovePainter(this.widget, widget.color, widget.ll, widget.lt, widget.width, widget.height),
          size: Size( widget.width == 0? 50 : widget.width, widget.height)
          // size: Size(1,1)
          // painter: MyPainter(data),
        )
      );
  }
}

class TouchMovePainter extends CustomPainter {
  var painter = Paint();
  var painterColor = Color.fromARGB(0xFF, 0xff, 0, 0);
  BezierEdge widget;
  Offset l;
  Offset t;
  var w;
  var h;
  TouchMovePainter(this.widget, this.painterColor, this.l, this.t, this.w, this.h);

  @override
  void paint(Canvas canvas, Size size) {
    painter.color = painterColor;
    painter.style = PaintingStyle.stroke;
    painter.strokeWidth = 2;
    var path = Path();
    path.moveTo(l.dx, l.dy);
    path.cubicTo((t.dx - l.dx)/2+l.dx, l.dy, (t.dx - l.dx)/2+l.dx, t.dy, t.dx, t.dy);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(TouchMovePainter oldDelegate) {
    return true;
  }
}