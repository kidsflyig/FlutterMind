import 'dart:math';

import 'package:flutter/material.dart';

import 'Node.dart';
import 'nodewidget/NodeWidgetBase.dart';
import 'utils/Utils.dart';

class EdgeWidget extends StatefulWidget {
  final Node from;
  final Node to;
  EdgeWidget({
    Key key,
    this.from,
    this.to
  }) : super(key: key);
  EdgeWidgetState _state;

  void update(BuildContext context) {
    // print("In EdgeWidget update " + this.hashCode.toString()+" , state="+_state.toString());
    if (_state != null) {
      _state.setState(() {});
    } else {
      print("state is null in EdgeWidget");
    }
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
    // return Container(
    //   color: Colors.red,
    //   width: 20,
    //   height:20
    // );
    NodeWidgetBase fnw = widget.from.widget();
    NodeWidgetBase tnw = widget.to.widget();

    var width = (fnw.drag_.moveOffset.dx - tnw.drag_.moveOffset.dx).abs();
    var height = (fnw.drag_.moveOffset.dy - tnw.drag_.moveOffset.dy).abs();

    var l = min(fnw.drag_.moveOffset.dx , tnw.drag_.moveOffset.dx);
    var t = min(fnw.drag_.moveOffset.dy , tnw.drag_.moveOffset.dy);

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