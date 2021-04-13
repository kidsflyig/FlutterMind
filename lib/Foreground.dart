import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/NodeWidget.dart';

import 'Document.dart';

class Foreground extends StatelessWidget {
  List<Widget> node_widget_list = [];
  List<Widget> edge_widget_list = [];

  void onPanStart(detail) {
    node_widget_list.forEach((e) {
      NodeWidget nw = e;
      nw.onPanStart(detail);
    });
  }

  void onPanUpdate(detail){
    node_widget_list.forEach((e) {
      NodeWidget nw = e;
      nw.onPanUpdate(detail);
    });
  }

  void onPanEnd(detail) {
    node_widget_list.forEach((e) {
      NodeWidget nw = e;
      nw.onPanEnd(detail);
    });
  }

  @override
  Widget build(BuildContext context) {
    Document document = Document();
    print("document hashcode="+document.hashCode.toString());

    document.GenerateNodes();
    document.GatherNodeWidgets(document.root, node_widget_list);
    document.GatherEdgeWidgets(document.root, edge_widget_list);
    List<Widget> widget_list = [];
    widget_list.addAll(edge_widget_list);
    widget_list.addAll(node_widget_list);

    return  new Scaffold(
      backgroundColor: Color.fromARGB(0x00, 0, 0, 0),
      body:new Stack(
        children: widget_list
      )
    );
  }

  void _toggleFavorite() {
    print("testtesttest");
  }

}