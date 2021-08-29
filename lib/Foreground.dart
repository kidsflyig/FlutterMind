import 'dart:collection';
import 'dart:math';

import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/layout/LayoutController.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/widgets/PlaceHolderWidget.dart';
import 'package:FlutterMind/widgets/PopupWidget.dart';
import 'package:flutter/material.dart';
import 'Edge.dart';
import 'Node.dart';
import 'Settings.dart';
import 'widgets/NodeWidget.dart';

import 'MindMap.dart';
import 'widgets/NodeWidgetBase.dart';
import 'operations/OpCenterlize.dart';
import 'operations/OpLoadFromFile.dart';
import 'operations/OpWriteToFile.dart';
import 'operations/Operation.dart';
import 'utils/DragUtil.dart';
import 'utils/Utils.dart';

class Foreground extends StatefulWidget {
  List<Widget> widget_list = [];
  List<Widget> node_widget_list = [];
  List<Widget> edge_widget_list = [];
  ForegroundState state_;

  double left_=-Utils.screenSize().width;
  double top_=-Utils.screenSize().height;

  // double scale;
  DragUtil drag_ = DragUtil();

  // popup
  double popup_x = 0;
  double popup_y = 0;
  double popup_width = 0;
  double popup_height = 0;
  Function popup_cb;
  PopupMode popup_mode = PopupMode.HIDE;
  double _width;
  double _height;

  Foreground() {
    // this.scale = 1.0;
    _width = Utils.screenSize().width * 3;
    _height = Utils.screenSize().height * 3;

    LayoutController().onForegroundUpdated((Rect r, cb) {
      Log.e("onForegroundUpdated = " + r.toString()+", screen size=" +Utils.screenSize().toString());
      Offset offset = Offset.zero;
      if (r.left < 0) {
        _width += (-r.left);
        offset = offset.translate(-r.left, 0);
      }

      if (r.top < 0) {
        _height += (-r.top);
        offset = offset.translate(-r.top, 0);
      }

      if (offset.dx > 0 || offset.dy > 0) {

        cb(r.translate(offset.dx, offset.dy));

        node_widget_list.forEach((e) {
          Log.e("node list moveby " + offset.toString());
          NodeWidgetBase nw = e;
          nw.moveByOffset(offset);
        });
      }

      if (r.right > _width) {
        _width += (r.right - _width);
      }

      if (r.bottom > _height) {
        _height += (r.bottom - _height);
      }

      MapController().repaint();
      _update();
    });
  }

  // void SetScale(double scale) {
  //   this.scale = scale;
  //   node_widget_list.forEach((e) {
  //     NodeWidgetBase nw = e;
  //     nw.SetScale(scale);
  //   });
  // }

  void centerlize() {
    Log.e("Foreground centerlize");
    left_ = (Utils.screenSize().width - _width) / 2;
    top_= (Utils.screenSize().height - _height) / 2;

    _update();
  }

  Color backgroundColor() {
    return Settings().backgroundColor;
  }

  List<Operation> operations() {
    return [
      OpCenterlize(this, "centerlize"),
      OpLoadFromFile("Load"),
      OpWriteToFile("Save")
      ];
  }

  void onPanStart(detail) {
    drag_.onPanStart(detail);
  }

  void onPanUpdate(detail){
    drag_.onPanUpdate(detail);

    print("foreground padding: " + left_.toString()+","+ top_.toString());
    print("foreground mouse pos: " + drag_.delta.dx.toString()+","+drag_.delta.dy.toString());
    var newpl = left_ + drag_.delta.dx;
    var newpt = top_ + drag_.delta.dy;
    if (newpl <= _width / 6 && newpl >= -_width * 5 / 6) {
      left_ = newpl;
    }
    if (newpt <= _height / 6 && newpt >= -_height * 5 / 6) {
      top_ = newpt;
    }

    state_?.setState(() {
    });
  }

