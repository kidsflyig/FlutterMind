import 'dart:collection';
// import 'dart:html';
import 'dart:math';

import 'package:FlutterMind/Foreground.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/TreeNode.dart';
import 'package:FlutterMind/dialogs/EditingDialog.dart';
import 'package:FlutterMind/layout/BidiLayout.dart';
import 'package:FlutterMind/layout/LayoutController.dart';
import 'package:FlutterMind/layout/LayoutObject.dart';
import 'package:FlutterMind/third_party/dotted_border/dotted_border.dart';
import 'package:FlutterMind/utils/FileUtil.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/utils/base.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:FlutterMind/widgets/RootNodeWidget.dart';
import 'package:flutter/material.dart';

import 'LinedEdge.dart';
import '../MapController.dart';
import 'Edge.dart';

class NodeWidget extends NodeWidgetBase {
  bool children_dettached = false;
  NodeWidget({Key key}) : super(key: key) {
    layout = LayoutController().newLayout(this);
  }

  TreeNode clone() {
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
    layout.moveToPosition(dst);

    setNeedsRepaint();
    repaint();
  }

  void SetSize(Size size) {
    Log.e("NodeWidget.SetSize");
    if (layout.width == size.width && layout.height == size.height) {
      Log.i("no need to update size");
      return;
    }

    layout.width = size.width;
    layout.height = size.height;
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
      layout.width += 50;
      setNeedsRepaint();
      repaint();
    }
  }

  Direction getDirection() {
    // BidiLayout l = layout;
    // return l.direction;
    return direction;
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
    // BidiLayout l = layout;
    children_dettached = true;
    repaint();
  }

  // @override
  // addChild(TreeNode node, Direction direction) {
  //   dynamic w = node.widget();
  //   Layout l = w.layout;
  //   layout.addChild(l, node.direction);
  //   setNeedsRepaint();
  //   repaint();
  // }

  void updateEdges() {
    Log.i("NodeWidget updateEdges");
    HashSet<Edge> from_edges = super.from_edges;

    if (from_edges != null) {
      from_edges.forEach((e) {
        Edge edge = e;
        edge.repaint();
      });
    } else {
      Log.e("NodeWidget updateEdges from_edges is null");
    }

    HashSet<Edge> to_edges = super.to_edges;
    if (to_edges != null) {
      to_edges.forEach((e) {
        Edge edge = e;
        edge.repaint();
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
  void dispose() {
    super.dispose();
    Log.e("dispose " + this.hashCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((mag) {
      RenderBox box = context.findRenderObject();
      widget.SetSize(box.size);
      //  MapController().repaint();
    });

    Log.e("node widget repaint " + selected_.toString()+", this="+this.hashCode.toString()+", widget="+widget.hashCode.toString());
    return Positioned(
        //margin: EdgeInsets.only(left: widget.moveOffset.dx, top: widget.moveOffset.dy),
        //color: Colors.purple,
        left: widget.layout.x,
        top: widget.layout.y,
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
                    widget.posInScreen(Offset(widget.layout.x, widget.layout.y));
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
                        widget.getDirection() == Direction.left,
                    child:
                        Icon(Icons.add_circle_outline, size: 10)),
                DottedBorder(
                    color: selected_ ? Colors.red : Colors.black, //widget.borderColor(),
                    bgcolor: widget.bgColor(),
                    dashPattern: selected_ ? [8, 0] : [8, 4],
                    strokeWidth: selected_ ? 4 : 2,
                    strokeCap: StrokeCap.round,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(20),
                    child: Column(children: [
                      // Row(
                      //   children: [
                      //     widget.icons
                      //     Image(
                      //       width:15,
                      //       height:15,
                      //       image: Image.asset("assets/icons/num1.png").image),
                      //     Image(
                      //       width:15,
                      //       height:15,
                      //       image: Image.asset("assets/icons/num1.png").image),
                      //   ]
                      // ),
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
                        ),
                        Row(children: [
                          widget.url == null ? SizedBox() :
                          Icon(Icons.link),
                          widget.note == null ? SizedBox() :
                          Icon(Icons.note),
                        ])
                        ])),
                Visibility(
                    visible: widget.children_dettached &&
                        widget.getDirection() == Direction.right,
                    child:
                        Icon(Icons.add_circle_outline, size: 10)),
              ])),
        ));
  }
}
