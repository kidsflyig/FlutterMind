import 'package:FlutterMind/operations/OpCenterlize.dart';
import 'package:FlutterMind/operations/OpLoadFromFile.dart';
import 'package:FlutterMind/operations/OpWriteToFile.dart';
import 'package:flutter/material.dart';

import '../Foreground.dart';

class OperationDialog extends StatefulWidget {
  Foreground _foreground;
  OperationDialog(this._foreground);
  static Future show(BuildContext ctx, foreground) async {
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
                      // title: Text("提示信息"),
                      content: OperationDialog(foreground)
                      );
        });
    print("result   -- >  " + result);
    return result;
  }

  @override
  State<StatefulWidget> createState() {
    return OperationDialogState();
  }
}

class OperationDialogState extends State <OperationDialog> {

  OperationDialogState() {
  }
  Widget build(BuildContext context) {
    return Container(
        // height:50,
        // width:100,
        child: Table(
          columnWidths: {
            0:FixedColumnWidth(50),
            1:FixedColumnWidth(50),
          },
          children: [
            TableRow(
              children: [
                IconButton(color: Colors.red, icon: new Icon(Icons.center_focus_strong),
                  tooltip: '居中显示',
                  onPressed: () {
                    OpCenterlize(widget._foreground, "居中").doAction();
                    Navigator.pop(context);
                  },
                ),
                IconButton(color: Colors.red, icon: new Icon(Icons.access_time),
                  tooltip: '其他',
                  onPressed: () {
                    // OpWriteToFile("Save").doAction();
                    Navigator.pop(context);
                  },
                ),
              ]
            ),
          ],
        )
        // painter: MyPainter(data),
      );
  }
}