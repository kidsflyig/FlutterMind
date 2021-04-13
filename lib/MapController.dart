import 'Document.dart';
import 'Edge.dart';
import 'Node.dart';

class MapController {
  static Map<Document, MapController> controllers;

  Map<Node, Edge> edges;

  MapController() {
    edges = new Map<Node, Edge>();
  }

  static of(Document doc) {
    if (controllers == null) {
      controllers = Map<Document, MapController>();
    }
    if (controllers[doc] == null) {
      controllers[doc] = new MapController();
    }

    return controllers[doc];
  }

  addEdge(Node from, Node to) {
    edges[to] = new Edge(from, to);
  }
}