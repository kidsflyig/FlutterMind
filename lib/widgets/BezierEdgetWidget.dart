import 'dart:math';

import 'package:flutter/material.dart';

import '../Node.dart';
import 'EdgeWidgetBase.dart';
import 'NodeWidgetBase.dart';
import '../utils/Utils.dart';

class BezierEdgeWidget extends EdgeWidgetBase {
  BezierEdgeWidget({
    Key key,
    Node from,
    Node to
  }) : super(key: key, from:from, to:to);
  BezierEdgeWidgetState _state;

  @override
  void update() {
    // print("In EdgeWidget update " + this.hashCode.toString()+" , state="+_state.toString());
    if (_state != null) {
      _state.setState(() {});
    } else {
      print("state is null in EdgeWidget");
    }
  }

  @override
  State<StatefulWidget> createState() {
    _state = BezierEdgeWidgetState();
    print("In EdgeWidget create State " + this.hashCode.toString()+" , state="+_state.toString());
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
    NodeWidgetBase fnw = widget.from.widget();
    NodeWidgetBase tnw = widget.to.widget();

    var width = (fnw.x - tnw.x).abs();
    var height = (fnw.y - tnw.y).abs();

    var l = min(fnw.x , tnw.x);
    var t = min(fnw.y , tnw.y);

    Offset ll = fnw.center().translate(-l, -t);
    Offset lt = tnw.center().translate(-l, -t);
    print("edge:pos="+l.toString()+"," +t.toString()+", size="+ width.toString()+","+height.toString());
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
  BezierEdgeWidget widget;
  Offset l;
  Offset t;
  var w;
  var h;
  TouchMovePainter(this.widget, this.l, this.t, this.w, this.h);

  @override
  void paint(Canvas canvas, Size size) {
    painter.color = painterColor;
    painter.color = Colors.yellow;
    // var path=Path();
    // path.moveTo(l.dx, l.dy);
    // path.cubicTo(l.dx + 10, l.dy+10, l.dx, l.dy-10, t.dx, t.dy);
    // canvas.drawPath(path, painter);
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