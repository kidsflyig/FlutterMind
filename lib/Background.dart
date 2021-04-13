import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  // Data data;
  Background();
  // Background(Data d):data = d;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: MyPainter(),
        // painter: MyPainter(data),
      );
  }
}

class MyPainter extends CustomPainter{
  // Data data;
  // MyPainter(Data d):data = d;

  Paint _myPaint;
  @override
  void paint(Canvas canvas, Size size) {
   _myPaint = new Paint();
   _myPaint.color =Colors.blue;

   //canvas.drawPaint(_myPaint);
   canvas.drawCircle(Offset(100,100), 100, _myPaint);
   canvas.drawLine(Offset(300,300),Offset(400,400) , _myPaint);

  //  if (data.key != null) {
  //   RenderBox box = data.key.currentContext.findRenderObject();
  //   Offset offset = box.localToGlobal(Offset.zero);
  //   print(offset.toString());
  //   _myPaint.color= Color.fromARGB(0x66, 0xff, 0, 0);
  //   canvas.drawCircle(offset, 100, _myPaint);
  //   _myPaint.color= Color.fromARGB(0x66, 0xff, 0xff, 0);
  //   canvas.drawLine(offset,Offset(400,400) , _myPaint);
  //  }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return null;
  }
}