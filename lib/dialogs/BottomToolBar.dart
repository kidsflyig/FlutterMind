import 'package:FlutterMind/Foreground.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/Log.dart';
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
  // GlobalKey l = GlobalKey();
  // GlobalKey c = GlobalKey();
  // GlobalKey r = GlobalKey();
  // DragUtil drag_ = DragUtil();
  // Rect lr;
  // Rect cr;
  // Rect rr;
  void toggle() {
    setState(() {
      menu_exposed = !menu_exposed;
    });
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((callback) {
    //   RenderBox lbox = l.currentContext?.findRenderObject();
    //   RenderBox cbox = c.currentContext?.findRenderObject();
    //   RenderBox rbox = r.currentContext?.findRenderObject();
    //   if (lbox != null) {
    //     BoxHitTestResult result = BoxHitTestResult();
    //     lr = Rect.fromLTWH(
    //         lbox.localToGlobal(Offset.zero).dx,
    //         lbox.localToGlobal(Offset.zero).dy,
    //         lbox.size.width,
    //         lbox.size.height);
    //   }
    //   if (cbox != null) {
    //     cr = Rect.fromLTWH(
    //         cbox.localToGlobal(Offset.zero).dx,
    //         cbox.localToGlobal(Offset.zero).dy,
    //         cbox.size.width,
    //         cbox.size.height);
    //   }
    //   if (rbox != null) {
    //     rr = Rect.fromLTWH(
    //         rbox.localToGlobal(Offset.zero).dx,
    //         rbox.localToGlobal(Offset.zero).dy,
    //         rbox.size.width,
    //         rbox.size.height);
    //   }
    // });
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          // width: 200,
          // height: 100,
          constraints: BoxConstraints(maxHeight: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                  visible: menu_exposed,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 1),//边框
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                  color: Colors.black87
                                ),
                               width: 50, height: 50),
                            onTap: () {
                              MapController().addNodeForSelected();
                              toggle();
                            }),
                        GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 1),//边框
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                  color: Colors.black87
                                ),
                                width: 50, height: 50),
                            onTap: () {
                              MapController().removeSelctedNode();
                              toggle();
                            }),
                        GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 1),//边框
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                  color: Colors.black87
                                ),
                                width: 50, height: 50),
                            onTap: () {
                              Log.e("click 3 button");
                              MapController().cut();
                              toggle();
                            }),
                        GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 1),//边框
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                  color: Colors.black87
                                ),
                                width: 50, height: 50),
                            onTap: () {
                              Log.e("click 4 button");
                              MapController().showPastePopup();
                              toggle();
                            }),
                      ])

                  // Row(
                  //   children: [
                  //   GestureDetector(
                  //       child: Container(
                  //           padding: EdgeInsets.only(top: 30),
                  //           key: l,
                  //           color: Colors.black,
                  //           width: 50,
                  //           height: 50),
                  //       onTap: () {
                  //         MapController().addNodeForSelected();
                  //       },
                  //     ),
                  //     GestureDetector(
                  //       child: Container(
                  //           key: c,
                  //           color: Colors.black,
                  //           width: 50,
                  //           height: 50),
                  //       onTap: () {
                  //         MapController().removeSelctedNode();
                  //       },
                  //     ),
                  //     GestureDetector(
                  //             child: Container(
                  //                 key: r,
                  //                 color: Colors.black,
                  //                 width: 50,
                  //                 height: 50),
                  //             onTap: () {
                  //               Log.e("click 3 button");
                  //               MapController().cut();
                  //             }),
                  //     GestureDetector(
                  //             child: Container(
                  //                 key: r,
                  //                 color: Colors.black,
                  //                 width: 50,
                  //                 height: 50),
                  //             onTap: () {
                  //               Log.e("click 4 button");
                  //               MapController().paste();
                  //             })
                  //   ],
                  // )
                  ),
              GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                child: Container(
                    alignment: Alignment.bottomCenter,
                    color: Colors.blue,
                    width: 50,
                    height: 50),
                onDoubleTap: () {
                  MapController().centerlize();
                  toggle();
                },
                onTap: () {
                  toggle();
                },
              )
            ],
          )),
    );
  }
}
