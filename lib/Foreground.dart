import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'Edge.dart';
import 'nodewidget/NodeWidget.dart';

import 'MindMap.dart';
import 'nodewidget/NodeWidgetBase.dart';
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
  double left_;
  double top_;
  double scale;
  DragUtil drag_ = DragUtil();

  Foreground() {
    this.scale = 1.0;
  }

  void SetScale(double scale) {
    this.scale = scale;
    node_widget_list.forEach((e) {
      NodeWidgetBase nw = e;
      nw.SetScale(scale);
    });
  }

  void centerlize() {
    // MindMap map = MindMap();
    // NodeWidget nw = map.root.widget();

    // Offset dst = Offset(Utils.screenSize().width/2, Utils.screenSize().height/2);
    // Offset diff = dst - nw.moveOffset;

    // node_widget_list.forEach((e) {
    //   NodeWidget nw = e;
    //   nw.moveToPostion(nw.moveOffset + diff);
    // });
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

    print("foreground padding: " + state_.pl.toString()+","+state_.pt.toString());
    print("foreground mouse pos: " + drag_.delta.dx.toString()+","+drag_.delta.dy.toString());
    var newpl = state_.pl + drag_.delta.dx;
    var newpt = state_.pt + drag_.delta.dy;
    if (newpl <= Utils.screenSize().width / 2 && newpl >= -Utils.screenSize().width * 5 / 2) {
      state_.pl = newpl;
    }
    if (newpt <= Utils.screenSize().height / 2 && newpt >= -Utils.screenSize().height * 5 / 2) {
      state_.pt = newpt;
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
  }

  void _toggleFavorite() {
    print("testtesttest");
  }

  void addNode(node) {
    print("Foreground: addNode");
    node_widget_list.add(node.widget());
    // state_.widget_list.add(node.widget());

    HashSet<Edge> edges = node.to_edges;
    if (edges != null) {
      edges.forEach((e) {
        edge_widget_list.insert(0, e.widget());
        // state_.widget_list.insert(0, e.widget());
      });
    }
    if (state_ != null) {
      state_.setState(() {});
    }
  }

  void removeNode(node) {
    print("Foreground: removeNode1");
    if (node.children != null) {
      node.children.forEach((e) {
        removeNode(e);
      });
    }

    print("Foreground: removeNode2 " + node_widget_list.length.toString());
    node_widget_list.remove(node.widget());
    HashSet<Edge> edges = node.to_edges;
    if (edges != null) {
      edges.forEach((e) {
        edge_widget_list.remove(e.widget());
      });
    }
    print("Foreground: removeNode3 " + node_widget_list.length.toString());
    print("Foreground: removeNode4");
    state_?.setState(() {});
  }

  void rebuild() {
    MindMap map = MindMap();
    print("createState1");
    map.GatherNodeWidgets(map.root, node_widget_list);
    map.GatherEdgeWidgets(map.root, edge_widget_list);
    state_?.setState(() {});
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
  double pl=-Utils.screenSize().width;
  double pt=-Utils.screenSize().height;
  double ml=0;
  double mt=0;
  double canvas_width = Utils.screenSize().width * 3;
  double canvas_height = Utils.screenSize().height * 3;
  @override
  Widget build(BuildContext context) {
    return  Positioned(
      left: pl,
      top: pt,
      width: canvas_width,
      height: canvas_height,
      child: Container(
        margin: EdgeInsets.only(left: ml, top: mt),
        color: Colors.green,
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
            )
          ]
        )
      )
    );
  }
}