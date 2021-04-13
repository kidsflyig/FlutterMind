import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Document.dart';
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
  HashSet<Edge> edges;
  Document document;
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

    if (node.document == null && document != null) {
      node.document = document;
    }
    children.add(node);

    new Edge(this, node);
  }

  void addEdge(Edge e) {
    if (edges == null) {
      edges = HashSet();
    }
    edges.add(e);
    print(this.hashCode.toString()+ ", " +e.hashCode.toString());
  }

  Widget widget() {
    _widget = _widget ?? NodeWidget(this);
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
}

class TextNode extends Node {
  TextNode():super(NodeType.plainText);
}