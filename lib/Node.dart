import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'MindMap.dart';
import 'Edge.dart';
import 'MapController.dart';
import 'NodeWidget.dart';

enum NodeType {
  rootNode,
  plainText,
  image
}

class Node {
  NodeType type;
  HashSet<Node> children;
  HashSet<Edge> from_edges;
  HashSet<Edge> to_edges;
  MindMap map;
  Node parent;
  double left;
  double top;
  GlobalKey key;
  Widget _widget;
  Node(this.type);

  addChild(Node node) {
    print("Node addChild");
    node.parent = this;
    if (children == null) {
      children = HashSet();
    }

    if (node.map == null && map != null) {
      node.map = map;
    }
    children.add(node);

    new Edge(this, node);
  }

  void addEdge(Edge e, bool from) {
    if (from) {
      if (from_edges == null) {
        from_edges = HashSet();
      }

      from_edges.add(e);
    } else {
      if (to_edges == null) {
        to_edges = HashSet();
      }

      to_edges.add(e);
    }

    print(this.hashCode.toString()+ ", " +e.hashCode.toString());
  }

  Widget widget() {
    if (_widget == null) {
      var key = ObjectKey(this);
      print("create NodeWidget " + key.toString());
      _widget = NodeWidget(key:key, node:this);
    }
    // key = GlobalKey();
    return _widget;
    // return NodeWidget(key:key);
    // return Positioned(
    //   left: this.left,
    //   top: this.top,
    //   child: new IconButton(
    //   icon: new Icon(Icons.star),

    //   onPressed: () {  },
    //   )
    // );
  }

  void selected(selected) {
    // Node prev = map.selectedNode();
    // prev.selected()
  }
}

class TextNode extends Node {
  TextNode():super(NodeType.plainText);
}