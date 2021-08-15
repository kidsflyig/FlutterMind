import 'package:FlutterMind/operations/History.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../MapController.dart';

class BottomToolBar extends StatefulWidget {
  BottomToolBarState _state;
  // GlobalKey l = GlobalKey();
  // GlobalKey c = GlobalKey();
  // GlobalKey r = GlobalKey();
  // DragUtil drag_ = DragUtil();
  // Rect lr;
  // Rect cr;
  // Rect rr;
  void hide() {
    if (_state != null) {
      _state.hide();
    }
  }

  void toggle() {
    if (_state != null) {
      _state.toggle();
    }
  }

  BottomToolBar();
  @override
  State<StatefulWidget> createState() {
    _state = BottomToolBarState();
    return _state;
  }
}

class BottomButton extends StatelessWidget {
  bool visible;
  double x;
  double y;
  Function cb;
  BottomButton(this.visible, this.x, this.y, this.cb);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: Positioned(
            left: x,
            top: y,
            child: GestureDetector(
              child:Container(width: 50, height: 50, color: Colors.red),
              onTap: () {
                if (cb != null) {
                  cb();
                }
              },
              ),
              ));
  }
}

class BottomToolBarState extends State<BottomToolBar>
    with SingleTickerProviderStateMixin {
  bool menu_exposed = false;
  Animation<double> animation;
  AnimationController controller;
  double init_x;
  double init_y;

  void hide() {
    Log.e("hide");
    animation.addStatusListener(animationStatusChanged);
    controller.reverse();
  }

  void show() {
    Log.e("show");
    menu_exposed = true;
    controller.forward();
  }

  void toggle() {
    if (mounted) {
      menu_exposed ? hide() : show();
      setState(() {
      });
    }
  }

  void animationUpdate() {
    setState(() {});
  }

  void animationStatusChanged(AnimationStatus status) {
    Log.e("animationStatusChanged " + status.toString());
    if (status == AnimationStatus.dismissed) {
      menu_exposed = false;
      setState(() {});
      animation.removeStatusListener(animationStatusChanged);
    }
  }

  initState() {
    super.initState();
    init_x = Utils.screenSize().width / 2 - 25;
    init_y = Utils.screenSize().height - 50;
    controller = new AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
        ..addListener(animationUpdate);
  }

  Function wrapper(Function cb) {
    return () {
      cb();
      widget.toggle();
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(width: 50, height: 50, color: Colors.red),
            onTap: () {
              widget.toggle();
            },
            onDoubleTap: () {
              MapController().centerlize();
            },
          ),
        ),
        BottomButton(menu_exposed,
            init_x - animation?.value * 50,
            init_y - animation?.value * 100, wrapper(() {
              Log.e("click1");
              MapController().addNodeForSelected();
              widget.toggle();
            })),
        BottomButton(menu_exposed,
            init_x,
            init_y - animation?.value * 100, wrapper(() {
              Log.e("click2");
              MapController().removeSelctedNode();
              widget.toggle();
            })),
        BottomButton(menu_exposed,
            init_x + animation?.value * 50,
            init_y - animation?.value * 100, wrapper(() {
              Log.e("click3");
              MapController().cut();
              widget.toggle();
            })),
        BottomButton(menu_exposed,
            init_x - animation?.value * 50,
            init_y - animation?.value * 200, wrapper(() {
              Log.e("click4");
              MapController().detachSelctedNode();
            })),
        BottomButton(menu_exposed,
            init_x,
            init_y - animation?.value * 200, wrapper(() {
              Log.e("click5");
              MapController().popupStyleEditorForSelected(context);
            })),
        BottomButton(menu_exposed,
            init_x + animation?.value * 50,
            init_y - animation?.value * 200, wrapper(() {
              Log.e("click6");
              MapController().showStyleSelector(context);

            })),
      ],
    );
  }
}
