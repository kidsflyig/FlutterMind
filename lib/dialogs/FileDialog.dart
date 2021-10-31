import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/MindMapBrowser.dart';
import 'package:FlutterMind/dialogs/LoadingDialog.dart';
import 'package:FlutterMind/operations/OpCreateNew.dart';
import 'package:FlutterMind/operations/OpLoadFromFile.dart';
import 'package:FlutterMind/operations/OpWriteToFile.dart';
import 'package:FlutterMind/third_party/SimpleImageButton.dart';
import 'package:FlutterMind/utils/Constants.dart';
import 'package:FlutterMind/utils/FileUtil.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/PopRoute.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FileDialog extends StatefulWidget {
  static Future show(BuildContext ctx) async {
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return ConstrainedBox(
              //在Dialog的外层添加一层UnconstrainedBox
              constraints: BoxConstraints(minWidth: 50),
              child: Dialog(
                  insetPadding: EdgeInsets.zero,
                  child: Container(
                      color: Colors.white, height: 300, child: FileDialog())));
        });
    return result;
  }

  static Future showMyDialog(BuildContext context) async {
    Navigator.push(
        context,
        PopRoute(
          child: Center(child: FileDialog())));
  }

  @override
  State<StatefulWidget> createState() {
    return FileDialogState();
  }
}

class FileDialogState extends State<FileDialog> {
  FileDialogState() {}
  Widget build(BuildContext context) {
    var width = ScreenUtil.getDp(C.dialog_file_btn_width);
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),//边框
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(6, 7),
              color: Colors.black12,
              blurRadius: 5, // 阴影的模糊程度
              spreadRadius: 0,
            )
          ],
        ),
        width: 180,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              SimpleImageButton(
                width: width,
                mode: SIBMode.VERTICAL,
                normalImage: 'assets/icons/icon_file_new.png',
                pressedImage: 'assets/icons/icon_file_new.png',
                title: '新建',
                onPressed: () {
                  MapController().createNew();
                  Navigator.pop(context);
                },
              ),
              Container(height: 40, width:1, color:Colors.grey),
              SimpleImageButton(
                width: width,
                mode: SIBMode.VERTICAL,
                normalImage: 'assets/icons/icon_file_save.png',
                pressedImage: 'assets/icons/icon_file_save.png',
                title: '保存',
                onPressed: () {
                  MapController().save();
                  Navigator.pop(context);
                },
              ),
            ]),
            Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              SimpleImageButton(
                width: width,
                mode: SIBMode.VERTICAL,
                normalImage: 'assets/icons/icon_file_open.png',
                pressedImage: 'assets/icons/icon_file_open.png',
                title: '打开',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MindMapBrowser();
                      }));
                },
              ),
              Container(height: 40, width:1, color:Colors.grey),
              SimpleImageButton(
                width: width,
                mode: SIBMode.VERTICAL,
                normalImage: 'assets/icons/icon_file_login.png',
                pressedImage: 'assets/icons/icon_file_login.png',
                title: '登录',
                onPressed: () {
                  // TODO, 接入腾讯云开发flutter sdk
                  Navigator.pop(context);
                },
              ),
            ]),
            Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              SimpleImageButton(
                width: width,
                mode: SIBMode.VERTICAL,
                normalImage: 'assets/icons/icon_file_open.png',
                pressedImage: 'assets/icons/icon_file_open.png',
                title: '导出图片',
                onPressed: () {
                  Navigator.pop(context);
                  LoadingDialog loading = LoadingDialog.show(context);
                  MapController().exportAsImage(() {
                    Log.e("exportAsImage done");
                    loading.hide();
                  });
                },
              ),
              Container(height: 40, width:1, color:Colors.grey),
              SimpleImageButton(
                width: width,
                mode: SIBMode.VERTICAL,
                normalImage: 'assets/icons/icon_file_login.png',
                pressedImage: 'assets/icons/icon_file_login.png',
                title: '退出',
                onPressed: () {
                  // TODO, 接入腾讯云开发flutter sdk
                  SystemNavigator.pop();
                },
              ),
            ]),
            SizedBox(height: 20)
          ],
        ));
  }
}
