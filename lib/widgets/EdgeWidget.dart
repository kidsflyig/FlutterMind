import 'dart:math';

import 'package:FlutterMind/utils/Log.dart';
import 'package:flutter/material.dart';

import '../Node.dart';
import 'EdgeWidgetBase.dart';
import 'NodeWidgetBase.dart';
import '../utils/Utils.dart';

class EdgeWidget extends EdgeWidgetBase {
  EdgeWidget({
    Key key,
    Node from,
    Node to
  }) : super(key: key, from:from, to:to);
  EdgeWidgetState _state;

  @override
  void update() {
    Log.i("In EdgeWidget update " + this.hashCode.toString()+" , state="+_state.toString());
    _state?.setState(() {});
  }

  @override
  State<StatefulWidget> createState() {
    _state = EdgeWidgetState();
    print("In EdgeWidget create State " + this.hashCode.toString()+" , state="+_state.toString());
    return _state;
  }
}

class EdgeWidgetState extends State<EdgeWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NodeWidgetBase fnw = widget.from.widget();
    NodeWidgetBase tnw = widget.to.widget();

    var width = (fnw.x - tnw.x).abs();
    var height = (fnw.y - tnw.y).abs();

    var l = min(fnw.x , tnw.x);
    var t = min(fnw.y , tnw.y);

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
  EdgeWidget widget;
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