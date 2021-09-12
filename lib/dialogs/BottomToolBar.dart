import 'package:FlutterMind/operations/History.dart';
import 'package:FlutterMind/third_party/SimpleImageButton.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/utils/Localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:FlutterMind/utils/Constants.dart';
import '../MapController.dart';

class BottomToolBar extends StatefulWidget {
  BottomToolBarState _state;

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
  Offset pos;
  Function cb;
  String title;
  BottomButton(this.visible, this.pos, this.cb, this.title);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: Positioned(
          left: pos.dx,
          top: pos.dy,
          child:
          SimpleImageButton(
            normalImage: 'assets/images/icons/item_bg.png',
            pressedImage: 'assets/images/icons/item_bg.png',
            width: ScreenUtil.getDp(C.bottom_toolbar_item_bg_width),
            title : title,
            onPressed: () {
              if (cb != null) {
                cb();
              }
            },
          )
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
      setState(() {});
    }
  }

  void animationUpdate() {
    setState(() {});
  }

  void animationStatusChanged(AnimationStatus status) {
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

  Offset idxToPos(x, y, width, ratio, i, j) {
    return Offset(x + (i - 1) * width * ratio,
    y - (j + 1) * width * ratio);
  }

  @override
  Widget build(BuildContext context) {
    var item_bg_width = ScreenUtil.getDp(C.bottom_toolbar_item_bg_width);
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child:
          SimpleImageButton(
            normalImage: 'assets/images/icons/bottom_toogle_normal.png',
            pressedImage: 'assets/images/icons/bottom_toogle_pressed.png',
            width: 54,
            onPressed: () {
              widget.toggle();
            },
          ),
        ),
        BottomButton(menu_exposed,
          idxToPos(init_x, init_y, item_bg_width, animation?.value, 0, 0),
          wrapper(() {
            Log.e("click1");
            MapController().addNewNodeForSelected();
            widget.toggle();
        }),
        LC.getString(context, C.add_node),
        ),
        BottomButton(menu_exposed,
          idxToPos(init_x, init_y, item_bg_width, animation?.value, 1, 0),
            wrapper(() {
            Log.e("click2");
            MapController().removeSelctedNode();
            widget.toggle();
        }),
        LC.getString(context, C.remove_node),
        ),
        BottomButton(menu_exposed,
          idxToPos(init_x, init_y, item_bg_width, animation?.value, 2, 0),
          wrapper(() {
            Log.e("click3");
            MapController().cut();
            widget.toggle();
        }),
        LC.getString(context, C.cut),
        ),
        BottomButton(menu_exposed,
          idxToPos(init_x, init_y, item_bg_width, animation?.value, 0, 1),
          wrapper(() {
            Log.e("click4");
            MapController().detachSelctedNode();
        }),
        LC.getString(context, C.unfold),
        ),
        BottomButton(menu_exposed,
          idxToPos(init_x, init_y, item_bg_width, animation?.value, 1, 1),
          wrapper(() {
            Log.e("click5");
            MapController().popupStyleEditorForSelected(context);
        }),
        LC.getString(context, C.edit_style),
        ),
        BottomButton(menu_exposed,
          idxToPos(init_x, init_y, item_bg_width, animation?.value, 2, 1),
          wrapper(() {
            Log.e("click6");
            MapController().copy();
            widget.toggle();
        }),
        LC.getString(context, C.style_selector),
        ),
      ],
    );
  }
}
