import 'package:FlutterMind/Foreground.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

  import '../MapController.dart';
import '../operations/OpCenterlize.dart';
import '../operations/OpLoadFromFile.dart';
import '../operations/OpWriteToFile.dart';
import 'FileDialog.dart';
import 'ScaleDialog.dart';
import 'OperationDialog.dart';

class BottomToolBar extends StatefulWidget {

  Foreground foreground_;
  BottomToolBar(this.foreground_);
  @override
  State<StatefulWidget> createState() {
    return BottomToolBarState();
  }
}

class BottomToolBarState extends State<BottomToolBar> {
  bool menu_exposed = false;
  GlobalKey  l = GlobalKey ();
  GlobalKey  c = GlobalKey ();
  GlobalKey  r = GlobalKey ();
  DragUtil drag_ = DragUtil();
  Rect lr;
  Rect cr;
  Rect rr;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((callback){
        RenderBox lbox = l.currentContext?.findRenderObject();
        RenderBox cbox = c.currentContext?.findRenderObject();
        RenderBox rbox = r.currentContext?.findRenderObject();
        if (lbox != null) {
          BoxHitTestResult result = BoxHitTestResult();
          lr = Rect.fromLTWH(lbox.localToGlobal(Offset.zero).dx,
          lbox.localToGlobal(Offset.zero).dy,
          lbox.size.width,
          lbox.size.height);
        }
        if (cbox != null) {
          cr = Rect.fromLTWH(cbox.localToGlobal(Offset.zero).dx,
          cbox.localToGlobal(Offset.zero).dy,
          cbox.size.width,
          cbox.size.height);
        }
        if (rbox != null) {
          rr = Rect.fromLTWH(rbox.localToGlobal(Offset.zero).dx,
          rbox.localToGlobal(Offset.zero).dy,
          rbox.size.width,
          rbox.size.height);
        }
      // _key1.currentContext.size; Size(200.0, 100.0)
      // print("left btn size="+box?.size.toString()); // Size(200.0, 100.0)
    });
    return
      Align(
       alignment: Alignment.bottomCenter,
       child:
                     GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onPanStart: (DragStartDetails  detail) {
                drag_.onPanStart(detail);
                print("bottom bar pan start");
                setState(() {
                menu_exposed = true;
                                });
              },
              onPanUpdate:(detail) {
                drag_.onPanUpdate(detail);
              },
              onPanEnd: (detail) {
                drag_.onPanEnd(detail);
                if (lr.contains(drag_.lastEndOffset)) {
                  print("hit left");

                  MapController().addNodeForSelected( );
                } else if (cr.contains(drag_.lastEndOffset)) {
                  print("hit center");
                  MapController().removeSelctedNode();
                } else if (rr.contains(drag_.lastEndOffset)) {
                  print("hit right");
                } else {
                  print("nothign hit pos:"+ drag_.lastEndOffset.toString());

                }

                setState(() {
                menu_exposed = false;
                                });
              },
              onTap: () {
                MapController().centerlize();
              },
              child:
      Container(
         width:200,
         height:100,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.end,
           children: [
              Visibility(
                visible: menu_exposed,
              child: Row(
               children: [
                // Expanded(
                  // child:
                  Container(
                    padding:  EdgeInsets.only(top: 30),
                    key: l,
                  color: Colors.black,
                  width: 50,
                  height: 50
                // )
                ),
                Expanded(
                  child:Container(
                    key: c,
                  color: Colors.black,
                  width: 50,
                  height: 50
                )),
                Expanded(
                  child:Container(
                    key: r,
                  color: Colors.black,
                  width: 50,
                  height: 50
                ))
               ],
             )),

             Container(
               alignment: Alignment.bottomCenter,
              color: Colors.grey,
              width: 50,
              height: 50
             )

           ],
         )
      )
       ),
      );
  }
}