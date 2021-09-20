import 'dart:ui';
import 'package:FlutterMind/utils/FileUtil.dart';
import 'package:FlutterMind/utils/PopRoute.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:flutter/material.dart';

import 'MapController.dart';
import 'operations/Operation.dart';
import 'utils/Utils.dart';

class DetailDrawerView extends StatefulWidget {
  DetailDrawerView();

  @override
  _DetailDrawerViewState createState() => _DetailDrawerViewState();
}

class _DetailDrawerViewState extends State<DetailDrawerView> {
  @override
  Widget build(BuildContext context) {
    NodeWidgetBase selected = MapController().getSelected();
    return Container(
      padding: EdgeInsets.only(left: 17,right: 17),
      color: Colors.white,
      height: Utils.screenSize().height,
      width: Utils.screenSize().width / 3,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Text('详情', style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 20,),
            ),
            SliverGrid(
                delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
                  if (index == 0) {
                    return Container(
                      child: Text(selected.label)
                    );
                  } else if (index == 1) {
                    return Text(selected.styleName());
                  } else if (index == 2) {
                    return selected.image == null ? Text("没有图片") :
                        InkWell(
                          onTap: () {
                            Navigator.push(context, PopRoute(child: Image(
                              width: 500,
                              height: 500,
                              fit: BoxFit.fitWidth,
                              image: selected.image.image
                            )));
                          },
                          child:Image(
                        width: 500,
                        height: 500,
                        fit: BoxFit.fitWidth,
                        image: selected.image.image
                      ));
                  } else {
                    return InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(0xff, 0xeb, 0xeb, 0xec),
                            borderRadius: BorderRadius.circular(4)
                        ),
                        child: Text("打发打发"),
                      ),
                      onTap: () {
                        print("item " + index.toString() + " clicked");
                      },
                    );
                  }
                }, childCount: 5),
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