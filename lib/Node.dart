import 'dart:collection';

import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/widgets/RootNodeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'MindMapView.dart';
import 'layout/Layout.dart';
import 'MindMap.dart';
import 'Edge.dart';
import 'MapController.dart';
import 'widgets/NodeWidget.dart';

enum NodeType {
  rootNode,
  plainText,
  image
}

class Node {
  int id;
  NodeType type;
  Layout layout;

  List<Node> children;
  HashSet<Edge> from_edges;
  HashSet<Edge> to_edges;
  MindMap map;
  Node parent;
  // double left = 0;
  // double top = 0;
  GlobalKey key;
  NodeWidgetBase _widget;
  Node(this.type) {
    id = nextID();
  }

  static Node create(type) {
    if (type == NodeType.plainText) {
      return TextNode();
    } else {
      return Node(NodeType.rootNode);
    }
  }

  Node clone() {
    Node n = Node.create(type);
    return n;
  }

  Node.fromId(this.type, int id) {
    this.id = id;
  }

  static int _next_id = 0;
  static int nextID() {
    return ++_next_id;
  }

  addChild(Node node, {Direction direction = Direction.auto}) {
    print("Node addChild");
    node.parent = this;
    if (children == null) {
      children = List();
    }

    if (node.map == null && map != null) {
      node.map = map;
    }
    children.add(node);
    new Edge(this, node);

     widget(); // createWidget
    _widget.addChild(node, direction:direction);
  }

  void insertBefore(Node n, Node target) {
    n.parent = this;

    Log.e("Node insertChild "+n.id.toString()+" , " + target.id.toString());
    int idx = children.indexOf(target);
    children.insert(idx, n);
    new Edge(n.parent, n);
    _widget.insertBefore(n, target);
  }

  void insertAfter(Node n, Node target) {
    n.parent = this;

    Log.e("Node insertAfter "+n.id.toString()+" , " + target.id.toString());
    int idx = children.indexOf(target);
    children.insert(idx + 1, n);
    new Edge(n.parent, n);
    _widget.insertAfter(n, target);
  }

  void removeNode(Node node) {
    print("removeNode1");
    if (children == null)
      return;

    children.remove(node);
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
    _widget.removeFromParent();
    parent.removeNode(this);
  }

  void addEdge(Edge e, bool from) {
    Log.i("Node addEdge");
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
      _widget = NodeWidgetBase.create(this);
      if (type == NodeType.rootNode) {
        print("create NodeWidget2 ");
        RootNodeWidget w = _widget;
        w.moveToPostion(MindMapView.Center());
      }
    }

    return _widget;
  }

  Node root() {
    if (map == null) {
      map = MindMap();
    }
    return map.root;
  }

  void selected(selected) {
    // Node prev = map.selectedNode();
    // prev.selected()
  }

  // void moveToPosition(Offset offset) {
  //   left = offset.dx;
  //   top = offset.dy;
  //   if (_widget is NodeWidgetBase) {
  //     (_widget as NodeWidgetBase).moveToPosition(offset);
  //   }
  // }
}

class TextNode extends Node {
  String data;
  TextNode():super(NodeType.plainText);
}