  void onPanEnd(detail) {
    if (state_ == null) {
      return;
    }
    drag_.onPanEnd(detail);
    // node_widget_list.forEach((e) {
    //   NodeWidget nw = e;
    //   nw.moveToPostion(Offset(state_.pl, state_.pt));
    // });

    // state_?.setState(() {
    //   state_.pl = 0;
    //   state_.pt = 0;
    // });

    drag_.clear();

    popup_mode = PopupMode.HIDE;
    state_?.setState(() {});
  }

  void _toggleFavorite() {
    print("testtesttest");
  }

  void addWidget(w) {
    node_widget_list.add(w);
    state_?.setState(() {});
  }

  void removeWidget(w) {
    node_widget_list.remove(w);
    state_?.setState(() {});
  }

  void addNode(node) {
    Log.v("Foreground: addNode");
    node_widget_list.add(node.widget());
    // state_.widget_list.add(node.widget());

    HashSet<Edge> edges = node.to_edges;
    if (edges != null) {
      edges.forEach((e) {
        edge_widget_list.insert(0, e.widget());
        // state_.widget_list.insert(0, e.widget());
      });
    }
    state_?.setState(() {});
  }

  void removeNode(node) {
    Log.v("Foreground: removeNode");
    if (node.children != null) {
      node.children.forEach((e) {
        removeNode(e);
      });
    }

    node_widget_list.remove(node.widget());
    HashSet<Edge> edges = node.to_edges;
    if (edges != null) {
      edges.forEach((e) {
        edge_widget_list.remove(e.widget());
      });
    }

    _update();
  }

  void _showPopup(NodeWidgetBase widget, Function cb) {
    popup_x = widget.x;
    popup_y = widget.y;
    popup_width = widget.width;
    popup_height = widget.height;
    this.popup_cb = cb;
    _update();
  }

  void showInput(NodeWidgetBase widget, Function cb) {
    this.popup_mode = PopupMode.Editing;
    _showPopup(widget, cb);
  }

  void showPastePopup(NodeWidgetBase widget, Function cb) {
    Log.e("showPastePopup " + widget?.toString());
    if (widget == null) return;

    this.popup_mode = PopupMode.Pasting;
    _showPopup(widget, cb);
  }

  void repaint() {
    _update();
  }

  void _update() {
    if (state_ != null && state_.mounted) {
      state_.setState(() {
      });
    }
  }

  void hidePopup() {
    Log.e("hidePopup");
    this.popup_mode = PopupMode.HIDE;
    _update();
  }

  void hideInputPanel() {
    if (this.popup_mode == PopupMode.Editing) {
      hidePopup();
    }
  }

  void rebuild() {
    MindMap map = MindMap();
    node_widget_list.clear();
    edge_widget_list.clear();
    map.GatherNodeWidgets(map.root, node_widget_list);
    map.GatherEdgeWidgets(map.root, edge_widget_list);
    dynamic w = map.root.widget();
    w.relayout();
    MapController().repaint();
    _update();
  }

  void test() {
    MindMap map = MindMap();
    map.GenerateNodes();
  }

  @override
  State<StatefulWidget> createState() {
    state_ = ForegroundState();
    return state_;
  }
}

class ForegroundState extends State<Foreground> {
  // double pl=-Utils.screenSize().width;
  // double pt=-Utils.screenSize().height;
  double ml=0;
  double mt=0;
  double canvas_width = Utils.screenSize().width * 3;
  double canvas_height = Utils.screenSize().height * 3;
  @override
  Widget build(BuildContext context) {
    return  Positioned(
      left: widget.left_,
      top: widget.top_,
      width: widget._width,
      height: widget._height,
      child: Container(
        margin: EdgeInsets.only(left: ml, top: mt),
        color: widget.backgroundColor(),
        // color: Color.fromARGB(0x0, 0, 0, 0),
        // width: Utils.screenSize().width,
        // height: Utils.screenSize().height,
        child: Stack(
          children: [
            Stack(
              children:widget.edge_widget_list
            ),
            Stack(
              children:widget.node_widget_list
            ),
            PopupWidget(
               widget.popup_mode, widget.popup_x, widget.popup_y,
                widget.popup_width, widget.popup_height, widget.popup_cb),
          ]
        )
      )
    );
  }
}