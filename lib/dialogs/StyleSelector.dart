import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:flutter/material.dart';

class StyleSelectorDialog extends StatefulWidget {
  StyleSelectorDialog();

  static Future show(BuildContext ctx) async {
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(content: StyleSelectorDialog());
        });

    return result;
  }

  static void showStyleSelector(context) {
    var width = Utils.screenSize().width / 2;
    var height = Utils.screenSize().height / 2;

    showMenu(
        context:context,
        position:RelativeRect.fromLTRB(width - 80, height - 20, width + 80, height + 20) ,
        items: [
          PopupMenuItem(
            child: Container(
              color: Colors.green,
            )
          ),
          PopupMenuItem(
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                Text("搜索")
              ],
            ),
          )
        ]
    );
  }
  @override
  State<StatefulWidget> createState() {
    return StyleSelectorDialogState();
  }
}

class StyleSelectorDialogState extends State<StyleSelectorDialog> {
  StyleSelectorDialogState() {}

  Widget build(BuildContext context) {
    return Container(height: 50, width: 100,
    child:GestureDetector(
          child:
            Container(
              width:10,
              height:10,
          ),
          onTap: () {

          },
        ));
  }
}
