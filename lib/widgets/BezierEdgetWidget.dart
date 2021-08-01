import 'dart:math';

import 'package:FlutterMind/Edge.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:flutter/material.dart';

import '../Node.dart';
import 'EdgeWidgetBase.dart';
import 'NodeWidgetBase.dart';
import '../utils/Utils.dart';

class BezierEdgeWidget extends EdgeWidgetBase {
  double width = 0;
  double height = 0;
  double l = 0;
  double t = 0;
  Offset ll = Offset(0, 0);
  Offset lt = Offset(0, 0);
  BezierEdgeWidgetState _state;

  BezierEdgeWidget({
    Key key,
    Edge edge
  }) : super(key: key, edge:edge) {
  }

  @override
  void update(Edge e) {
    // print("In EdgeWidget update " + this.hashCode.toString()+" , state="+_state.toString());
    if (e != null) {
      this.edge = e;
      Log.e("edge update final " + e.toString());
    } else {
      Log.e("edge update e is null");
    }
    UpdateStyle();
  }

  void UpdateStyle() {
    if (edge == null) {
      Log.e("EdgeWidget update edge is null");
      return;
    }
    Log.e("update edge "+ edge.from.id.toString()+", "+ edge.to.id.toString());
    NodeWidgetBase fnw = edge.from.widget();
    NodeWidgetBase tnw = edge.to.widget();

    width = (fnw.x - tnw.x).abs();
    height = (fnw.y - tnw.y).abs();

    l = min(fnw.x , tnw.x);
    t = min(fnw.y , tnw.y);

    ll = fnw.center().translate(-l, -t);
    lt = tnw.center().translate(-l, -t);

    if (_state != null && _state.mounted) {
      _state.setState(() {});
    }
  }

  @override
  State<StatefulWidget> createState() {
    _state = BezierEdgeWidgetState();
    UpdateStyle();
    return _state;
  }
}

class BezierEdgeWidgetState extends State<BezierEdgeWidget> {


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
          painter: TouchMovePainter(this.widget, widget.ll, widget.lt, widget.width, widget.height),
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
  BezierEdgeWidget widget;
  Offset l;
  Offset t;
  var w;
  var h;
  TouchMovePainter(this.widget, this.l, this.t, this.w, this.h);

  @override
  void paint(Canvas canvas, Size size) {
    painter.color = painterColor;
    painter.color = Colors.yellow; // tobe removed
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