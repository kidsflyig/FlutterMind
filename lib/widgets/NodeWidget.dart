import 'dart:collection';
// import 'dart:html';
import 'dart:math';

import 'package:FlutterMind/Foreground.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/dialogs/EditingDialog.dart';
import 'package:FlutterMind/layout/BidiLayout.dart';
import 'package:FlutterMind/layout/Layout.dart';
import 'package:FlutterMind/third_party/dotted_border/dotted_border.dart';
import 'package:FlutterMind/utils/FileUtil.dart';
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

class NodeWidget extends NodeWidgetBase {
  bool children_dettached = false;
  NodeWidget({Key key, Node node}) : super(key: key, node: node) {}

  Widget clone() {
    NodeWidget w = super.clone();
    return w;
  }

  static NodeWidget cast(t) {
    if (t is NodeWidget) {
      return t;
    }
    return null;
  }

  // @override
  // void SetScale(double scale) {
  //   super.SetScale(scale);
  //   setNeedsRepaint();
  // }

  @override
  void moveToPosition(Offset dst) {
    super.moveToPosition(dst);

    setNeedsRepaint();
    repaint();
  }

  @override
  void SetSize(Size size) {
    if (width == size.width && height == size.height) {
      Log.i("no need to update size");
      return;
    }
    width = size.width;
    height = size.height;
    MapController().relayout();
    setNeedsRepaint();
    repaint();
  }

  // @override
  // void setAlpha(alpha) {
  //   bgColor = bgColor.withAlpha(alpha);
  //   setNeedsRepaint();
  //   repaint();
  // }

  // @override
  // setColor(color) {
  //   bgColor = color;
  //   setNeedsRepaint();
  //   repaint();
  // }

  @override
  void onPanStart(detail) {
    Log.i("NodeWidget onPanStart");
    super.onPanStart(detail);
    setNeedsRepaint();
    repaint();
  }

  @override
  void onPanUpdate(detail) {
    super.onPanUpdate(detail);

    setNeedsRepaint();
    repaint();
  }

  @override
  void onPanEnd(detail) {
    Log.i("NodeWidget onPanEnd");
    super.onPanEnd(detail);
    setNeedsRepaint();
    repaint();
  }

  @override
  void setSelected(selected) {
    if (state != null) {
      print("setSelected in nw");
      NodeWidgetState s = state;
      s.selected_ = selected;

      setNeedsRepaint();
      repaint();
    } else {
      print("setSelected state is null");
    }
  }

  void resizeTextBox(String msg) {
    if (msg.length > 10) {
      this.width += 50;
      setNeedsRepaint();
      repaint();
    }
  }

  Side direction() {
    BidiLayout l = layout;
    return l.direction;
  }

  @override
  void attach() {
    super.attach();
    children_dettached = false;
    repaint();
  }

  @override
  void detach() {
    super.detach();
    BidiLayout l = layout;
    children_dettached = true;
    repaint();
  }

  @override
  void addChild(Node node) {
    dynamic w = node.widget();
    Layout l = w.layout;
    layout.addChild(l, node.direction);
    setNeedsRepaint();
    repaint();
  }

  void updateEdges() {
    Log.i("NodeWidget updateEdges");
    HashSet<Edge> from_edges = node.from_edges;

    if (from_edges != null) {
      from_edges.forEach((e) {
        EdgeWidgetBase edge = e.widget();
        edge.update(null);
      });
    } else {
      Log.e("NodeWidget updateEdges from_edges is null");
    }

    HashSet<Edge> to_edges = node.to_edges;
    if (to_edges != null) {
      to_edges.forEach((e) {
        EdgeWidgetBase edge = e.widget();
        edge.update(null);
      });
    } else {
      Log.e("NodeWidget updateEdges to_edges is null");
    }
  }

  @override
  State<StatefulWidget> createState() {
    state = NodeWidgetState();
    return state;
  }
}

class NodeWidgetState extends State<NodeWidget> {
  bool editing = false;
  bool selected_ = false;
  Widget node_view;
  // Offset offset_ = Offset(0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((mag) {
      RenderBox box = context.findRenderObject();
      widget.SetSize(box.size);
      //  MapController().repaint();
    });

    Log.e("node widget repaint");
    return Positioned(
        //margin: EdgeInsets.only(left: widget.moveOffset.dx, top: widget.moveOffset.dy),
        //color: Colors.purple,
        left: widget.x,
        top: widget.y,
        child: Container(
          child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onPanStart: (detail) {
                Log.i("pan start");
                if (widget is RootNodeWidget) return false;
                widget.onPanStart(detail);
              },
              onPanUpdate: (detail) {
                Log.i("pan update");
                if (widget is RootNodeWidget) return false;
                widget.onPanUpdate(detail);
              },
              onPanEnd: (detail) {
                Log.i("pan end");
                if (widget is RootNodeWidget) return false;
                widget.onPanEnd(detail);
                // MapController().hidePopup();
              },
              onDoubleTap: () {
                Offset screen_pos =
                    widget.posInScreen(Offset(widget.x, widget.y));
                Log.e("chch " +
                    screen_pos.dx.toString() +
                    "," +
                    screen_pos.dy.toString());
                EditingDialog.showMyDialog(
                    context,
                    EditConfig(
                        pos: screen_pos,
                        maxLength: 999,
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        onSubmit: (msg) {
                          widget.label = msg;
                          widget.repaint();
                        }));
                // MapController().input(widget.node, (msg) {
                //   widget.label = msg;
                //   widget.repaint();
                // });
                // MapController().hideInputPanel();
              },
              onSecondaryTap: () {
                return true;
              },
              onTap: () {
                MapController().selectNode(widget);
                MapController().hideInputPanel();
              },
              child: Row(children: [
                Visibility(
                    visible: widget.children_dettached &&
                        widget.direction() == Side.left,
                    child:
                        Icon(Icons.add_circle_outline, size: 10)),
                DottedBorder(
                    color: selected_ ? Colors.red : widget.borderColor(),
                    bgcolor: widget.bgColor(),
                    dashPattern: selected_ ? [8, 0] : [8, 4],
                    strokeWidth: selected_ ? 4 : 2,
                    strokeCap: StrokeCap.round,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(20),
                    child: Column(children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          widget.label,
                          textAlign: widget.textAlign(), //TextAlign.right,
                          style: TextStyle(
                              fontSize: widget.fontSize(),
                              fontWeight: widget.fontWeight(),
                              fontFamily: widget.fontFamily(),
                              fontStyle: widget.fontItalic()
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                              decoration: widget.fontUnderline()
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              decorationStyle: TextDecorationStyle.solid
                              // fontFamily:
                              ),
                        )),
                        widget.image == null ? SizedBox() :
                        Image(
                          image: widget.image.image,
                          width: 50,
                          height: 50,
                        )
                        ])),
                Visibility(
                    visible: widget.children_dettached &&
                        widget.direction() == Side.right,
                    child:
                        Icon(Icons.add_circle_outline, size: 10)),
              ])),
        ));
  }
}
