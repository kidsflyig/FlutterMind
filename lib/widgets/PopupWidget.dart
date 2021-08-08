import 'dart:collection';
// import 'dart:html';
import 'dart:math';

import 'package:FlutterMind/Foreground.dart';
import 'package:FlutterMind/layout/BidiLayout.dart';
import 'package:FlutterMind/layout/Layout.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:FlutterMind/widgets/RootNodeWidget.dart';
import 'package:flutter/material.dart';

import '../Edge.dart';
import 'EdgeWidget.dart';
import '../MapController.dart';
import '../Node.dart';
import 'EdgeWidgetBase.dart';

enum PopupMode {
  HIDE,
  Editing,
  Pasting,
}

class PopupWidget extends NodeWidgetBase {
  double left;
  double top;
  Offset origin = Offset(0, 0);
  Offset offset = Offset(0, 0);
  Size size;
  PopupMode mode;
  Function cb;
  bool top_enabled = true;
  bool bottom_enabled = true;
  bool right_enabled = true;
  bool left_enabled = true;

  PopupWidget(PopupMode mode, x, y, w, h, cb) {
    this.left = x;
    this.top = y;
    width = w;
    height = h;
    this.mode = mode;
    this.cb = cb;
    if (mode == PopupMode.Editing) {
      width = Utils.screenSize().width / 2;
    } else if (mode == PopupMode.Pasting) {
      width = w + 20;
      height = h + 20;
      this.left -= 10;
      this.top -= 10;
      NodeWidgetBase widget = MapController().getSelected();
      if (widget is RootNodeWidget) {
        top_enabled = bottom_enabled = false;
      } else {
        BidiLayout l = widget.layout;
        if (l.direction == Side.right) {
          left_enabled = false;
        } else {
          right_enabled = false;
        }
      }
    }
  }

  static PopupWidget cast(Widget w) {
    if (w is PopupWidget) {
      return w;
    }
    return null;
  }

  @override
  State<StatefulWidget> createState() {
    state = PopupWidgetState();
    return state;
  }
}

class PopupWidgetState extends State<PopupWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      width: widget.width,
      height: widget.height,
      child: Stack(children: [
        Visibility(
            visible: widget.mode == PopupMode.Editing,
            child: new TextField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              autofocus: true,
              maxLines: 10,
              style: new TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (rsp) {
                print(rsp);
                if (widget.cb != null) {
                  widget.cb(rsp);
                }
              },
              onSubmitted: (msg) {
                widget.mode = PopupMode.HIDE;
                setState(() {});
              },
            )),
        Visibility(
          visible: widget.mode == PopupMode.Pasting,
          child: Container(
              // color: Colors.cyan,
              child: Stack(children: [
            Visibility(
                visible: widget.top_enabled,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      child: Container(
                        width: 10,
                        height: 10,
                        color: Colors.red,
                      ),
                      onTap: () {
                        MapController().paste(Direction.top);
                      },
                    ))),
            Visibility(
                visible: widget.bottom_enabled,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      child: Container(
                        width: 10,
                        height: 10,
                        color: Colors.red,
                      ),
                      onTap: () {
                        MapController().paste(Direction.bottom);
                      },
                    ))),
            Visibility(
                visible: widget.right_enabled,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Container(
                        width: 10,
                        height: 10,
                        color: Colors.red,
                      ),
                      onTap: () {
                        MapController().paste(Direction.right);
                      },
                    ))),
            Visibility(
                visible: widget.left_enabled,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      child: Container(
                        width: 10,
                        height: 10,
                        color: Colors.red,
                      ),
                      onTap: () {
                        MapController().paste(Direction.left);
                      },
                    ))),
          ])),
        )
      ]),
    );
  }
}
