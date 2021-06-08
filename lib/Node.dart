import 'dart:collection';

import 'package:FlutterMind/nodewidget/RootNodeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Layout.dart';
import 'MindMap.dart';
import 'Edge.dart';
import 'MapController.dart';
import 'nodewidget/NodeWidget.dart';

enum NodeType {
  rootNode,
  plainText,
  image
}

class Node {
  int id;
  NodeType type;
  Layout layout;
  HashSet<Node> children;
  HashSet<Edge> from_edges;
  HashSet<Edge> to_edges;
  MindMap map;
  Node parent;
  double left;
  double top;
  GlobalKey key;
  Widget _widget;
  Node(this.type) {
    id = nextID();
    layout = new Layout(this);
  }

  Node.fromId(this.type, int id) {
    this.id = id;
  }

  static int _next_id = 0;
  static int nextID() {
    return ++_next_id;
  }

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
    layout.layout(node);
    new Edge(this, node);
  }

  void removeNode(Node node) {
    print("removeNode1");
    if (children == null)
      return;

    print("removeNode2");
    if (from_edges != null) {
      from_edges.removeWhere((e) => (e.to == node));
    }
  }

  void removeFromParent() {
    print("removeFromParent1");
    if (parent == null)
      return;
    print("removeFromParent2");
    parent.removeNode(this);
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
      if (type == NodeType.rootNode) {
        _widget = RootNodeWidget(key:key, node:this);
        RootNodeWidget w = _widget;
        w.width = 200;
        w.height = 100;
      } else if (type == NodeType.plainText) {
        _widget = NodeWidget(key:key, node:this);
      }
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
  String data;
  TextNode():super(NodeType.plainText);
}