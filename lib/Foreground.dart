import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'Edge.dart';
import 'NodeWidget.dart';

import 'MindMap.dart';
import 'operations/OpCenterlize.dart';
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
  DragUtil drag_ = DragUtil();

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
    return [OpCenterlize(this, "centerlize")];
  }

  void onPanStart(detail) {
    // node_widget_list.forEach((e) {
    //   NodeWidget nw = e;
    //   nw.onPanStart(detail);
    // });
    drag_.onPanStart(detail);

    // state_.setState(() {
    //   // if (drag_.moveOffset.dx < 0) {
    //     state_.pl = drag_.moveOffset.dx;
    //     // state_.ml = 0;
    //   // } else {
    //     // state_.pl = 0;
    //     // state_.ml = drag_.moveOffset.dx;
    //   // }

    //   // if (drag_.moveOffset.dy < 0) {
    //     state_.pt = drag_.moveOffset.dy;
    //     // state_.mt = 0;
    //   // } else {
    //     // state_.pt = 0;
    //     // state_.mt = drag_.moveOffset.dy;
    //   // }

    //   print("foreground padding: " + state_.pl.toString()+","+state_.pt.toString());
    //   // print("foreground margin: " + state_.ml.toString()+","+state_.mt.toString());
    // });
  }

  void onPanUpdate(detail){
    drag_.onPanUpdate(detail);
    state_.setState(() {
      // if (drag_.moveOffset.dx < 0) {
        state_.pl = drag_.moveOffset.dx;
        // state_.ml = 0;
      // } else {
        // state_.pl = 0;
        // state_.ml = drag_.moveOffset.dx;
      // }

      // if (drag_.moveOffset.dy < 0) {
        state_.pt = drag_.moveOffset.dy;
        // state_.mt = 0;
      // } else {
        // state_.pt = 0;
        // state_.mt = drag_.moveOffset.dy;
      // }

      print("foreground padding: " + state_.pl.toString()+","+state_.pt.toString());
      // print("foreground margin: " + state_.ml.toString()+","+state_.mt.toString());
    });
  }

  void onPanEnd(detail) {
    drag_.onPanEnd(detail);
    node_widget_list.forEach((e) {
      NodeWidget nw = e;
      nw.moveToPostion(Offset(state_.pl, state_.pt));
    });

    state_.setState(() {
      state_.pl = 0;
      state_.pt = 0;
    });

    drag_.clear();
  }

  void _toggleFavorite() {
    print("testtesttest");
  }

  void addNode(node) {
    node_widget_list.add(node.widget());
    state_.widget_list.add(node.widget());

    HashSet<Edge> edges = node.to_edges;
    if (edges != null) {
      edges.forEach((e) {
        edge_widget_list.insert(0, e.widget());
        state_.widget_list.insert(0, e.widget());
      });
    }
    if (state_ != null) {
      state_.setState(() {

      });
    } else {
      print("addNode state is null");
    }
  }

  @override
  State<StatefulWidget> createState() {
    state_ = ForegroundState();

    MindMap map = MindMap();
    map.GenerateNodes();
    print("createState1");
    map.GatherNodeWidgets(map.root, node_widget_list);
    map.GatherEdgeWidgets(map.root, edge_widget_list);

    List<Widget> widget_list = [];
    widget_list.addAll(edge_widget_list);
    widget_list.addAll(node_widget_list);
    state_.widget_list = widget_list;
    return state_;
  }
}

class ForegroundState extends State<Foreground> {
  List<Widget> widget_list = [];
  double pl=0;
  double pt=0;
  double ml=0;
  double mt=0;
  @override
  Widget build(BuildContext context) {
    return  Positioned(
      left: pl,
      top: pt,
      right: 0,
      bottom: 0,
      child: Container(
        margin: EdgeInsets.only(left: ml, top: mt),
        color: Color.fromARGB(0xf0, 0, 0, 0),
        // width: Utils.screenSize().width,
        // height: Utils.screenSize().height,
        child: new Stack(
          children: widget_list
        )
      )
    );
  }
}