import 'dart:ui';
import 'package:FlutterMind/Node.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:flutter/material.dart';

import 'MapController.dart';
import 'operations/Operation.dart';
import 'utils/Utils.dart';

class ChildrenDrawerView extends StatefulWidget {
  ChildrenDrawerView();

  @override
  _ChildrenDrawerViewState createState() => _ChildrenDrawerViewState();
}

class _ChildrenDrawerViewState extends State<ChildrenDrawerView> {

  @override
  Widget build(BuildContext context) {
    NodeWidgetBase selected = MapController().getSelected();
    Node node = selected.node;
    var controller = new ScrollController();
    return Container(
      padding: EdgeInsets.only(left: 17,right: 17),
      color: Colors.white,
      height: Utils.screenSize().height,
      width: Utils.screenSize().width / 3,
      child: ListView.builder(
            itemCount: selected.node.children.length,
            controller: controller,
            itemBuilder: (BuildContext context, int index) {
              NodeWidgetBase c = node.children[index].widget();
              return Text(c.label);
            },
          )
    );
  }
}