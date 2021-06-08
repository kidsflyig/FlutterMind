import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/material.dart';

import '../Node.dart';
import '../utils/DragUtil.dart';

class NodeWidgetBase extends StatefulWidget {
  Node node;
  DragUtil drag_ = DragUtil();
  double scale_;
  double width = 50.0;
  double height = 50.0;
  State<NodeWidgetBase> state;
  NodeWidgetBase({
    Key key,
    this.node
  }) : super(key: key) {
  }

  void setSelected(selected) {
  }

  void SetScale(double scale) {
    scale_ = scale;
    width = ScreenUtil.getDp(plain_text_node_width) * (scale_);
    height = ScreenUtil.getDp(plain_text_node_width) * (scale_);
  }

  Offset center() {
    return drag_.moveOffset.translate(width / 2, height / 2);
  }

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}