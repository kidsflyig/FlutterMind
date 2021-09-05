import 'dart:io';
import 'dart:convert';
// import 'package:file_picker/file_picker.dart';

import 'package:FlutterMind/MindMap.dart';
import 'package:FlutterMind/utils/FileUtil.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Operation.dart';

class OpDeleteFile extends Operation {
  String file_name;
  OpDeleteFile(this.file_name):super("Delete") {
    will_record = false;
  }

  void doAction() {
    DeleteFile();
  }

  Future<void> DeleteFile() async {
    if (Utils().is_android) {
      try {
        await FileUtil().delete(file_name);
        Fluttertoast.showToast(msg: "删除成功");
      } catch(e) {
        Fluttertoast.showToast(msg: "删除失败");
      }
    } else {
      Log.i("平台不支持删除文件");
    }
  }
}
