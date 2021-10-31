import 'dart:ui';
import 'package:FlutterMind/utils/FileUtil.dart';
import 'package:FlutterMind/utils/PopRoute.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MapController.dart';
import 'dialogs/EditingDialog.dart';
import 'operations/Operation.dart';
import 'utils/Utils.dart';

class DetailDrawerView extends StatefulWidget {
  DetailDrawerView();

  @override
  _DetailDrawerViewState createState() => _DetailDrawerViewState();
}

class _DetailDrawerViewState extends State<DetailDrawerView> {
  String tmp = "";

  @override
  Widget build(BuildContext context) {
    NodeWidgetBase selected = MapController().getSelected();
    return Container(
      padding: EdgeInsets.only(left: 17, right: 17),
      color: Colors.white,
      height: Utils.screenSize().height,
      width: Utils.screenSize().width / 3,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Text(
                '详情',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Text("内容"),
                Container(
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(selected.label)),
                Text("样式"),
                Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(selected.styleName())),

                Text("图标"),
                Container(
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(4)),
                    child: Row(children:selected.icons)
                ),
                Text("图片"),
                Container(
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(4)),
                    child: selected.image == null
                        ? Text("没有图片")
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PopRoute(
                                      child: Image(
                                          width: 500,
                                          height: 500,
                                          fit: BoxFit.fitWidth,
                                          image: selected.image.image)));
                            },
                            child: Image(
                                width: 500,
                                height: 500,
                                fit: BoxFit.fitWidth,
                                image: selected.image.image))),
                Text("链接"),
                Container(
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(4)),
                    child: InkWell(
                        child: Text(selected.url ?? ""),
                        onTap: () {
                          launch(selected.url);
                        })),
                Text("备注"),
                Container(
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(4)),
                    child: InkWell(
                        child: Text(selected.note ?? ""),
                        onTap: () {
                          EditingDialog.showMyDialog(
                              context,
                              EditConfig(
                                  pos: Utils.center(),
                                  maxLength: 20,
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  onSubmit: (msg) {
                                    selected.note = msg;
                                    setState(() {});
                                  }));
                        }))
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
