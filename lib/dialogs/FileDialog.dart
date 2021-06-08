import 'package:FlutterMind/operations/OpLoadFromFile.dart';
import 'package:FlutterMind/operations/OpWriteToFile.dart';
import 'package:flutter/material.dart';

import '../Foreground.dart';

class FileDialog extends StatefulWidget {
  static Future show(BuildContext ctx) async {
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
                      // title: Text("提示信息"),
                      content: FileDialog()
                      );
        });
    print("result   -- >  " + result.toString());
    return result;
  }

  @override
  State<StatefulWidget> createState() {
    return FileDialogState();
  }
}

class FileDialogState extends State <FileDialog> {

  FileDialogState() {
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
                IconButton(color: Colors.red, icon: new Icon(Icons.access_alarms),
                  tooltip: '打开',
                  onPressed: () {
                    OpLoadFromFile("Load").doAction();
                    Navigator.pop(context);
                  },
                ),
                IconButton(color: Colors.red, icon: new Icon(Icons.access_time),
                  tooltip: '保存',
                  onPressed: () {
                    OpWriteToFile("Save").doAction();
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