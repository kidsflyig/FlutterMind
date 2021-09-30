import 'dart:ui';
import 'package:FlutterMind/Node.dart';
import 'package:FlutterMind/utils/FileUtil.dart';
import 'package:FlutterMind/utils/PopRoute.dart';
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
    return Container(
      padding: EdgeInsets.only(left: 17,right: 17),
      color: Colors.white,
      height: Utils.screenSize().height,
      width: Utils.screenSize().width / 3,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Text('子节点', style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 20,),
            ),
            SliverGrid(
                delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
                  NodeWidgetBase c = node.children[index].widget();
                  return InkWell(
                    onTap: () {
                      MapController().centerlizeWidget(c);
                      Navigator.pop(context);
                    },
                    child:Text(c.label)
                  );
                }, childCount: selected.node.children.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 11,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1)
            ),
          ],
        ),
      ),
    );
  }
}